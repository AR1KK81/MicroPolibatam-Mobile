<x-layouts.app title="Beranda Super Admin — Sistem PMB Microcredential Polibatam">
    <div class="min-h-screen bg-[#EEF2FA] flex justify-center">
        <div class="w-full max-w-[430px] min-h-screen bg-[#FBF8FF] flex flex-col justify-between pb-24 relative shadow-[0_0_40px_rgba(15,23,42,0.06)]">
            <main class="px-4 pt-5 space-y-5 flex-1">
                <!-- Top Header (Image 7 Frame 1) -->
                <div class="flex items-start justify-between gap-3">
                    <div>
                        <span class="inline-flex items-center gap-1 rounded-full bg-[#DCE9FF] px-3 py-1 text-[10px] font-extrabold tracking-wider text-[#003BA5] uppercase">
                            🛡️ PORTAL SUPER ADMIN &bull; POLIBATAM
                        </span>
                        <h1 class="mt-2 text-[22px] font-extrabold text-[#161A30] leading-tight">
                            Halo, Super Admin
                        </h1>
                        <p class="text-[12px] text-[#64748B]">
                            Kelola data sistem PMB Microcredential
                        </p>
                    </div>
                    <div class="flex items-center gap-2 shrink-0">
                        <a
                            href="{{ route('super-admin.audit') }}"
                            title="Audit Log"
                            class="w-9 h-9 rounded-full bg-white border border-[#E8ECF8] flex items-center justify-center text-[#434655] shadow-2xs"
                        >
                            <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9" />
                                <path d="M13.73 21a2 2 0 0 1-3.46 0" />
                            </svg>
                        </a>
                        <a
                            href="{{ route('super-admin.profil') }}"
                            title="Profil & Logout"
                            class="w-9 h-9 rounded-full bg-[#DCE9FF] text-[#003BA5] font-extrabold text-xs flex items-center justify-center"
                        >
                            SA
                        </a>
                    </div>
                </div>

                <!-- 4 Stat Cards (2x2 Grid) -->
                <div class="grid grid-cols-2 gap-3">
                    <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)]">
                        <p class="text-[10.5px] font-extrabold tracking-wider text-[#64748B] uppercase">TOTAL USER</p>
                        <p class="mt-1.5 text-[24px] font-extrabold text-[#161A30] leading-none">{{ number_format($stats['total_users']) }}</p>
                        <span class="mt-2.5 inline-block rounded-md bg-[#D1FAE5] px-2 py-0.5 text-[10px] font-extrabold text-[#059669]">
                            +{{ $stats['new_users_week'] }} minggu ini
                        </span>
                    </div>

                    <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)]">
                        <p class="text-[10.5px] font-extrabold tracking-wider text-[#64748B] uppercase">HELPDESK</p>
                        <p class="mt-1.5 text-[24px] font-extrabold text-[#161A30] leading-none">{{ $stats['total_helpdesk'] }}</p>
                        <span class="mt-2.5 inline-block rounded-md bg-[#D1FAE5] px-2 py-0.5 text-[10px] font-extrabold text-[#059669]">
                            {{ $stats['active_helpdesk'] }} aktif
                        </span>
                    </div>

                    <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)]">
                        <p class="text-[10.5px] font-extrabold tracking-wider text-[#64748B] uppercase">REKENING</p>
                        <p class="mt-1.5 text-[24px] font-extrabold text-[#161A30] leading-none">{{ $stats['total_rekening'] }}</p>
                        <span class="mt-2.5 inline-block rounded-md bg-[#DCE9FF] px-2 py-0.5 text-[10px] font-extrabold text-[#003BA5]">
                            {{ $stats['active_rekening'] }} utama
                        </span>
                    </div>

                    <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)]">
                        <p class="text-[10.5px] font-extrabold tracking-wider text-[#64748B] uppercase">JURUSAN</p>
                        <p class="mt-1.5 text-[24px] font-extrabold text-[#161A30] leading-none">{{ $stats['total_departments'] }}</p>
                        <span class="mt-2.5 inline-block rounded-md bg-[#F1F5F9] px-2 py-0.5 text-[10px] font-bold text-[#475569]">
                            {{ $stats['total_tracks'] }} peminatan
                        </span>
                    </div>
                </div>

                <!-- Menu Kelola (2x2 Grid) -->
                <div>
                    <h2 class="text-[15.5px] font-extrabold text-[#161A30] mb-3">Menu Kelola</h2>
                    <div class="grid grid-cols-2 gap-3">
                        <a
                            href="{{ route('super-admin.helpdesk') }}"
                            class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)] hover:border-[#0052CC] transition block"
                        >
                            <div class="w-10 h-10 rounded-xl bg-[#E8F0FE] text-[#003BA5] flex items-center justify-center mb-3">
                                <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M3 18v-6a9 9 0 0 1 18 0v6" />
                                    <path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3zM3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z" />
                                </svg>
                            </div>
                            <p class="text-[14px] font-extrabold text-[#161A30]">Helpdesk</p>
                            <p class="text-[11.5px] text-[#64748B] mt-0.5">{{ $stats['total_helpdesk'] }} layanan</p>
                        </a>

                        <a
                            href="{{ route('super-admin.rekening') }}"
                            class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)] hover:border-[#0052CC] transition block"
                        >
                            <div class="w-10 h-10 rounded-xl bg-[#E8F0FE] text-[#003BA5] flex items-center justify-center mb-3">
                                <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="2" y="5" width="20" height="14" rx="2" />
                                    <line x1="2" y1="10" x2="22" y2="10" />
                                </svg>
                            </div>
                            <p class="text-[14px] font-extrabold text-[#161A30]">Nomor Rekening</p>
                            <p class="text-[11.5px] text-[#64748B] mt-0.5">{{ $stats['total_rekening'] }} rekening VA</p>
                        </a>

                        <a
                            href="{{ route('super-admin.jurusan') }}"
                            class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)] hover:border-[#0052CC] transition block"
                        >
                            <div class="w-10 h-10 rounded-xl bg-[#E8F0FE] text-[#003BA5] flex items-center justify-center mb-3">
                                <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="4" y="4" width="16" height="16" rx="2" />
                                    <line x1="9" y1="9" x2="15" y2="9" />
                                    <line x1="9" y1="13" x2="15" y2="13" />
                                </svg>
                            </div>
                            <p class="text-[14px] font-extrabold text-[#161A30]">Jurusan &amp; Peminatan</p>
                            <p class="text-[11.5px] text-[#64748B] mt-0.5">{{ $stats['total_departments'] }} jurusan, {{ $stats['total_tracks'] }} peminatan</p>
                        </a>

                        <a
                            href="{{ route('super-admin.users') }}"
                            class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)] hover:border-[#0052CC] transition block"
                        >
                            <div class="w-10 h-10 rounded-xl bg-[#E8F0FE] text-[#003BA5] flex items-center justify-center mb-3">
                                <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                    <circle cx="9" cy="7" r="4" />
                                    <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
                                    <path d="M16 3.13a4 4 0 0 1 0 7.75" />
                                </svg>
                            </div>
                            <p class="text-[14px] font-extrabold text-[#161A30]">User</p>
                            <p class="text-[11.5px] text-[#64748B] mt-0.5">{{ number_format($stats['total_users']) }} akun</p>
                        </a>
                    </div>
                </div>

                <!-- Aktivitas Terakhir -->
                <div>
                    <div class="flex items-center justify-between mb-2.5">
                        <h2 class="text-[15.5px] font-extrabold text-[#161A30]">Aktivitas Terakhir</h2>
                        <a href="{{ route('super-admin.audit') }}" class="text-[12px] font-bold text-[#0052CC] hover:underline">Lihat Semua</a>
                    </div>

                    <div class="space-y-2">
                        @forelse ($recentLogs as $log)
                            <div class="rounded-2xl bg-white border border-[#ECEEF8] p-3.5 flex items-center justify-between gap-2 shadow-2xs">
                                <div class="min-w-0">
                                    <p class="text-[12.5px] font-extrabold text-[#161A30] truncate">{{ $log->result }}</p>
                                    <p class="text-[11px] text-[#64748B] truncate">{{ $log->actor }} &bull; {{ $log->action }}</p>
                                </div>
                                <span class="text-[10.5px] font-semibold text-[#94A3B8] shrink-0">
                                    {{ $log->timestamp?->format('H:i') }}
                                </span>
                            </div>
                        @empty
                            <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 text-center text-[12px] text-[#64748B]">
                                Belum ada aktivitas terekam.
                            </div>
                        @endforelse
                    </div>
                </div>
            </main>

            <x-super-admin-nav active="beranda" />
        </div>
    </div>
</x-layouts.app>
