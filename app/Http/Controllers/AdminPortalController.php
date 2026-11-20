<?php

namespace App\Http\Controllers;

use App\Models\AuditLog;
use App\Models\Document;
use App\Models\Registration;
use App\Models\User;
use Illuminate\Contracts\View\View;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\StreamedResponse;

class AdminPortalController extends Controller
{
    /**
     * Frames 396:9, 342:135, 328:417 — Kelola Berkas (Dashboard Admin Registrasi).
     */
    public function dashboard(Request $request): View
    {
        /** @var User $user */
        $user = $request->user();

        $tab = (string) $request->query('tab', 'perlu_cek');
        if (! in_array($tab, ['perlu_cek', 'perlu_revisi', 'disetujui'], true)) {
            $tab = 'perlu_cek';
        }

        $search = trim((string) $request->query('q', ''));

        $counts = [
            'perlu_cek' => Registration::query()->where('status', 'menunggu_verifikasi')->count(),
            'perlu_revisi' => Registration::query()->where('status', 'perlu_revisi')->count(),
            'disetujui' => Registration::query()->where('status', 'selesai_terverifikasi')->count(),
            'pending_docs' => Document::query()->where('status_verifikasi_admin', 'menunggu')->count(),
        ];

        $statusFilter = match ($tab) {
            'perlu_revisi' => 'perlu_revisi',
            'disetujui' => 'selesai_terverifikasi',
            default => 'menunggu_verifikasi',
        };

        $query = Registration::query()
            ->with(['user', 'track', 'documents'])
            ->where('status', $statusFilter)
            ->orderByDesc('updated_at');

        if ($search !== '') {
            $query->where(function ($q) use ($search): void {
                $q->where('full_name', 'like', '%' . $search . '%')
                    ->orWhere('origin_school', 'like', '%' . $search . '%')
                    ->orWhere('registration_id', 'like', '%' . preg_replace('/\D+/', '', $search) . '%');
            });
        }

        return view('admin.dashboard', [
            'user' => $user,
            'tab' => $tab,
            'search' => $search,
            'counts' => $counts,
            'registrations' => $query->get(),
        ]);
    }

    /**
     * Frames 396:16, 396:14, 396:15 — Validasi Berkas Maba Detail.
     */
    public function showVerification(Request $request, int $registrationId): View
    {
        /** @var User $user */
        $user = $request->user();

        $registration = Registration::query()
            ->with(['user', 'track', 'documents', 'payment'])
            ->findOrFail($registrationId);

        return view('admin.verify', [
            'user' => $user,
            'registration' => $registration,
        ]);
    }

    /**
     * Process document verification (ACC Semuanya OR Tolak & Kirim Catatan Revisi).
     */
    public function processVerification(Request $request, int $registrationId): RedirectResponse
    {
        /** @var User $admin */
        $admin = $request->user();

        $registration = Registration::query()
            ->with(['documents'])
            ->findOrFail($registrationId);

        $actionType = (string) $request->input('action_type', 'approve_all');
        $revisionNotes = trim((string) $request->input('admin_verification_notes', ''));
        $docStatuses = (array) $request->input('doc_status', []);

        if ($actionType === 'request_revision') {
            if ($revisionNotes === '') {
                return back()
                    ->withInput()
                    ->withErrors(['admin_verification_notes' => 'Catatan revisi untuk Maba wajib diisi saat meminta revisi berkas.']);
            }

            foreach ($registration->documents as $doc) {
                $chosenStatus = (string) ($docStatuses[$doc->document_id] ?? 'revisi');
                if (! in_array($chosenStatus, ['valid', 'revisi', 'menunggu'], true)) {
                    $chosenStatus = 'revisi';
                }

                $doc->status_verifikasi_admin = $chosenStatus;
                $doc->admin_revision_notes = $chosenStatus === 'revisi' ? $revisionNotes : null;
                $doc->verified_by = $admin->user_id;
                $doc->verified_at = now();
                $doc->save();
            }

            $registration->status = 'perlu_revisi';
            $registration->admin_verification_notes = $revisionNotes;
            $registration->save();

            AuditLog::record(
                actor: $admin->email,
                action: 'REVISI_BERKAS',
                object: $registration->registrationCode() . ' (' . $registration->full_name . ')',
                result: 'Catatan revisi dikirim: ' . mb_substr($revisionNotes, 0, 120)
            );

            return redirect()
                ->route('admin.dashboard', ['tab' => 'perlu_revisi'])
                ->with('status', 'Catatan revisi berkas untuk ' . $registration->full_name . ' berhasil dikirim.');
        }

        foreach ($registration->documents as $doc) {
            $doc->status_verifikasi_admin = 'valid';
            $doc->admin_revision_notes = null;
            $doc->verified_by = $admin->user_id;
            $doc->verified_at = now();
            $doc->save();
        }

        $registration->status = 'selesai_terverifikasi';
        if ($revisionNotes !== '') {
            $registration->admin_verification_notes = $revisionNotes;
        }
        $registration->save();

        AuditLog::record(
            actor: $admin->email,
            action: 'ACC_BERKAS',
            object: $registration->registrationCode() . ' (' . $registration->full_name . ')',
            result: 'Semua berkas persyaratan disetujui (Valid)'
        );

        return redirect()
            ->route('admin.dashboard', ['tab' => 'disetujui'])
            ->with('status', 'Seluruh berkas ' . $registration->full_name . ' telah di-ACC & Disetujui!');
    }

    /**
     * Frame 328:597 — Riwayat Verifikasi Berkas Maba.
     */
    public function riwayat(Request $request): View
    {
        /** @var User $user */
        $user = $request->user();

        $search = trim((string) $request->query('q', ''));

        $query = Registration::query()
            ->with(['track', 'documents.verifier'])
            ->orderByDesc('updated_at');

        if ($search !== '') {
            $query->where(function ($q) use ($search): void {
                $q->where('full_name', 'like', '%' . $search . '%')
                    ->orWhere('registration_id', 'like', '%' . preg_replace('/\D+/', '', $search) . '%');
            });
        }

        return view('admin.riwayat', [
            'user' => $user,
            'search' => $search,
            'registrations' => $query->get(),
        ]);
    }

    /**
     * Export verification history as CSV file.
     */
    public function exportCsv(): StreamedResponse
    {
        $registrations = Registration::query()
            ->with(['user', 'track', 'documents'])
            ->orderByDesc('updated_at')
            ->get();

        return response()->streamDownload(function () use ($registrations): void {
            $handle = fopen('php://output', 'w');
            if ($handle === false) {
                return;
            }

            fputcsv($handle, ['No. Registrasi', 'Nama Lengkap', 'Email', 'Jalur Microcredential', 'Status Verifikasi', 'Jumlah Dokumen', 'Catatan Admin', 'Diperbarui']);

            foreach ($registrations as $reg) {
                fputcsv($handle, [
                    $reg->registrationCode(),
                    $reg->full_name,
                    $reg->user?->email ?? '-',
                    $reg->track?->track_name ?? '-',
                    $reg->status,
                    $reg->documents->count(),
                    $reg->admin_verification_notes ?? '-',
                    (string) $reg->updated_at,
                ]);
            }

            fclose($handle);
        }, 'rekap_verifikasi_berkas_pmb_' . date('Ymd_His') . '.csv', [
            'Content-Type' => 'text/csv; charset=UTF-8',
        ]);
    }

    /**
     * Frames 396:12 & 396:13 — Profil & Pengaturan Akun Admin.
     */
    public function profil(Request $request): View
    {
        /** @var User $user */
        $user = $request->user();

        return view('admin.profil', [
            'user' => $user,
            'verifiedCount' => Document::query()->where('status_verifikasi_admin', 'valid')->count(),
            'revisionCount' => Document::query()->where('status_verifikasi_admin', 'revisi')->count(),
        ]);
    }
}
