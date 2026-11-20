<?php

namespace App\Http\Controllers;

use App\Enums\UserRole;
use App\Models\AuditLog;
use App\Models\ContactPerson;
use App\Models\Payment;
use App\Models\Registration;
use App\Models\Rekening;
use App\Models\Track;
use App\Models\User;
use Illuminate\Contracts\View\View;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Symfony\Component\HttpFoundation\StreamedResponse;

class SuperAdminPortalController extends Controller
{
    /**
     * Tab 1 (Beranda): Halo, Super Admin — 4 Stat Cards + 2x2 Menu Kelola + Aktivitas Terakhir.
     */
    public function dashboard(Request $request): View
    {
        /** @var User $user */
        $user = $request->user();

        $tracks = Track::query()->get();
        $departmentsCount = $tracks->pluck('department_name')->unique()->count();

        return view('super-admin.dashboard', [
            'user' => $user,
            'stats' => [
                'total_users' => User::query()->count(),
                'new_users_week' => User::query()->where('created_at', '>=', now()->subDays(7))->count(),
                'total_helpdesk' => ContactPerson::query()->count(),
                'active_helpdesk' => ContactPerson::query()->where('is_active', true)->count(),
                'total_rekening' => Rekening::query()->count(),
                'active_rekening' => Rekening::query()->where('is_active', true)->count(),
                'total_departments' => max($departmentsCount, 1),
                'total_tracks' => $tracks->count(),
            ],
            'recentLogs' => AuditLog::query()->orderByDesc('audit_id')->limit(6)->get(),
        ]);
    }

    /**
     * Tab 2 (Helpdesk): Daftar & Kelola Layanan Bantuan (contact_persons).
     */
    public function helpdesk(Request $request): View
    {
        /** @var User $user */
        $user = $request->user();

        $filter = (string) $request->query('status', 'semua');
        $search = trim((string) $request->query('q', ''));
        $editId = $request->query('edit');

        $allContacts = ContactPerson::query()->orderBy('cp_id')->get();

        $query = ContactPerson::query()->orderBy('cp_id');
        if ($filter === 'aktif') {
            $query->where('is_active', true);
        } elseif ($filter === 'nonaktif') {
            $query->where('is_active', false);
        }

        if ($search !== '') {
            $query->where(function ($q) use ($search): void {
                $q->where('name', 'like', '%' . $search . '%')
                    ->orWhere('phone', 'like', '%' . $search . '%')
                    ->orWhere('email', 'like', '%' . $search . '%');
            });
        }

        $editingContact = $editId !== null ? ContactPerson::query()->find((int) $editId) : null;

        return view('super-admin.helpdesk', [
            'user' => $user,
            'filter' => $filter,
            'search' => $search,
            'contacts' => $query->get(),
            'counts' => [
                'semua' => $allContacts->count(),
                'aktif' => $allContacts->where('is_active', true)->count(),
                'nonaktif' => $allContacts->where('is_active', false)->count(),
            ],
            'editingContact' => $editingContact,
            'showForm' => $request->boolean('create') || $editingContact !== null,
        ]);
    }

    /**
     * Store or Update Helpdesk Contact Person.
     */
    public function saveContact(Request $request): RedirectResponse
    {
        /** @var User $actor */
        $actor = $request->user();

        $validated = $request->validate([
            'cp_id' => ['nullable', 'integer'],
            'name' => ['required', 'string', 'max:100'],
            'role_label' => ['required', 'string', 'in:admin_pendaftaran,staf_keuangan'],
            'phone' => ['required', 'string', 'max:30'],
            'email' => ['required', 'string', 'email', 'max:150'],
            'is_active' => ['nullable', 'boolean'],
        ]);

        $cpId = $validated['cp_id'] ?? null;
        $isActive = $request->boolean('is_active', true);

        if ($cpId !== null) {
            $cp = ContactPerson::query()->findOrFail((int) $cpId);
            $cp->update([
                'name' => trim((string) $validated['name']),
                'role_label' => (string) $validated['role_label'],
                'phone' => trim((string) $validated['phone']),
                'email' => trim((string) $validated['email']),
                'is_active' => $isActive,
                'managed_by' => $actor->user_id,
            ]);

            AuditLog::record($actor->email, 'UPDATE_HELPDESK', $cp->name, 'Memperbarui layanan helpdesk');

            return redirect()->route('super-admin.helpdesk')->with('status', 'Layanan Helpdesk ' . $cp->name . ' berhasil diperbarui.');
        }

        $cp = ContactPerson::query()->create([
            'name' => trim((string) $validated['name']),
            'role_label' => (string) $validated['role_label'],
            'phone' => trim((string) $validated['phone']),
            'email' => trim((string) $validated['email']),
            'is_active' => $isActive,
            'managed_by' => $actor->user_id,
        ]);

        AuditLog::record($actor->email, 'CREATE_HELPDESK', $cp->name, 'Menambahkan layanan helpdesk baru');

        return redirect()->route('super-admin.helpdesk')->with('status', 'Layanan Helpdesk ' . $cp->name . ' berhasil ditambahkan.');
    }

    /**
     * Delete a Helpdesk Contact Person.
     */
    public function deleteContact(Request $request, int $cpId): RedirectResponse
    {
        /** @var User $actor */
        $actor = $request->user();

        $cp = ContactPerson::query()->findOrFail($cpId);
        $name = $cp->name;
        $cp->delete();

        AuditLog::record($actor->email, 'DELETE_HELPDESK', $name, 'Menghapus kontak Pusat Bantuan');

        return redirect()->route('super-admin.helpdesk')->with('status', 'Kontak Helpdesk ' . $name . ' berhasil dihapus.');
    }

    /**
     * Tab 3 (Rekening): Daftar & Kelola Nomor Rekening (`rekening`).
     */
    public function rekening(Request $request): View
    {
        /** @var User $user */
        $user = $request->user();

        $search = trim((string) $request->query('q', ''));
        $editId = $request->query('edit');

        $query = Rekening::query()->orderBy('rekening_id');
        if ($search !== '') {
            $query->where(function ($q) use ($search): void {
                $q->where('bank_name', 'like', '%' . $search . '%')
                    ->orWhere('account_number', 'like', '%' . $search . '%')
                    ->orWhere('account_name', 'like', '%' . $search . '%');
            });
        }

        $editingRekening = $editId !== null ? Rekening::query()->find((int) $editId) : null;

        return view('super-admin.rekening', [
            'user' => $user,
            'search' => $search,
            'rekenings' => $query->get(),
            'editingRekening' => $editingRekening,
            'showForm' => $request->boolean('create') || $editingRekening !== null,
        ]);
    }

    /**
     * Store or Update Rekening.
     */
    public function saveRekening(Request $request): RedirectResponse
    {
        /** @var User $actor */
        $actor = $request->user();

        $validated = $request->validate([
            'rekening_id' => ['nullable', 'integer'],
            'bank_name' => ['required', 'string', 'max:50'],
            'account_number' => ['required', 'string', 'max:50'],
            'account_name' => ['required', 'string', 'max:100'],
            'nominal_biaya' => ['required', 'numeric', 'min:0'],
        ]);

        $rekeningId = $validated['rekening_id'] ?? null;
        $isActive = $request->boolean('is_active', true);

        if ($rekeningId !== null) {
            $rekening = Rekening::query()->findOrFail((int) $rekeningId);
            $rekening->update([
                'bank_name' => trim((string) $validated['bank_name']),
                'account_number' => trim((string) $validated['account_number']),
                'account_name' => trim((string) $validated['account_name']),
                'nominal_biaya' => (float) $validated['nominal_biaya'],
                'is_active' => $isActive,
            ]);

            AuditLog::record($actor->email, 'UPDATE_REKENING', $rekening->bank_name . ' ' . $rekening->account_number, 'Memperbarui rekening pembayaran');

            return redirect()->route('super-admin.rekening')->with('status', 'Rekening ' . $rekening->bank_name . ' berhasil diperbarui.');
        }

        $rekening = Rekening::query()->create([
            'bank_name' => trim((string) $validated['bank_name']),
            'account_number' => trim((string) $validated['account_number']),
            'account_name' => trim((string) $validated['account_name']),
            'nominal_biaya' => (float) $validated['nominal_biaya'],
            'is_active' => $isActive,
            'created_at' => now(),
        ]);

        AuditLog::record($actor->email, 'CREATE_REKENING', $rekening->bank_name . ' ' . $rekening->account_number, 'Menambahkan rekening pembayaran baru');

        return redirect()->route('super-admin.rekening')->with('status', 'Rekening ' . $rekening->bank_name . ' berhasil ditambahkan.');
    }

    /**
     * Delete Rekening.
     */
    public function deleteRekening(Request $request, int $rekeningId): RedirectResponse
    {
        /** @var User $actor */
        $actor = $request->user();

        if (Rekening::query()->count() <= 1) {
            return back()->withErrors(['rekening' => 'Minimal harus ada 1 rekening utama yang terdaftar di sistem.']);
        }

        $rekening = Rekening::query()->findOrFail($rekeningId);
        $label = $rekening->bank_name . ' (' . $rekening->account_number . ')';
        $rekening->delete();

        AuditLog::record($actor->email, 'DELETE_REKENING', $label, 'Menghapus rekening pembayaran');

        return redirect()->route('super-admin.rekening')->with('status', 'Rekening ' . $label . ' berhasil dihapus.');
    }

    /**
     * Tab 4 (Jurusan & Peminatan): Daftar & Kelola Tracks (`tracks`).
     */
    public function jurusan(Request $request): View
    {
        /** @var User $user */
        $user = $request->user();

        $filter = (string) $request->query('status', 'semua');
        $search = trim((string) $request->query('q', ''));
        $editId = $request->query('edit');

        $allTracks = Track::query()->orderBy('department_name')->orderBy('track_id')->get();

        $query = Track::query()->orderBy('department_name')->orderBy('track_id');
        if ($filter === 'aktif') {
            $query->where('is_active', true);
        } elseif ($filter === 'nonaktif') {
            $query->where('is_active', false);
        }

        if ($search !== '') {
            $query->where(function ($q) use ($search): void {
                $q->where('department_name', 'like', '%' . $search . '%')
                    ->orWhere('study_program_name', 'like', '%' . $search . '%')
                    ->orWhere('track_name', 'like', '%' . $search . '%');
            });
        }

        $editingTrack = $editId !== null ? Track::query()->find((int) $editId) : null;

        return view('super-admin.jurusan', [
            'user' => $user,
            'filter' => $filter,
            'search' => $search,
            'tracksByDept' => $query->get()->groupBy('department_name'),
            'counts' => [
                'semua' => $allTracks->count(),
                'aktif' => $allTracks->where('is_active', true)->count(),
                'nonaktif' => $allTracks->where('is_active', false)->count(),
                'departments' => $allTracks->pluck('department_name')->unique()->count(),
            ],
            'editingTrack' => $editingTrack,
            'prefillDept' => (string) $request->query('dept', ''),
            'showForm' => $request->boolean('create') || $editingTrack !== null,
        ]);
    }

    /**
     * Store or Update a Track (Jurusan & Peminatan).
     */
    public function saveTrack(Request $request): RedirectResponse
    {
        /** @var User $actor */
        $actor = $request->user();

        $validated = $request->validate([
            'track_id' => ['nullable', 'integer'],
            'department_name' => ['required', 'string', 'max:100'],
            'study_program_name' => ['required', 'string', 'max:100'],
            'track_name' => ['required', 'string', 'max:100'],
        ]);

        $trackId = $validated['track_id'] ?? null;
        $isActive = $request->boolean('is_active', true);

        if ($trackId !== null) {
            $track = Track::query()->findOrFail((int) $trackId);
            $track->update([
                'department_name' => trim((string) $validated['department_name']),
                'study_program_name' => trim((string) $validated['study_program_name']),
                'track_name' => trim((string) $validated['track_name']),
                'is_active' => $isActive,
            ]);

            AuditLog::record($actor->email, 'UPDATE_TRACK', $track->track_name, 'Memperbarui jurusan & peminatan');

            return redirect()->route('super-admin.jurusan')->with('status', 'Jurusan / Peminatan ' . $track->track_name . ' berhasil diperbarui.');
        }

        $track = Track::query()->create([
            'department_name' => trim((string) $validated['department_name']),
            'study_program_name' => trim((string) $validated['study_program_name']),
            'track_name' => trim((string) $validated['track_name']),
            'is_active' => $isActive,
        ]);

        AuditLog::record($actor->email, 'CREATE_TRACK', $track->track_name, 'Menambahkan peminatan baru pada ' . $track->department_name);

        return redirect()->route('super-admin.jurusan')->with('status', 'Peminatan ' . $track->track_name . ' berhasil ditambahkan.');
    }

    /**
     * Toggle active status of a Microcredential Track.
     */
    public function toggleTrack(Request $request, int $trackId): RedirectResponse
    {
        /** @var User $actor */
        $actor = $request->user();

        $track = Track::query()->findOrFail($trackId);
        $track->is_active = ! $track->is_active;
        $track->save();

        AuditLog::record($actor->email, 'TOGGLE_TRACK', $track->track_name, 'Status: ' . ($track->is_active ? 'Aktif' : 'Nonaktif'));

        return redirect()->route('super-admin.jurusan')->with('status', 'Status ' . $track->track_name . ' berhasil diubah.');
    }

    /**
     * Delete a Track.
     */
    public function deleteTrack(Request $request, int $trackId): RedirectResponse
    {
        /** @var User $actor */
        $actor = $request->user();

        $track = Track::query()->findOrFail($trackId);
        if ($track->registrations()->exists()) {
            $track->is_active = false;
            $track->save();

            return redirect()->route('super-admin.jurusan')->with('status', 'Jalur ' . $track->track_name . ' dinonaktifkan karena sudah memiliki pendaftar.');
        }

        $name = $track->track_name;
        $track->delete();

        AuditLog::record($actor->email, 'DELETE_TRACK', $name, 'Menghapus peminatan');

        return redirect()->route('super-admin.jurusan')->with('status', 'Peminatan ' . $name . ' berhasil dihapus.');
    }

    /**
     * Tab 5 (User): Manajemen Pengguna (`users`).
     */
    public function users(Request $request): View
    {
        /** @var User $user */
        $user = $request->user();

        $roleFilter = (string) $request->query('role', 'all');
        $search = trim((string) $request->query('q', ''));
        $editId = $request->query('edit');

        $allUsers = User::query()->get();

        $query = User::query()->with(['registration'])->orderBy('user_id');
        if (in_array($roleFilter, ['maba', 'admin', 'keuangan', 'super_admin'], true)) {
            $query->where('role', $roleFilter);
        }

        if ($search !== '') {
            $query->where(function ($q) use ($search): void {
                $q->where('email', 'like', '%' . $search . '%')
                    ->orWhereHas('registration', function ($rq) use ($search): void {
                        $rq->where('full_name', 'like', '%' . $search . '%');
                    });
            });
        }

        $editingUser = $editId !== null ? User::query()->with(['registration'])->find((int) $editId) : null;

        return view('super-admin.users', [
            'user' => $user,
            'roleFilter' => $roleFilter,
            'search' => $search,
            'users' => $query->get(),
            'counts' => [
                'all' => $allUsers->count(),
                'maba' => $allUsers->where('role', UserRole::Maba)->count(),
                'keuangan' => $allUsers->where('role', UserRole::Keuangan)->count(),
                'admin' => $allUsers->where('role', UserRole::Admin)->count(),
                'super_admin' => $allUsers->where('role', UserRole::SuperAdmin)->count(),
            ],
            'editingUser' => $editingUser,
            'showForm' => $request->boolean('create') || $editingUser !== null,
        ]);
    }

    /**
     * Store or Update a User Account.
     */
    public function storeUser(Request $request): RedirectResponse
    {
        /** @var User $actor */
        $actor = $request->user();

        $userId = $request->input('user_id');

        if ($userId !== null && $userId !== '') {
            $target = User::query()->findOrFail((int) $userId);

            $validated = $request->validate([
                'email' => ['required', 'string', 'email', 'max:150', 'unique:users,email,' . $target->user_id . ',user_id'],
                'role' => ['required', 'string', 'in:maba,admin,keuangan,super_admin'],
                'password' => ['nullable', 'string', 'min:6'],
            ]);

            $target->email = trim(strtolower((string) $validated['email']));
            $target->role = UserRole::from((string) $validated['role']);
            $target->is_verified = $request->boolean('is_verified', true);

            if (! empty($validated['password'])) {
                $target->password_hash = Hash::make((string) $validated['password']);
            }

            $target->save();

            AuditLog::record($actor->email, 'UPDATE_USER', $target->email, 'Memperbarui data & hak akses akun (' . $target->role->value . ')');

            return redirect()->route('super-admin.users')->with('status', 'Akun ' . $target->email . ' berhasil diperbarui.');
        }

        $validated = $request->validate(
            [
                'email' => ['required', 'string', 'email', 'max:150', 'unique:users,email'],
                'password' => ['required', 'string', 'min:6'],
                'role' => ['required', 'string', 'in:maba,admin,keuangan,super_admin'],
            ],
            [
                'email.required' => 'Email akun wajib diisi.',
                'email.unique' => 'Email tersebut sudah terdaftar.',
                'password.required' => 'Kata sandi wajib diisi.',
                'password.min' => 'Kata sandi minimal 6 karakter.',
            ]
        );

        $newUser = User::query()->create([
            'email' => trim(strtolower((string) $validated['email'])),
            'password_hash' => Hash::make((string) $validated['password']),
            'role' => UserRole::from((string) $validated['role']),
            'is_verified' => $request->boolean('is_verified', true),
        ]);

        AuditLog::record($actor->email, 'CREATE_USER', $newUser->email, 'Membuat akun baru dengan role: ' . $newUser->role->value);

        return redirect()->route('super-admin.users')->with('status', 'Akun ' . $newUser->email . ' (' . $newUser->role->label() . ') berhasil ditambahkan!');
    }

    /**
     * Delete a user account.
     */
    public function deleteUser(Request $request, int $userId): RedirectResponse
    {
        /** @var User $actor */
        $actor = $request->user();

        if ($actor->user_id === $userId) {
            return back()->withErrors(['user' => 'Anda tidak dapat menghapus akun Super Admin yang sedang aktif digunakan.']);
        }

        $target = User::query()->findOrFail($userId);
        $targetEmail = $target->email;
        $target->delete();

        AuditLog::record($actor->email, 'DELETE_USER', $targetEmail, 'Menghapus akun pengguna dari sistem');

        return redirect()->route('super-admin.users')->with('status', 'Akun ' . $targetEmail . ' berhasil dihapus permanen.');
    }

    /**
     * Legacy /super-admin/master route alias redirects to /super-admin/rekening or renders master overview.
     */
    public function master(Request $request): View
    {
        return $this->rekening($request);
    }

    /**
     * Display system-wide Audit Logs.
     */
    public function audit(Request $request): View
    {
        /** @var User $user */
        $user = $request->user();

        $search = trim((string) $request->query('q', ''));
        $query = AuditLog::query()->orderByDesc('audit_id');

        if ($search !== '') {
            $query->where(function ($q) use ($search): void {
                $q->where('actor', 'like', '%' . $search . '%')
                    ->orWhere('action', 'like', '%' . $search . '%')
                    ->orWhere('object', 'like', '%' . $search . '%')
                    ->orWhere('result', 'like', '%' . $search . '%');
            });
        }

        return view('super-admin.audit', [
            'user' => $user,
            'search' => $search,
            'logs' => $query->limit(100)->get(),
        ]);
    }

    /**
     * Export Audit Logs to CSV.
     */
    public function exportAuditCsv(): StreamedResponse
    {
        $logs = AuditLog::query()->orderByDesc('audit_id')->get();

        return response()->streamDownload(function () use ($logs): void {
            $handle = fopen('php://output', 'w');
            if ($handle === false) {
                return;
            }

            fputcsv($handle, ['ID Audit', 'Waktu', 'Aktor (Email)', 'Aksi', 'Objek', 'Hasil / Keterangan']);

            foreach ($logs as $log) {
                fputcsv($handle, [
                    $log->audit_id,
                    (string) $log->timestamp,
                    $log->actor,
                    $log->action,
                    $log->object,
                    $log->result,
                ]);
            }

            fclose($handle);
        }, 'audit_logs_sistem_pmb_' . date('Ymd_His') . '.csv', [
            'Content-Type' => 'text/csv; charset=UTF-8',
        ]);
    }

    /**
     * Display Super Admin profile page.
     */
    public function profil(Request $request): View
    {
        /** @var User $user */
        $user = $request->user();

        return view('super-admin.profil', [
            'user' => $user,
            'totalAudit' => AuditLog::query()->count(),
            'totalUsers' => User::query()->count(),
        ]);
    }
}
