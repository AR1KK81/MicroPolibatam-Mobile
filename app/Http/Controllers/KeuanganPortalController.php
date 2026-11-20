<?php

namespace App\Http\Controllers;

use App\Models\AuditLog;
use App\Models\Payment;
use App\Models\Rekening;
use App\Models\User;
use Illuminate\Contracts\View\View;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\StreamedResponse;

class KeuanganPortalController extends Controller
{
    /**
     * Frames 405:5, 405:6, 405:7 — Kelola Bayar (Dashboard Staf Keuangan).
     */
    public function dashboard(Request $request): View
    {
        /** @var User $user */
        $user = $request->user();

        $tab = (string) $request->query('tab', 'perlu_cek');
        if (! in_array($tab, ['perlu_cek', 'bermasalah', 'lunas'], true)) {
            $tab = 'perlu_cek';
        }

        $search = trim((string) $request->query('q', ''));

        $counts = [
            'perlu_cek' => Payment::query()->where('status_pembayaran', 'menunggu')->count(),
            'bermasalah' => Payment::query()->where('status_pembayaran', 'ditolak')->count(),
            'lunas' => Payment::query()->where('status_pembayaran', 'lunas')->count(),
            'total_lunas_amount' => (float) Payment::query()->where('status_pembayaran', 'lunas')->sum('amount'),
        ];

        $statusFilter = match ($tab) {
            'bermasalah' => 'ditolak',
            'lunas' => 'lunas',
            default => 'menunggu',
        };

        $query = Payment::query()
            ->with(['registration.track', 'registration.user', 'rekening'])
            ->where('status_pembayaran', $statusFilter)
            ->orderByDesc('payment_date');

        if ($search !== '') {
            $query->whereHas('registration', function ($q) use ($search): void {
                $q->where('full_name', 'like', '%' . $search . '%')
                    ->orWhere('registration_id', 'like', '%' . preg_replace('/\D+/', '', $search) . '%');
            });
        }

        return view('keuangan.dashboard', [
            'user' => $user,
            'tab' => $tab,
            'search' => $search,
            'counts' => $counts,
            'payments' => $query->get(),
        ]);
    }

    /**
     * Frames 405:14, 405:15, 405:16 — Detail Verifikasi Pembayaran BNI.
     */
    public function showPayment(Request $request, int $paymentId): View
    {
        /** @var User $user */
        $user = $request->user();

        $payment = Payment::query()
            ->with(['registration.track', 'registration.user', 'rekening', 'verifier'])
            ->findOrFail($paymentId);

        return view('keuangan.verify', [
            'user' => $user,
            'payment' => $payment,
        ]);
    }

    /**
     * Process payment validation (Konfirmasi Lunas OR Tolak / Revisi).
     */
    public function processPayment(Request $request, int $paymentId): RedirectResponse
    {
        /** @var User $staff */
        $staff = $request->user();

        $payment = Payment::query()
            ->with(['registration'])
            ->findOrFail($paymentId);

        $actionType = (string) $request->input('action_type', 'confirm_lunas');
        $financeNotes = trim((string) $request->input('finance_notes', ''));

        $applicantName = $payment->registration?->full_name ?? ('ID #' . $payment->registration_id);
        $regCode = $payment->registration?->registrationCode() ?? ('REG-' . $payment->registration_id);

        if ($actionType === 'reject_payment') {
            if ($financeNotes === '') {
                return back()
                    ->withInput()
                    ->withErrors(['finance_notes' => 'Catatan keuangan wajib diisi saat menolak atau meminta revisi bukti transfer.']);
            }

            $payment->status_pembayaran = 'ditolak';
            $payment->finance_notes = $financeNotes;
            $payment->verified_by = $staff->user_id;
            $payment->verified_at = now();
            $payment->save();

            AuditLog::record(
                actor: $staff->email,
                action: 'TOLAK_PEMBAYARAN',
                object: $regCode . ' (' . $applicantName . ')',
                result: 'Pembayaran ditolak/revisi: ' . mb_substr($financeNotes, 0, 120)
            );

            return redirect()
                ->route('keuangan.dashboard', ['tab' => 'bermasalah'])
                ->with('status', 'Status pembayaran ' . $applicantName . ' ditandai Bermasalah / Perlu Revisi.');
        }

        $payment->status_pembayaran = 'lunas';
        if ($financeNotes !== '') {
            $payment->finance_notes = $financeNotes;
        }
        $payment->verified_by = $staff->user_id;
        $payment->verified_at = now();
        $payment->save();

        AuditLog::record(
            actor: $staff->email,
            action: 'KONFIRMASI_LUNAS',
            object: $regCode . ' (' . $applicantName . ')',
            result: 'Pembayaran Rp ' . number_format((float) $payment->amount, 0, ',', '.') . ' dikonfirmasi LUNAS'
        );

        return redirect()
            ->route('keuangan.dashboard', ['tab' => 'lunas'])
            ->with('status', 'Pembayaran ' . $applicantName . ' berhasil dikonfirmasi LUNAS!');
    }

    /**
     * Frame 405:8 — Riwayat Transaksi & Rekonsiliasi Pembayaran.
     */
    public function riwayat(Request $request): View
    {
        /** @var User $user */
        $user = $request->user();

        $search = trim((string) $request->query('q', ''));

        $query = Payment::query()
            ->with(['registration.track', 'rekening', 'verifier'])
            ->orderByDesc('payment_date');

        if ($search !== '') {
            $query->whereHas('registration', function ($q) use ($search): void {
                $q->where('full_name', 'like', '%' . $search . '%')
                    ->orWhere('registration_id', 'like', '%' . preg_replace('/\D+/', '', $search) . '%');
            });
        }

        $payments = $query->get();

        return view('keuangan.riwayat', [
            'user' => $user,
            'search' => $search,
            'payments' => $payments,
            'totalCount' => $payments->count(),
            'totalAmount' => (float) $payments->sum('amount'),
            'lunasCount' => $payments->where('status_pembayaran', 'lunas')->count(),
            'issueCount' => $payments->where('status_pembayaran', 'ditolak')->count(),
        ]);
    }

    /**
     * Export transaction log as CSV file.
     */
    public function exportCsv(): StreamedResponse
    {
        $payments = Payment::query()
            ->with(['registration.track', 'rekening', 'verifier'])
            ->orderByDesc('payment_date')
            ->get();

        return response()->streamDownload(function () use ($payments): void {
            $handle = fopen('php://output', 'w');
            if ($handle === false) {
                return;
            }

            fputcsv($handle, ['ID Pembayaran', 'No. Registrasi', 'Nama Pendaftar', 'Jalur', 'Bank Tujuan', 'Nominal', 'Status Pembayaran', 'Catatan Keuangan', 'Tanggal Bayar']);

            foreach ($payments as $p) {
                fputcsv($handle, [
                    $p->payment_id,
                    $p->registration?->registrationCode() ?? '-',
                    $p->registration?->full_name ?? '-',
                    $p->registration?->track?->track_name ?? '-',
                    ($p->rekening?->bank_name ?? 'Bank BNI') . ' (' . ($p->rekening?->account_number ?? '-') . ')',
                    $p->amount,
                    $p->status_pembayaran,
                    $p->finance_notes ?? '-',
                    (string) $p->payment_date,
                ]);
            }

            fclose($handle);
        }, 'log_transaksi_keuangan_pmb_' . date('Ymd_His') . '.csv', [
            'Content-Type' => 'text/csv; charset=UTF-8',
        ]);
    }

    /**
     * Frames 405:12 & 405:13 — Profil Staf Keuangan.
     */
    public function profil(Request $request): View
    {
        /** @var User $user */
        $user = $request->user();

        return view('keuangan.profil', [
            'user' => $user,
            'rekening' => Rekening::query()->where('is_active', true)->first() ?? Rekening::query()->first(),
            'lunasCount' => Payment::query()->where('status_pembayaran', 'lunas')->count(),
            'pendingCount' => Payment::query()->where('status_pembayaran', 'menunggu')->count(),
        ]);
    }
}
