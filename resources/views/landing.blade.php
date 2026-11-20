<x-layouts.app title="Microcredential Polibatam — Tingkatkan Kompetensimu">
    <div class="min-h-screen bg-[#EEF2FA] flex justify-center">
        <div class="w-full max-w-[430px] min-h-screen bg-[#F3F5FD] flex flex-col justify-between px-5 py-5 shadow-[0_0_40px_rgba(15,23,42,0.06)]">
            <!-- Top Header -->
            <div>
                <header class="flex items-center justify-between">
                    <div>
                        <p class="text-[26px] font-extrabold text-[#1A4FA3] leading-none tracking-tight">MP</p>
                        <p class="text-[10px] font-semibold text-[#1A2650] mt-0.5">Micro Polibatam</p>
                    </div>
                    <a
                        href="{{ route('login') }}"
                        title="Masuk Portal"
                        class="w-11 h-11 rounded-[14px] bg-white shadow-xs flex flex-col items-center justify-center gap-1.5 hover:bg-blue-50 transition"
                    >
                        <span class="w-[18px] h-[2.5px] rounded-full bg-[#1A2650]"></span>
                        <span class="w-[18px] h-[2.5px] rounded-full bg-[#1A2650]"></span>
                        <span class="w-[18px] h-[2.5px] rounded-full bg-[#1A2650]"></span>
                    </a>
                </header>

                <!-- Hero Banner Card -->
                <div class="mt-5 relative h-[180px] w-full rounded-[28px] overflow-hidden bg-gradient-to-br from-[#0A3D91] via-[#1A4FA3] to-[#0F62CC] p-6 flex flex-col justify-end text-white shadow-[0_12px_28px_rgba(26,79,163,0.25)]">
                    <div class="absolute -right-8 -top-8 w-40 h-40 rounded-full bg-white/10 blur-xl"></div>
                    <span class="inline-block w-fit rounded-full bg-white/20 backdrop-blur-xs px-3 py-1 text-[10px] font-extrabold tracking-wider uppercase mb-2">
                        Politeknik Negeri Batam
                    </span>
                    <p class="text-[19px] font-extrabold leading-snug">
                        Kampus Vokasi &amp; Industri Digital
                    </p>
                    <p class="text-[11.5px] text-blue-100 mt-0.5">
                        Penerimaan Mahasiswa Baru Jalur Microcredential
                    </p>
                </div>

                <!-- Titles & Copy -->
                <div class="mt-6">
                    <h1 class="text-[28px] font-extrabold leading-tight text-[#1A2650]">
                        Microcredential
                        <span class="block text-[#0F62CC]">Polibatam</span>
                    </h1>

                    <p class="mt-3 text-[16px] font-bold leading-[1.6] text-[#1A2650]">
                        Tingkatkan Kompetensimu, Raih Peluang Lebih Besar di Dunia Industri!
                    </p>

                    <p class="mt-3 text-[12.5px] leading-[1.65] text-[#666E80]">
                        Program Microcredential Non-Degree Politeknik Negeri Batam hadir sebagai wadah pembelajaran fleksibel untuk mengembangkan pengetahuan, keterampilan dan kompetensi sesuai kebutuhan industri dan dunia kerja.
                    </p>
                </div>

                <!-- CTA Buttons -->
                <div class="mt-6 space-y-2.5">
                    <a
                        href="{{ route('register') }}"
                        class="w-full h-[50px] rounded-[18px] bg-[#1A4FA3] hover:bg-[#133D82] text-white font-bold text-[14.5px] shadow-[0_8px_20px_rgba(26,79,163,0.25)] flex items-center justify-center transition"
                    >
                        Daftar Sekarang
                    </a>
                    <a
                        href="{{ route('login') }}"
                        class="w-full h-[46px] rounded-[18px] bg-white hover:bg-blue-50/60 border border-[#DCE6F7] text-[#1A4FA3] font-bold text-[13.5px] flex items-center justify-center transition"
                    >
                        Sudah Punya Akun? Masuk Portal
                    </a>
                </div>

                <!-- Why Card -->
                <div class="mt-6 rounded-[28px] bg-white p-4 shadow-[0_6px_24px_rgba(15,35,95,0.04)]">
                    <p class="text-[13px] font-bold text-[#0F62CC] px-1">
                        Mengapa Memilih Microcredential Polibatam?
                    </p>
                    <div class="mt-3 grid grid-cols-2 gap-2.5">
                        <div class="rounded-[20px] bg-[#F0F4FC] p-3.5 flex flex-col items-center text-center">
                            <div class="w-9 h-9 rounded-xl bg-white text-[#1A4FA3] flex items-center justify-center shadow-2xs mb-2">
                                <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                    <circle cx="9" cy="7" r="4" />
                                    <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
                                    <path d="M16 3.13a4 4 0 0 1 0 7.75" />
                                </svg>
                            </div>
                            <p class="text-[11.5px] font-bold text-[#1A2650]">Terbuka Untuk Umum</p>
                        </div>
                        <div class="rounded-[20px] bg-[#F0F4FC] p-3.5 flex flex-col items-center text-center">
                            <div class="w-9 h-9 rounded-xl bg-white text-[#059669] flex items-center justify-center shadow-2xs mb-2">
                                <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M22 10v6M2 10l10-5 10 5-10 5z" />
                                    <path d="M6 12v5c3 3 9 3 12 0v-5" />
                                </svg>
                            </div>
                            <p class="text-[11.5px] font-bold text-[#1A2650]">Kurikulum Industri</p>
                        </div>
                    </div>
                </div>
            </div>

            <footer class="pt-6 text-center text-[11px] text-[#64748B]">
                &copy; 2026 Microcredential Politeknik Negeri Batam
            </footer>
        </div>
    </div>
</x-layouts.app>
