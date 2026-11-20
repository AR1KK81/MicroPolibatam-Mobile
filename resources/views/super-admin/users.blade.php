<x-layouts.app title="Manajemen User — Super Admin PMB Polibatam">
    <div class="min-h-screen bg-[#EEF2FA] flex justify-center">
        <div class="w-full max-w-[430px] min-h-screen bg-[#FBF8FF] flex flex-col justify-between pb-24 relative shadow-[0_0_40px_rgba(15,23,42,0.06)]">
            <main class="px-4 pt-5 space-y-4 flex-1">
                @if (session('status'))
                    <div class="rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-[12.5px] font-semibold text-emerald-800">
                        {{ session('status') }}
                    </div>
                @endif

                @if ($errors->any())
                    <div class="rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-[12.5px] font-semibold text-red-700">
                        {{ $errors->first() }}
                    </div>
                @endif

                @if ($showForm)
                    <!-- Tambah / Edit User Screen (Image 8 Frame 5) -->
                    @php
                        $editName = $editingUser?->registration?->full_name ?? ucfirst(strtok($editingUser?->email ?? 'User Baru', '@') ?: 'User');
                        $editInitials = strtoupper(substr($editName, 0, 2));
                        $editRole = $editingUser ? ($editingUser->role instanceof \App\Enums\UserRole ? $editingUser->role->value : (string) $editingUser->role) : 'admin';
                    @endphp
                    <div class="flex items-center justify-between">
                        <div>
                            <h1 class="text-[20px] font-extrabold text-[#161A30]">
                                {{ $editingUser ? 'Edit User' : 'Tambah User Baru' }}
                            </h1>
                            <p class="text-[12px] text-[#64748B]">Atur data dan hak akses</p>
                        </div>
                        <a
                            href="{{ route('super-admin.users') }}"
                            class="w-9 h-9 rounded-full bg-white border border-[#E2E8F0] flex items-center justify-center text-[#434655] font-bold"
                        >
                            &#10005;
                        </a>
                    </div>

                    @if ($editingUser)
                        <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 flex items-center gap-3">
                            <div class="w-12 h-12 rounded-full bg-[#D1FAE5] text-[#059669] font-extrabold text-sm flex items-center justify-center">
                                {{ $editInitials }}
                            </div>
                            <div>
                                <p class="text-[15px] font-extrabold text-[#161A30]">{{ $editName }}</p>
                                <p class="text-[11.5px] text-[#64748B]">ID: PMB-USR-00{{ $editingUser->user_id }}</p>
                            </div>
                        </div>
                    @endif

                    <form method="POST" action="{{ route('super-admin.users.store') }}" class="space-y-3.5">
                        @csrf
                        @if ($editingUser)
                            <input type="hidden" name="user_id" value="{{ $editingUser->user_id }}">
                        @endif

                        <div>
                            <label class="block text-[12px] font-bold text-[#64748B] mb-1.5">Email</label>
                            <input
                                type="email"
                                name="email"
                                required
                                value="{{ old('email', $editingUser?->email) }}"
                                placeholder="✉️ nama@polibatam.ac.id"
                                class="w-full rounded-2xl border border-[#E2E8F0] bg-white px-4 py-3 text-[13.5px] font-semibold text-[#161A30] focus:border-[#0052CC] focus:outline-none"
                            >
                        </div>

                        <div>
                            <label class="block text-[12px] font-bold text-[#64748B] mb-1.5">Role</label>
                            <select
                                name="role"
                                required
                                class="w-full rounded-2xl border border-[#E2E8F0] bg-white px-4 py-3 text-[13.5px] font-bold text-[#161A30] focus:border-[#0052CC] focus:outline-none"
                            >
                                <option value="maba" {{ $editRole === 'maba' ? 'selected' : '' }}>Maba (Calon Mahasiswa)</option>
                                <option value="admin" {{ $editRole === 'admin' ? 'selected' : '' }}>Admin Akademik</option>
                                <option value="keuangan" {{ $editRole === 'keuangan' ? 'selected' : '' }}>Keuangan</option>
                                <option value="super_admin" {{ $editRole === 'super_admin' ? 'selected' : '' }}>Super Admin</option>
                            </select>
                        </div>

                        <div>
                            <label class="block text-[12px] font-bold text-[#64748B] mb-1.5">
                                {{ $editingUser ? 'Reset Kata Sandi Baru (Kosongkan jika tidak diubah)' : 'Kata Sandi Akun' }}
                            </label>
                            <input
                                type="password"
                                name="password"
                                {{ $editingUser ? '' : 'required' }}
                                minlength="6"
                                placeholder="🔒 Minimal 6 karakter"
                                class="w-full rounded-2xl border border-[#E2E8F0] bg-white px-4 py-3 text-[13.5px] font-semibold text-[#161A30] focus:border-[#0052CC] focus:outline-none"
                            >
                        </div>

                        <div class="rounded-2xl border border-[#E2E8F0] bg-white px-4 py-3.5 flex items-center justify-between">
                            <span class="text-[13.5px] font-bold text-[#161A30]">Akun aktif</span>
                            <input
                                type="checkbox"
                                name="is_verified"
                                value="1"
                                {{ old('is_verified', $editingUser?->is_verified ?? true) ? 'checked' : '' }}
                                class="w-5 h-5 accent-[#0052CC] rounded"
                            >
                        </div>

                        <div class="pt-2 grid {{ ($editingUser && $editingUser->user_id !== $user->user_id) ? 'grid-cols-2' : 'grid-cols-1' }} gap-2.5">
                            <button
                                type="submit"
                                class="rounded-full bg-[#0052CC] hover:bg-[#003E9C] py-3.5 text-[13.5px] font-extrabold text-white flex items-center justify-center gap-1.5 shadow-sm cursor-pointer"
                            >
                                <span>&#10003; Simpan</span>
                            </button>

                            @if ($editingUser && $editingUser->user_id !== $user->user_id)
                                <button
                                    type="button"
                                    onclick="openDeleteUserModal({{ $editingUser->user_id }}, '{{ $editingUser->email }}')"
                                    class="rounded-full border border-red-300 bg-white hover:bg-red-50 py-3.5 text-[13px] font-extrabold text-[#DC2626] flex items-center justify-center gap-1.5 cursor-pointer"
                                >
                                    <span>🗑️ Hapus User</span>
                                </button>
                            @endif
                        </div>
                    </form>
                @else
                    <!-- Pengguna List Screen (Image 8 Frame 4 & 6) -->
                    <div class="flex items-start justify-between">
                        <div>
                            <span class="inline-block rounded-full bg-[#DCE9FF] px-2.5 py-0.5 text-[10px] font-extrabold text-[#003BA5] uppercase">
                                🛡️ MANAJEMEN USER
                            </span>
                            <h1 class="mt-1.5 text-[22px] font-extrabold text-[#161A30] leading-tight">Pengguna</h1>
                            <p class="text-[12px] text-[#64748B]">{{ number_format($counts['all']) }} akun terdaftar</p>
                        </div>
                        <a
                            href="{{ route('super-admin.users', ['create' => 1]) }}"
                            class="w-9 h-9 rounded-full bg-white border border-[#E2E8F0] flex items-center justify-center text-[#161A30] font-bold text-lg shadow-2xs"
                        >
                            +
                        </a>
                    </div>

                    <!-- Search -->
                    <form method="GET" action="{{ route('super-admin.users') }}">
                        <input type="hidden" name="role" value="{{ $roleFilter }}">
                        <input
                            type="text"
                            name="q"
                            value="{{ $search }}"
                            placeholder="🔍 Cari nama, email, atau NIM..."
                            class="w-full rounded-2xl border border-[#E2E8F0] bg-white py-3 px-4 text-[13px] text-[#161A30] placeholder:text-[#94A3B8] focus:border-[#0052CC] focus:outline-none shadow-2xs"
                        >
                    </form>

                    <!-- Role Filter Pills -->
                    <div class="flex items-center gap-1.5 overflow-x-auto pb-1">
                        @foreach ([
                            'all' => ['Semua', $counts['all']],
                            'maba' => ['Maba', $counts['maba']],
                            'keuangan' => ['Keuangan', $counts['keuangan']],
                            'admin' => ['Admin', $counts['admin']],
                            'super_admin' => ['Super Admin', $counts['super_admin']],
                        ] as $key => [$label, $count])
                            <a
                                href="{{ route('super-admin.users', ['role' => $key, 'q' => $search]) }}"
                                class="rounded-full px-3.5 py-1.5 text-[12px] font-bold inline-flex items-center gap-1.5 shrink-0 transition {{ $roleFilter === $key ? 'bg-[#0052CC] text-white' : 'bg-white border border-[#E2E8F0] text-[#475569]' }}"
                            >
                                <span>{{ $label }}</span>
                                <span class="text-[10.5px] opacity-85">{{ $count }}</span>
                            </a>
                        @endforeach
                    </div>

                    <!-- Users Cards -->
                    <div class="space-y-2.5">
                        @foreach ($users as $u)
                            @php
                                $roleVal = $u->role instanceof \App\Enums\UserRole ? $u->role->value : (string) $u->role;
                                $displayName = $u->registration?->full_name ?? ucfirst(strtok($u->email, '@') ?: 'User');
                                $initials = strtoupper(substr($displayName, 0, 2));
                                $roleBadgeStyle = match ($roleVal) {
                                    'super_admin' => 'bg-[#EDE9FE] text-[#6D28D9]',
                                    'keuangan' => 'bg-[#CCFBF1] text-[#0D9488]',
                                    'admin' => 'bg-[#FEF3C7] text-[#D97706]',
                                    default => 'bg-[#F1F5F9] text-[#475569]',
                                };
                                $roleLabel = match ($roleVal) {
                                    'super_admin' => 'Super Admin',
                                    'keuangan' => 'Keuangan',
                                    'admin' => 'Admin',
                                    default => 'Maba',
                                };
                            @endphp
                            <div class="rounded-2xl bg-white border border-[#ECEEF8] p-3.5 flex items-center justify-between gap-3 shadow-[0_2px_10px_rgba(15,23,42,0.025)]">
                                <div class="flex items-center gap-3 min-w-0">
                                    <div class="w-10 h-10 rounded-full {{ $roleBadgeStyle }} font-extrabold text-xs flex items-center justify-center shrink-0">
                                        {{ $initials }}
                                    </div>
                                    <div class="min-w-0">
                                        <p class="text-[14px] font-extrabold text-[#161A30] truncate">{{ $displayName }}</p>
                                        <p class="text-[11.5px] text-[#64748B] truncate">{{ $u->email }}</p>
                                        <div class="mt-1 flex items-center gap-1.5">
                                            <span class="rounded-md px-2 py-0.5 text-[10px] font-extrabold {{ $roleBadgeStyle }}">
                                                {{ $roleLabel }}
                                            </span>
                                            <span class="rounded-md px-2 py-0.5 text-[10px] font-extrabold {{ $u->is_verified ? 'bg-[#D1FAE5] text-[#059669]' : 'bg-[#FFDAD6] text-[#93000A]' }}">
                                                {{ $u->is_verified ? 'Aktif' : 'Nonaktif' }}
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="flex items-center gap-2 shrink-0">
                                    <a
                                        href="{{ route('super-admin.users', ['edit' => $u->user_id]) }}"
                                        class="w-8 h-8 rounded-full hover:bg-[#F1F5F9] flex items-center justify-center text-[#475569]"
                                        title="Edit User"
                                    >
                                        ✎
                                    </a>
                                    @if ($u->user_id !== $user->user_id)
                                        <button
                                            type="button"
                                            onclick="openDeleteUserModal({{ $u->user_id }}, '{{ $u->email }}')"
                                            class="w-8 h-8 rounded-full hover:bg-red-50 flex items-center justify-center text-[#DC2626] cursor-pointer"
                                            title="Hapus User"
                                        >
                                            🗑️
                                        </button>
                                    @endif
                                </div>
                            </div>
                        @endforeach
                    </div>
                @endif
            </main>

            <x-super-admin-nav active="user" />
        </div>
    </div>

    <!-- Bottom-Sheet Confirmation Modal: Hapus akun ini? (Image 8 Frame 6) -->
    <div
        id="deleteUserModal"
        class="fixed inset-0 z-50 hidden items-end sm:items-center justify-center bg-slate-900/50 backdrop-blur-xs p-4"
        onclick="if (event.target === this) closeDeleteUserModal()"
    >
        <div class="w-full max-w-[400px] rounded-3xl bg-white p-6 text-center shadow-2xl">
            <div class="w-12 h-12 rounded-2xl bg-[#FFE4E6] text-[#E11D48] flex items-center justify-center mx-auto mb-3 text-lg">
                🗑️
            </div>
            <h3 class="text-[17px] font-extrabold text-[#161A30]">Hapus akun ini?</h3>
            <p class="mt-1.5 text-[12.5px] text-[#64748B] leading-relaxed">
                Akun <strong id="deleteUserEmailText" class="text-[#161A30]"></strong> akan dihapus permanen dan tidak bisa dipulihkan. Riwayat pembayaran tetap tersimpan di audit log.
            </p>

            <form id="confirmDeleteUserForm" method="POST" action="" class="mt-5 grid grid-cols-2 gap-2.5">
                @csrf
                @method('DELETE')
                <button
                    type="button"
                    onclick="closeDeleteUserModal()"
                    class="rounded-full border border-[#E2E8F0] bg-white hover:bg-[#F8FAFC] py-3 text-[13px] font-extrabold text-[#334155] cursor-pointer"
                >
                    Batal
                </button>
                <button
                    type="submit"
                    class="rounded-full bg-[#DC2626] hover:bg-[#B91C1C] py-3 text-[13px] font-extrabold text-white cursor-pointer"
                >
                    Ya, Hapus
                </button>
            </form>
        </div>
    </div>

    <script>
        function openDeleteUserModal(userId, email) {
            const modal = document.getElementById('deleteUserModal');
            const form = document.getElementById('confirmDeleteUserForm');
            const emailText = document.getElementById('deleteUserEmailText');

            if (modal && form && emailText) {
                emailText.textContent = email;
                form.action = '{{ url("/super-admin/users") }}/' + userId;
                modal.classList.remove('hidden');
                modal.classList.add('flex');
            }
        }

        function closeDeleteUserModal() {
            const modal = document.getElementById('deleteUserModal');
            if (modal) {
                modal.classList.add('hidden');
                modal.classList.remove('flex');
            }
        }
    </script>
</x-layouts.app>
