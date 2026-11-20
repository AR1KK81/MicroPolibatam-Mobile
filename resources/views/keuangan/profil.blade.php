<x-layouts.app title="Profil Staf Keuangan — PMB Microcredential Polibatam">
    <div class="min-h-screen bg-[#EEF2FA] flex justify-center">
        <div class="w-full max-w-[430px] min-h-screen bg-[#FBF8FF] flex flex-col justify-between pb-24 relative shadow-[0_0_40px_rgba(15,23,42,0.06)]">
            <!-- Header (Frame 405:12) -->
            <header class="sticky top-0 z-30 bg-[#FBF8FF]/95 backdrop-blur-md border-b border-[#EAE8F5] px-4 h-16 flex items-center justify-between">
                <div>
                    <p class="text-[14.5px] font-extrabold text-[#161A30] leading-none">PMB Micro</p>
                    <p class="text-[11px] font-semibold text-[#64748B] mt-0.5">Profil Keuangan</p>
                </div>
            </header>

            <main class="px-4 pt-4 space-y-5 flex-1">
                <!-- Profile Showcase Card -->
                <div class="rounded-3xl bg-white border border-[#ECEEF8] p-6 text-center shadow-[0_4px_20px_rgba(15,23,42,0.03)]">
                    <div class="w-20 h-20 rounded-full bg-[#003BA5] text-white font-extrabold text-2xl flex items-center justify-center mx-auto shadow-md">
                        SK
                    </div>
                    <h1 class="mt-3 text-[18px] font-extrabold text-[#161A30]">Staf Keuangan 01</h1>
                    <p class="text-[12.5px] text-[#64748B]">{{ $user->email }}</p>
                    <span class="mt-2.5 inline-block rounded-full bg-[#DCE9FF] px-3.5 py-1 text-[11px] font-extrabold text-[#003BA5]">
                        🏛️ Bagian Keuangan &amp; Rekonsiliasi BNI
                    </span>
                </div>

                <!-- Rekening Aktif Info -->
                <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 space-y-2 text-[12.5px]">
                    <p class="text-[11px] font-extrabold text-[#64748B] uppercase">REKENING PENERIMAAN AKTIF</p>
                    <div class="flex justify-between">
                        <span class="text-[#64748B]">Bank</span>
                        <span class="font-extrabold text-[#161A30]">{{ $rekening?->bank_name ?? 'Bank BNI' }}</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-[#64748B]">No. Rekening</span>
                        <span class="font-extrabold text-[#003BA5]">{{ $rekening?->account_number ?? '1003301245' }}</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-[#64748B]">Atas Nama</span>
                        <span class="font-bold text-[#161A30] text-right">{{ $rekening?->account_name ?? '-' }}</span>
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

                <!-- Pengaturan Akun & Ganti Kata Sandi (Frame 405:13) -->
                <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)] space-y-3">
                    <div>
                        <h3 class="text-[14.5px] font-extrabold text-[#161A30]">🔒 Ganti Kata Sandi Akun</h3>
                        <p class="text-[11.5px] text-[#64748B]">Kelola data profil dan keamanan kata sandi akun verifikator</p>
                    </div>

                    <form method="POST" action="{{ route('account.password.update') }}" class="space-y-3">
                        @csrf
                        <div>
                            <label class="block text-[12px] font-bold text-[#161A30] mb-1">Kata Sandi Saat Ini</label>
                            <input
                                type="password"
                                name="current_password"
                                required
                                placeholder="Masukkan kata sandi saat ini"
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
                <form method="POST" action="{{ route('logout') }}">
                    @csrf
                    <button
                        type="submit"
                        class="w-full rounded-2xl bg-[#FFDAD6] hover:bg-[#FFC4BE] py-3.5 px-5 text-[14px] font-extrabold text-[#93000A] flex items-center justify-center gap-2 transition cursor-pointer"
                    >
                        <span>&rarr; Keluar dari Sesi Keuangan</span>
                    </button>
                </form>
            </main>

            <!-- Bottom Navigation Bar (Keuangan) -->
            <nav class="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-[430px] bg-white border-t border-[#E6E8F2] px-6 py-2.5 flex items-center justify-around z-40">
                <a href="{{ route('keuangan.dashboard') }}" class="flex flex-col items-center gap-1 text-[#64748B] hover:text-[#0052CC] font-semibold text-[11px]">
                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="2" y="5" width="20" height="14" rx="2" />
                        <line x1="2" y1="10" x2="22" y2="10" />
                    </svg>
                    <span>Kelola Bayar</span>
                </a>
                <a href="{{ route('keuangan.riwayat') }}" class="flex flex-col items-center gap-1 text-[#64748B] hover:text-[#0052CC] font-semibold text-[11px]">
                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8" />
                        <path d="M3 3v5h5" />
                        <path d="M12 7v5l4 2" />
                    </svg>
                    <span>Riwayat Bayar</span>
                </a>
                <a href="{{ route('keuangan.profil') }}" class="flex flex-col items-center gap-1 text-[#0052CC] font-extrabold text-[11px]">
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
