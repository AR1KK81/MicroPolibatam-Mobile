<?php

namespace App\Http\Controllers;

use App\Enums\UserRole;
use App\Models\AuditLog;
use App\Models\ContactPerson;
use App\Models\Document;
use App\Models\Payment;
use App\Models\Registration;
use App\Models\Rekening;
use App\Models\Track;
use App\Models\User;
use Illuminate\Contracts\View\View;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    /**
     * Display dashboard for Calon Mahasiswa Baru (maba).
     */
    public function maba(Request $request): View
    {
        /** @var User $user */
        $user = $request->user();

        $registration = Registration::query()
            ->with(['track', 'documents', 'payment.rekening'])
            ->where('user_id', $user->user_id)
            ->first();

        return view('dashboards.overview', [
            'user' => $user,
            'roleLabel' => UserRole::Maba->label(),
            'stats' => [
                [
                    'label' => 'Jalur Pilihan',
                    'value' => $registration?->track?->track_name ?? 'Belum memilih jalur',
                ],
                [
                    'label' => 'Status Pendaftaran',
                    'value' => $registration !== null ? str_replace('_', ' ', ucfirst($registration->status)) : 'Belum mendaftar',
                ],
                [
                    'label' => 'Dokumen Diunggah',
                    'value' => ($registration?->documents?->count() ?? 0) . ' / 3 Berkas',
                ],
                [
                    'label' => 'Status Pembayaran',
                    'value' => $registration?->payment !== null
                        ? ucfirst($registration->payment->status_pembayaran)
                        : 'Belum unggah bukti',
                ],
            ],
            'registration' => $registration,
        ]);
    }

    /**
     * Display dashboard for Admin Akademik (admin).
     */
    public function admin(Request $request): View
    {
        /** @var User $user */
        $user = $request->user();

        return view('dashboards.overview', [
            'user' => $user,
            'roleLabel' => UserRole::Admin->label(),
            'stats' => [
                [
                    'label' => 'Total Pendaftar',
                    'value' => (string) Registration::query()->count(),
                ],
                [
                    'label' => 'Menunggu Verifikasi',
                    'value' => (string) Registration::query()->where('status', 'menunggu_verifikasi')->count(),
                ],
                [
                    'label' => 'Berkas Menunggu Cek',
                    'value' => (string) Document::query()->where('status_verifikasi_admin', 'menunggu')->count(),
                ],
                [
                    'label' => 'Jalur Aktif',
                    'value' => (string) Track::query()->where('is_active', true)->count(),
                ],
            ],
            'registration' => null,
        ]);
    }

    /**
     * Display dashboard for Staf Keuangan (keuangan).
     */
    public function keuangan(Request $request): View
    {
        /** @var User $user */
        $user = $request->user();

        return view('dashboards.overview', [
            'user' => $user,
            'roleLabel' => UserRole::Keuangan->label(),
            'stats' => [
                [
                    'label' => 'Total Pembayaran Masuk',
                    'value' => (string) Payment::query()->count(),
                ],
                [
                    'label' => 'Menunggu Validasi',
                    'value' => (string) Payment::query()->where('status_pembayaran', 'menunggu')->count(),
                ],
                [
                    'label' => 'Pembayaran Lunas',
                    'value' => (string) Payment::query()->where('status_pembayaran', 'lunas')->count(),
                ],
                [
                    'label' => 'Rekening Aktif',
                    'value' => (string) Rekening::query()->where('is_active', true)->count(),
                ],
            ],
            'registration' => null,
        ]);
    }

    /**
     * Display dashboard for Super Admin (super_admin).
     */
    public function superAdmin(Request $request): View
    {
        /** @var User $user */
        $user = $request->user();

        return view('dashboards.overview', [
            'user' => $user,
            'roleLabel' => UserRole::SuperAdmin->label(),
            'stats' => [
                [
                    'label' => 'Total Akun Pengguna',
                    'value' => (string) User::query()->count(),
                ],
                [
                    'label' => 'Jalur Microcredential',
                    'value' => (string) Track::query()->count(),
                ],
                [
                    'label' => 'Kontak Helpdesk Aktif',
                    'value' => (string) ContactPerson::query()->where('is_active', true)->count(),
                ],
                [
                    'label' => 'Catatan Audit Log',
                    'value' => (string) AuditLog::query()->count(),
                ],
            ],
            'registration' => null,
        ]);
    }
}

