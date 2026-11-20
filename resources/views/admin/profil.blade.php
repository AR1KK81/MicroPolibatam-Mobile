<x-layouts.app title="Profil Akun Admin — PMB Microcredential Polibatam">
    <div class="min-h-screen bg-[#EEF2FA] flex justify-center">
        <div class="w-full max-w-[430px] min-h-screen bg-[#FBF8FF] flex flex-col justify-between pb-24 relative shadow-[0_0_40px_rgba(15,23,42,0.06)]">
            <!-- Header (Frame 396:12) -->
            <header class="sticky top-0 z-30 bg-[#FBF8FF]/95 backdrop-blur-md border-b border-[#EAE8F5] px-4 h-16 flex items-center justify-between">
                <div>
                    <p class="text-[10.5px] font-extrabold tracking-wider text-[#003BA5] uppercase">MICRO POLIBATAM</p>
                    <p class="text-[15.5px] font-extrabold text-[#161A30]">Profil Verifikator</p>
                </div>
            </header>

            <main class="px-4 pt-4 space-y-5 flex-1">
                <div>
                    <h1 class="text-[22px] font-extrabold text-[#161A30]">Profil Akun</h1>
                    <p class="text-[12.5px] text-[#64748B]">Manajemen profil dan preferensi verifikator admisi</p>
                </div>

                <!-- Admin Identity Card -->
                <div class="rounded-3xl bg-white border border-[#ECEEF8] p-5 shadow-[0_4px_20px_rgba(15,23,42,0.03)] flex items-center gap-4">
                    <div class="w-14 h-14 rounded-2xl bg-[#0052CC] text-white font-extrabold text-xl flex items-center justify-center shrink-0">
                        AR
                    </div>
                    <div class="min-w-0">
                        <span class="inline-block rounded-full bg-[#DCE9FF] px-2.5 py-0.5 text-[10px] font-extrabold text-[#003BA5] uppercase">
                            Admin Akademik PMB
                        </span>
                        <h2 class="mt-1 text-[16px] font-extrabold text-[#161A30] truncate">{{ $user->email }}</h2>
                        <p class="text-[11.5px] text-[#64748B]">Unit Admisi &amp; Registrasi Polibatam</p>
                    </div>
                </div>

                <!-- Quick Performance Summary -->
                <div>
                    <h3 class="text-[14px] font-extrabold text-[#161A30] mb-2.5">📊 Ringkasan Kinerja Bulan Ini</h3>
                    <div class="grid grid-cols-2 gap-3">
                        <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4">
                            <p class="text-[11.5px] text-[#64748B]">Dokumen Disetujui</p>
                            <p class="mt-1 text-[22px] font-extrabold text-[#059669]">{{ $verifiedCount }} ACC</p>
                        </div>
                        <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4">
                            <p class="text-[11.5px] text-[#64748B]">Permintaan Revisi</p>
                            <p class="mt-1 text-[22px] font-extrabold text-[#93000A]">{{ $revisionCount }} Revisi</p>
                        </div>
                    </div>
                </div>

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

                <!-- Pengaturan Akun & Ganti Kata Sandi (Frame 396:13) -->
                <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)] space-y-3">
                    <div>
                        <h3 class="text-[14.5px] font-extrabold text-[#161A30]">🔒 Ganti Kata Sandi</h3>
                        <p class="text-[11.5px] text-[#64748B]">Kelola keamanan kata sandi akun verifikator</p>
                    </div>

                    <form method="POST" action="{{ route('account.password.update') }}" class="space-y-3">
                        @csrf
                        <div>
                            <label class="block text-[12px] font-bold text-[#161A30] mb-1">Kata Sandi Saat Ini</label>
                            <input
                                type="password"
                                name="current_password"
                                required
                                placeholder="Masukkan kata sandi lama"
                                class="w-full rounded-xl bg-[#F4F2FF] px-3.5 py-2.5 text-[13px] text-[#161A30] focus:bg-white focus:border focus:border-[#0052CC] focus:outline-none"
                            >
                        </div>
                        <div>
                            <label class="block text-[12px] font-bold text-[#161A30] mb-1">Kata Sandi Baru</label>
                            <input
                                type="password"
                                name="password"
                                required
                                minlength="8"
                                placeholder="Minimal 8 karakter unik"
                                class="w-full rounded-xl bg-[#F4F2FF] px-3.5 py-2.5 text-[13px] text-[#161A30] focus:bg-white focus:border focus:border-[#0052CC] focus:outline-none"
                            >
                        </div>
                        <div>
                            <label class="block text-[12px] font-bold text-[#161A30] mb-1">Konfirmasi Kata Sandi Baru</label>
                            <input
                                type="password"
                                name="password_confirmation"
                                required
                                minlength="8"
                                placeholder="Ulangi kata sandi baru"
                                class="w-full rounded-xl bg-[#F4F2FF] px-3.5 py-2.5 text-[13px] text-[#161A30] focus:bg-white focus:border focus:border-[#0052CC] focus:outline-none"
                            >
                        </div>
                        <button
                            type="submit"
                            class="w-full rounded-xl bg-[#0052CC] hover:bg-[#003E9C] py-3 text-[13px] font-extrabold text-white transition cursor-pointer"
                        >
                            &#10003; Simpan Perubahan
                        </button>
                    </form>
                </div>

                <!-- Logout -->
                <form method="POST" action="{{ route('logout') }}" class="pt-3">
                    @csrf
                    <button
                        type="submit"
                        class="w-full rounded-2xl bg-[#FFDAD6] hover:bg-[#FFC4BE] py-3.5 px-5 text-[14px] font-extrabold text-[#93000A] flex items-center justify-center gap-2 transition cursor-pointer"
                    >
                        <span>&rarr; Keluar dari Sesi Admin</span>
                    </button>
                </form>
            </main>

            <!-- Bottom Navigation Bar (Admin) -->
            <nav class="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-[430px] bg-white border-t border-[#E6E8F2] px-6 py-2.5 flex items-center justify-around z-40">
                <a href="{{ route('admin.dashboard') }}" class="flex flex-col items-center gap-1 text-[#64748B] hover:text-[#0052CC] font-semibold text-[11px]">
                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2" />
                        <rect x="8" y="2" width="8" height="4" rx="1" ry="1" />
                    </svg>
                    <span>Kelola Berkas</span>
                </a>
                <a href="{{ route('admin.riwayat') }}" class="flex flex-col items-center gap-1 text-[#64748B] hover:text-[#0052CC] font-semibold text-[11px]">
                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8" />
                        <path d="M3 3v5h5" />
                        <path d="M12 7v5l4 2" />
                    </svg>
                    <span>Riwayat</span>
                </a>
                <a href="{{ route('admin.profil') }}" class="flex flex-col items-center gap-1 text-[#0052CC] font-extrabold text-[11px]">
                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                        <circle cx="12" cy="7" r="4" />
                    </svg>
                    <span>Profil</span>
                </a>
            </nav>
        </div>
    </div>
</x-layouts.app>
