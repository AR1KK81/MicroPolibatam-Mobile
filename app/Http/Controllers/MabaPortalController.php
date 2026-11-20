<?php

namespace App\Http\Controllers;

use App\Models\AuditLog;
use App\Models\ContactPerson;
use App\Models\Document;
use App\Models\Payment;
use App\Models\Registration;
use App\Models\Rekening;
use App\Models\Track;
use App\Models\User;
use Illuminate\Contracts\View\View;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Throwable;

class MabaPortalController extends Controller
{
    /**
     * Frame 282:1243 — BERANDA PENDAFTAR (Dashboard Maba).
     */
    public function beranda(Request $request): View
    {
        /** @var User $user */
        $user = $request->user();

        $registration = Registration::query()
            ->with(['track', 'documents', 'payment.rekening'])
            ->where('user_id', $user->user_id)
            ->first();

        try {
            $contactPersons = ContactPerson::query()->where('is_active', true)->get();
        } catch (Throwable) {
            $contactPersons = collect();
        }

        return view('maba.beranda', [
            'user' => $user,
            'registration' => $registration,
            'contactPersons' => $contactPersons,
        ]);
    }

    /**
     * Frames 504:2, 504:153, 504:306 — 3-Tab Formulir Pendaftaran Maba (1. Biodata, 2. Dokumen, 3. Bayar BNI).
     */
    public function formulir(Request $request): View
    {
        /** @var User $user */
        $user = $request->user();

        $activeTab = (string) $request->query('tab', 'biodata');
        if (! in_array($activeTab, ['biodata', 'dokumen', 'bayar'], true)) {
            $activeTab = 'biodata';
        }

        $registration = Registration::query()
            ->with(['track', 'documents', 'payment.rekening'])
            ->where('user_id', $user->user_id)
            ->first();

        $tracks = Track::query()->where('is_active', true)->orderBy('track_id')->get();
        $rekening = Rekening::query()->where('is_active', true)->first()
            ?? Rekening::query()->first();

        $documentsByType = $registration?->documents?->keyBy('doc_type') ?? collect();

        return view('maba.formulir', [
            'user' => $user,
            'activeTab' => $activeTab,
            'registration' => $registration,
            'tracks' => $tracks,
            'rekening' => $rekening,
            'documentsByType' => $documentsByType,
        ]);
    }

    /**
     * Save Tab 1: Biodata & Track Microcredential.
     */
    public function saveBiodata(Request $request): RedirectResponse
    {
        /** @var User $user */
        $user = $request->user();

        $validated = $request->validate(
            [
                'full_name' => ['required', 'string', 'max:150'],
                'nik' => ['required', 'string', 'min:12', 'max:20'],
                'birth_place' => ['required', 'string', 'max:100'],
                'birth_date' => ['required', 'date'],
                'origin_school' => ['required', 'string', 'max:150'],
                'address' => ['required', 'string', 'max:1000'],
                'track_id' => ['required', 'integer', 'exists:tracks,track_id'],
            ],
            [
                'full_name.required' => 'Nama lengkap sesuai KTP wajib diisi.',
                'nik.required' => 'Nomor Induk Kependudukan (NIK) wajib diisi.',
                'birth_place.required' => 'Tempat lahir wajib diisi.',
                'birth_date.required' => 'Tanggal lahir wajib diisi.',
                'origin_school.required' => 'Asal sekolah wajib diisi.',
                'address.required' => 'Alamat lengkap domisili wajib diisi.',
                'track_id.required' => 'Silakan pilih Track Microcredential.',
            ]
        );

        $nikClean = preg_replace('/\D+/', '', (string) $validated['nik']) ?: (string) $validated['nik'];

        $registration = Registration::query()->updateOrCreate(
            ['user_id' => $user->user_id],
            [
                'track_id' => (int) $validated['track_id'],
                'nik_encrypted' => $nikClean,
                'full_name' => trim((string) $validated['full_name']),
                'birth_place' => trim((string) $validated['birth_place']),
                'birth_date' => $validated['birth_date'],
                'origin_school' => trim((string) $validated['origin_school']),
                'address' => trim((string) $validated['address']),
            ]
        );

        AuditLog::record(
            actor: $user->email,
            action: 'SAVE_BIODATA',
            object: $registration->registrationCode(),
            result: 'Menyimpan biodata pendaftaran Maba (' . $registration->full_name . ')'
        );

        return redirect()
            ->route('maba.formulir', ['tab' => 'dokumen'])
            ->with('status', 'Biodata peserta berhasil disimpan. Silakan unggah 3 dokumen wajib.');
    }

    /**
     * Save Tab 2: Upload or replace KTP, KK, or Ijazah/SKL document.
     */
    public function uploadDocument(Request $request): RedirectResponse
    {
        /** @var User $user */
        $user = $request->user();

        $registration = Registration::query()->where('user_id', $user->user_id)->first();

        if ($registration === null) {
            return redirect()
                ->route('maba.formulir', ['tab' => 'biodata'])
                ->withErrors(['biodata' => 'Silakan lengkapi dan simpan Biodata terlebih dahulu sebelum mengunggah dokumen.']);
        }

        $validated = $request->validate(
            [
                'doc_type' => ['required', 'string', 'in:ktp,kk,ijazah'],
                'document_file' => ['required', 'file', 'mimes:jpg,jpeg,png,pdf', 'max:2048'],
            ],
            [
                'doc_type.required' => 'Jenis dokumen tidak valid.',
                'document_file.required' => 'Pilih berkas dokumen terlebih dahulu.',
                'document_file.mimes' => 'Format berkas harus JPG, PNG, atau PDF.',
                'document_file.max' => 'Ukuran berkas maksimal 2 MB.',
            ]
        );

        $docType = (string) $validated['doc_type'];
        $file = $request->file('document_file');

        $uploadDir = public_path('uploads/dokumen');
        if (! is_dir($uploadDir)) {
            mkdir($uploadDir, 0755, true);
        }

        $safeSlug = preg_replace('/[^a-z0-9]+/i', '_', strtolower($registration->full_name)) ?: 'maba';
        $filename = $docType . '_' . $safeSlug . '_' . time() . '.' . $file->getClientOriginalExtension();
        $file->move($uploadDir, $filename);

        $relativePath = 'uploads/dokumen/' . $filename;

        Document::query()->updateOrCreate(
            [
                'registration_id' => $registration->registration_id,
                'doc_type' => $docType,
            ],
            [
                'file_path' => $relativePath,
                'status_verifikasi_admin' => 'menunggu',
                'admin_revision_notes' => null,
                'verified_by' => null,
                'uploaded_at' => now(),
                'verified_at' => null,
            ]
        );

        if ($registration->status === 'perlu_revisi') {
            $hasRemainingRevisions = Document::query()
                ->where('registration_id', $registration->registration_id)
                ->where('status_verifikasi_admin', 'revisi')
                ->exists();

            if (! $hasRemainingRevisions) {
                $registration->status = 'menunggu_verifikasi';
                $registration->save();
            }
        }

        AuditLog::record(
            actor: $user->email,
            action: 'UPLOAD_DOCUMENT',
            object: strtoupper($docType) . ' (' . $registration->registrationCode() . ')',
            result: 'Mengunggah dokumen ' . strtoupper($docType) . ': ' . $filename
        );

        return redirect()
            ->route('maba.formulir', ['tab' => 'dokumen'])
            ->with('status', 'Berkas ' . strtoupper($docType) . ' berhasil diunggah dan menunggu verifikasi Admin.');
    }

    /**
     * Save Tab 3: Upload BNI transfer proof to payments table.
     */
    public function uploadPayment(Request $request): RedirectResponse
    {
        /** @var User $user */
        $user = $request->user();

        $registration = Registration::query()->where('user_id', $user->user_id)->first();

        if ($registration === null) {
            return redirect()
                ->route('maba.formulir', ['tab' => 'biodata'])
                ->withErrors(['biodata' => 'Silakan isi Biodata terlebih dahulu sebelum mengunggah bukti pembayaran.']);
        }

        $request->validate(
            [
                'proof_file' => ['required', 'file', 'mimes:jpg,jpeg,png,pdf', 'max:2048'],
            ],
            [
                'proof_file.required' => 'Pilih foto atau dokumen resi transfer BNI terlebih dahulu.',
                'proof_file.mimes' => 'Format bukti transfer harus JPG, PNG, atau PDF.',
                'proof_file.max' => 'Ukuran file bukti transfer maksimal 2 MB.',
            ]
        );

        $rekening = Rekening::query()->where('is_active', true)->first()
            ?? Rekening::query()->first();

        if ($rekening === null) {
            $rekening = Rekening::query()->create([
                'bank_name' => 'Bank BNI',
                'account_number' => '1003301245',
                'account_name' => 'RPL 137 BLU POLTEK BTM UTK OPS',
                'nominal_biaya' => 200000,
                'is_active' => true,
                'created_at' => now(),
            ]);
        }

        $file = $request->file('proof_file');
        $uploadDir = public_path('uploads/bukti_bayar');
        if (! is_dir($uploadDir)) {
            mkdir($uploadDir, 0755, true);
        }

        $safeSlug = preg_replace('/[^a-z0-9]+/i', '_', strtolower($registration->full_name)) ?: 'maba';
        $filename = 'ss_bni_' . $safeSlug . '_' . time() . '.' . $file->getClientOriginalExtension();
        $file->move($uploadDir, $filename);

        $relativePath = 'uploads/bukti_bayar/' . $filename;

        Payment::query()->updateOrCreate(
            ['registration_id' => $registration->registration_id],
            [
                'rekening_id' => $rekening->rekening_id,
                'amount' => $rekening->nominal_biaya,
                'proof_file_path' => $relativePath,
                'status_pembayaran' => 'menunggu',
                'finance_notes' => null,
                'verified_by' => null,
                'payment_date' => now(),
                'verified_at' => null,
            ]
        );

        AuditLog::record(
            actor: $user->email,
            action: 'UPLOAD_PAYMENT',
            object: $registration->registrationCode(),
            result: 'Mengunggah bukti transfer BNI: ' . $filename
        );

        return redirect()
            ->route('maba.status')
            ->with('status', 'Bukti transfer BNI berhasil diunggah! Staf Keuangan akan memvalidasi pembayaran Anda.');
    }

    /**
     * Frame 396:8 — Detail Status & Berkas Maba.
     */
    public function status(Request $request): View
    {
        /** @var User $user */
        $user = $request->user();

        $registration = Registration::query()
            ->with(['track', 'documents', 'payment.rekening'])
            ->where('user_id', $user->user_id)
            ->first();

        return view('maba.status', [
            'user' => $user,
            'registration' => $registration,
        ]);
    }

    /**
     * Frame 282:1656 — Profil Saya (Calon Mahasiswa / Maba).
     */
    public function profil(Request $request): View
    {
        /** @var User $user */
        $user = $request->user();

        $registration = Registration::query()
            ->with(['track'])
            ->where('user_id', $user->user_id)
            ->first();

        return view('maba.profil', [
            'user' => $user,
            'registration' => $registration,
        ]);
    }
}
