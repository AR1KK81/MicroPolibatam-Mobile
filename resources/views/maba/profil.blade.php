<x-layouts.app title="Profil Saya — Calon Mahasiswa Polibatam">
    @php
        $displayName = $registration?->full_name ?? ucfirst(strtok($user->email, '@') ?: 'Maba');
        $initials = $registration?->initials() ?? strtoupper(substr($displayName, 0, 2));
        $regCode = $registration?->registrationCode() ?? ('PMB-MC-26-' . $user->user_id);
        $nik = $registration?->readableNik() ?? 'Belum diisi';
        $department = $registration?->track?->department_name ?? 'MICROCREDENTIAL';
        $trackName = $registration?->track?->track_name ?? 'Microcredential 2026';
    @endphp

    <div class="min-h-screen bg-[#EEF2FA] flex justify-center">
        <div class="w-full max-w-[430px] min-h-screen bg-[#FBF8FF] flex flex-col justify-between pb-24 relative shadow-[0_0_40px_rgba(15,23,42,0.06)]">
            <!-- Header -->
            <header class="sticky top-0 z-30 bg-[#FBF8FF]/95 backdrop-blur-md border-b border-[#EAE8F5] px-4 h-16 flex items-center justify-between">
                <div>
                    <p class="text-[10px] font-extrabold tracking-wider text-[#003BA5] uppercase">PMB MICROCREDENTIAL</p>
                    <p class="text-[15px] font-extrabold text-[#161A30]">Profil Akun</p>
                </div>
                <a href="{{ route('maba.formulir', ['tab' => 'biodata']) }}" class="rounded-xl bg-[#ECECFF] px-3 py-1.5 text-[12px] font-bold text-[#003BA5]">
                    Edit Biodata
                </a>
            </header>

            <main class="px-4 pt-4 space-y-5 flex-1">
                <div>
                    <h1 class="text-[23px] font-extrabold text-[#161A30]">Profil Saya</h1>
                    <p class="text-[12.5px] text-[#64748B]">Informasi akun dan pengaturan calon mahasiswa Polibatam</p>
                </div>

                <!-- Avatar Card -->
                <div class="rounded-3xl bg-white border border-[#ECEEF8] p-6 text-center shadow-[0_4px_20px_rgba(15,23,42,0.03)]">
                    <div class="w-20 h-20 rounded-full bg-[#0052CC] text-white font-extrabold text-[26px] flex items-center justify-center mx-auto shadow-[0_8px_20px_rgba(0,82,204,0.25)]">
                        {{ $initials }}
                    </div>
                    <h2 class="mt-3.5 text-[18px] font-extrabold text-[#161A30]">{{ $displayName }}</h2>
                    <div class="mt-2 flex flex-col items-center gap-1.5">
                        <span class="inline-flex items-center gap-1.5 rounded-full bg-[#DCE9FF] px-3.5 py-1 text-[11.5px] font-extrabold text-[#003BA5]">
                            <span>No. Reg: {{ $regCode }}</span>
                        </span>
                        <span class="inline-flex items-center gap-1.5 rounded-full bg-[#ECECFF] px-3 py-0.5 text-[10.5px] font-extrabold text-[#003BA5] uppercase">
                            &bull; {{ $department }}
                        </span>
                    </div>
                </div>

                <!-- Informasi Akun -->
                <div>
                    <div class="flex items-center justify-between mb-2 px-1">
                        <span class="text-[11px] font-extrabold tracking-wider text-[#64748B] uppercase">INFORMASI AKUN</span>
                        <span class="text-[11px] font-bold text-[#0052CC]">🔒 Tervalidasi Dukcapil</span>
                    </div>

                    <div class="rounded-2xl bg-white border border-[#ECEEF8] divide-y divide-[#F1F5F9] shadow-[0_2px_12px_rgba(15,23,42,0.025)]">
                        <div class="p-3.5 flex items-center justify-between gap-2">
                            <span class="text-[13px] text-[#64748B]">NIK</span>
                            <span class="text-[13.5px] font-extrabold text-[#161A30]">{{ $nik }}</span>
                        </div>
                        <div class="p-3.5 flex items-center justify-between gap-2">
                            <span class="text-[13px] text-[#64748B]">Email Terdaftar</span>
                            <span class="text-[13px] font-extrabold text-[#161A30]">{{ $user->email }}</span>
                        </div>
                        <div class="p-3.5 flex items-center justify-between gap-2">
                            <span class="text-[13px] text-[#64748B]">Jalur Masuk</span>
                            <span class="text-[13px] font-extrabold text-[#161A30] text-right">{{ $trackName }}</span>
                        </div>
                        <div class="p-3.5 flex items-center justify-between gap-2">
                            <span class="text-[13px] text-[#64748B]">Status Portal</span>
                            <span class="rounded-full bg-[#E8F0FE] px-3 py-0.5 text-[11px] font-extrabold text-[#003BA5]">
                                &bull; Aktif (SSO Terverifikasi)
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Logout Button -->
                <form method="POST" action="{{ route('logout') }}" class="pt-2">
                    @csrf
                    <button
                        type="submit"
                        class="w-full rounded-2xl bg-[#FFDAD6] hover:bg-[#FFC4BE] py-3.5 px-5 text-[14px] font-extrabold text-[#93000A] flex items-center justify-center gap-2 transition cursor-pointer"
                    >
                        <span>&rarr; Keluar dari Akun</span>
                    </button>
                </form>

                <div class="text-center text-[11px] text-[#94A3B8] pt-2">
                    <p class="font-bold text-[#64748B]">PMB Microcredential Polibatam &bull; v1.2.0</p>
                    <p class="mt-0.5">Pusat Informasi Penerimaan Mahasiswa Baru &copy; 2026</p>
                </div>
            </main>

            <!-- Bottom Navigation Bar (Maba) -->
            <nav class="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-[430px] bg-white border-t border-[#E6E8F2] px-6 py-2.5 flex items-center justify-around z-40">
                <a href="{{ route('maba.dashboard') }}" class="flex flex-col items-center gap-1 text-[#64748B] hover:text-[#003BA5] font-semibold text-[11px]">
                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
                        <polyline points="9 22 9 12 15 12 15 22" />
                    </svg>
                    <span>Beranda</span>
                </a>
                <a href="{{ route('maba.status') }}" class="flex flex-col items-center gap-1 text-[#64748B] hover:text-[#003BA5] font-semibold text-[11px]">
                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2" />
                        <rect x="8" y="2" width="8" height="4" rx="1" ry="1" />
                        <path d="m9 14 2 2 4-4" />
                    </svg>
                    <span>Status</span>
                </a>
                <a href="{{ route('maba.profil') }}" class="flex flex-col items-center gap-1 text-[#003BA5] font-extrabold text-[11px]">
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
