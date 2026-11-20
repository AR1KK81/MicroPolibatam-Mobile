<x-layouts.app title="Kelola Bayar — Staf Keuangan PMB Polibatam">
    <div class="min-h-screen bg-[#EEF2FA] flex justify-center">
        <div class="w-full max-w-[430px] min-h-screen bg-[#FBF8FF] flex flex-col justify-between pb-24 relative shadow-[0_0_40px_rgba(15,23,42,0.06)]">
            <!-- Header (Frame 405:5) -->
            <header class="sticky top-0 z-30 bg-[#FBF8FF]/95 backdrop-blur-md border-b border-[#EAE8F5] px-4 h-16 flex items-center justify-between">
                <div>
                    <p class="text-[14.5px] font-extrabold text-[#161A30] leading-none">PMB Micro</p>
                    <p class="text-[11px] font-semibold text-[#64748B] mt-0.5">Keuangan</p>
                </div>
                <div class="flex items-center gap-2">
                    <a href="{{ route('keuangan.riwayat') }}" class="w-9 h-9 rounded-full flex items-center justify-center text-[#434655] hover:bg-[#ECECFF]">
                        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9" />
                            <path d="M13.73 21a2 2 0 0 1-3.46 0" />
                        </svg>
                    </a>
                    <a href="{{ route('keuangan.profil') }}" class="w-9 h-9 rounded-full bg-[#003BA5] text-white flex items-center justify-center">
                        <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                            <circle cx="12" cy="7" r="4" />
                        </svg>
                    </a>
                </div>
            </header>

            <main class="px-4 pt-4 space-y-4 flex-1">
                @if (session('status'))
                    <div class="rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-[12.5px] font-semibold text-emerald-800">
                        {{ session('status') }}
                    </div>
                @endif

                <!-- Greeting & Institution Context -->
                <div class="flex items-start justify-between gap-3">
                    <div>
                        <span class="inline-block rounded-full bg-[#DCE9FF] px-3 py-1 text-[10px] font-extrabold tracking-wider text-[#003BA5] uppercase">
                            🏛️ PORTAL KEUANGAN &bull; POLIBATAM
                        </span>
                        <h1 class="mt-2 text-[22px] font-extrabold text-[#161A30] leading-tight">Halo, Staf Keuangan</h1>
                        <p class="text-[12px] text-[#64748B]">Panel Validasi &amp; Rekonsiliasi Admisi PMB</p>
                    </div>
                    <div class="w-11 h-11 rounded-2xl bg-[#E8F0FE] text-[#003BA5] flex items-center justify-center text-lg shrink-0">
                        🏛️
                    </div>
                </div>

                <!-- 2 Summary Stats Cards -->
                <div class="grid grid-cols-2 gap-3">
                    <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)]">
                        <div class="flex items-center justify-between">
                            <span class="text-[10.5px] font-extrabold tracking-wider text-[#64748B] uppercase">MENUNGGU CEK</span>
                            <span class="w-7 h-7 rounded-lg bg-[#FEF3C7] text-[#B45309] flex items-center justify-center text-xs">📋</span>
                        </div>
                        <p class="mt-2 text-[22px] font-extrabold text-[#161A30]">
                            {{ $counts['perlu_cek'] }} <span class="text-[13px] font-semibold text-[#64748B]">Maba</span>
                        </p>
                        <span class="mt-1 inline-block rounded-full bg-[#FEF3C7] px-2.5 py-0.5 text-[10px] font-extrabold text-[#B45309]">
                            &bull; Perlu Aksi Hari Ini
                        </span>
                    </div>

                    <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)]">
                        <div class="flex items-center justify-between">
                            <span class="text-[10.5px] font-extrabold tracking-wider text-[#64748B] uppercase">TOTAL LUNAS</span>
                            <span class="w-7 h-7 rounded-lg bg-[#D1FAE5] text-[#059669] flex items-center justify-center text-xs">&#10003;</span>
                        </div>
                        <p class="mt-2 text-[22px] font-extrabold text-[#161A30]">
                            {{ $counts['lunas'] }} <span class="text-[13px] font-semibold text-[#64748B]">Maba</span>
                        </p>
                        <span class="mt-1 inline-block rounded-full bg-[#D1FAE5] px-2.5 py-0.5 text-[10px] font-extrabold text-[#059669]">
                            💵 Rp {{ number_format($counts['total_lunas_amount'], 0, ',', '.') }}
                        </span>
                    </div>
                </div>

                <!-- VA Sync Banner -->
                <div class="rounded-2xl bg-[#EBF1FF] border border-[#D6E3FE] p-3.5">
                    <p class="text-[12.5px] font-extrabold text-[#003BA5]">☑️ Sinkronisasi VA Otomatis Aktif</p>
                    <p class="text-[11.5px] text-[#434655] leading-relaxed mt-0.5">
                        Host-to-host BNI VA terverifikasi sistemik. Transfer bank manual memerlukan audit bukti visual sebelum aktivasi akun NIM.
                    </p>
                </div>

                <!-- Search Bar -->
                <form method="GET" action="{{ route('keuangan.dashboard') }}" class="relative">
                    <input type="hidden" name="tab" value="{{ $tab }}">
                    <input
                        type="text"
                        name="q"
                        value="{{ $search }}"
                        placeholder="Cari Nama, No. VA, atau ID PMB..."
                        class="w-full rounded-2xl border border-[#E2E8F0] bg-white py-3 px-4 text-[13px] text-[#161A30] placeholder:text-[#94A3B8] focus:border-[#003BA5] focus:outline-none shadow-2xs"
                    >
                </form>

                <!-- 3 Filter Pill Tabs -->
                <div class="flex items-center gap-2 overflow-x-auto pb-1">
                    <a
                        href="{{ route('keuangan.dashboard', ['tab' => 'perlu_cek', 'q' => $search]) }}"
                        class="rounded-full px-3.5 py-2 text-[12px] font-bold inline-flex items-center gap-1.5 shrink-0 transition {{ $tab === 'perlu_cek' ? 'bg-[#0052CC] text-white shadow-xs' : 'bg-white border border-[#E2E8F0] text-[#475569]' }}"
                    >
                        <span>Perlu Cek</span>
                        <span class="rounded-full px-1.5 text-[10.5px] {{ $tab === 'perlu_cek' ? 'bg-white/25 text-white' : 'bg-[#ECECFF] text-[#003BA5]' }}">
                            {{ $counts['perlu_cek'] }}
                        </span>
                    </a>

                    <a
                        href="{{ route('keuangan.dashboard', ['tab' => 'bermasalah', 'q' => $search]) }}"
                        class="rounded-full px-3.5 py-2 text-[12px] font-bold inline-flex items-center gap-1.5 shrink-0 transition {{ $tab === 'bermasalah' ? 'bg-[#0052CC] text-white shadow-xs' : 'bg-white border border-[#E2E8F0] text-[#E11D48]' }}"
                    >
                        <span>&bull; Bermasalah</span>
                        <span class="text-[10.5px]">{{ $counts['bermasalah'] }}</span>
                    </a>

                    <a
                        href="{{ route('keuangan.dashboard', ['tab' => 'lunas', 'q' => $search]) }}"
                        class="rounded-full px-3.5 py-2 text-[12px] font-bold inline-flex items-center gap-1.5 shrink-0 transition {{ $tab === 'lunas' ? 'bg-[#0052CC] text-white shadow-xs' : 'bg-white border border-[#E2E8F0] text-[#059669]' }}"
                    >
                        <span>&#10003; Lunas</span>
                        <span class="text-[10.5px]">{{ $counts['lunas'] }}</span>
                    </a>
                </div>

                <!-- Antrean Validasi List -->
                <div class="flex items-center gap-2">
                    <h2 class="text-[16px] font-extrabold text-[#161A30]">Antrean Validasi</h2>
                    <span class="rounded-full bg-[#ECECFF] px-2.5 py-0.5 text-[10.5px] font-bold text-[#434655]">
                        Batch 1 2026
                    </span>
                </div>

                <div class="space-y-3">
                    @forelse ($payments as $p)
                        @php
                            $reg = $p->registration;
                        @endphp
                        <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_12px_rgba(15,23,42,0.03)] space-y-3">
                            <div class="flex items-center justify-between gap-2">
                                <span class="rounded-full bg-[#DCE9FF] px-3 py-1 text-[11px] font-extrabold text-[#003BA5]">
                                    {{ $reg?->track?->department_name ?? 'Informatika' }}
                                </span>

                                @if ($p->status_pembayaran === 'lunas')
                                    <span class="rounded-full bg-[#D1FAE5] px-2.5 py-1 text-[10px] font-extrabold text-[#059669] uppercase">
                                        &#10003; LUNAS
                                    </span>
                                @elseif ($p->status_pembayaran === 'ditolak')
                                    <span class="rounded-full bg-[#FFDAD6] px-2.5 py-1 text-[10px] font-extrabold text-[#93000A] uppercase">
                                        ! BERMASALAH
                                    </span>
                                @else
                                    <span class="rounded-full bg-[#FEF3C7] px-2.5 py-1 text-[10px] font-extrabold text-[#B45309] uppercase">
                                        &bull; MENUNGGU VALIDASI
                                    </span>
                                @endif
                            </div>

                            <div class="flex items-center justify-between">
                                <div>
                                    <h3 class="text-[16.5px] font-extrabold text-[#161A30]">{{ $reg?->full_name ?? 'Calon Mahasiswa' }}</h3>
                                    <p class="text-[12px] text-[#64748B]">{{ $reg?->registrationCode() ?? ('PMB-MC-26-' . $p->registration_id) }}</p>
                                </div>
                                <div class="w-9 h-9 rounded-full bg-[#ECECFF] text-[#003BA5] flex items-center justify-center font-bold text-xs">
                                    {{ $reg?->initials() ?? 'MB' }}
                                </div>
                            </div>

                            <div class="rounded-xl bg-[#F4F2FF] p-3.5 space-y-2 text-[12px]">
                                <div class="flex justify-between">
                                    <span class="text-[#64748B]">🏛️ Metode Bayar</span>
                                    <span class="font-extrabold text-[#161A30]">Transfer Rekening BNI</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-[#64748B]">No. Rekening BNI</span>
                                    <span class="font-extrabold text-[#161A30]">{{ $p->rekening?->account_number ?? '1003301245' }}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-[#64748B]">Nominal Registrasi</span>
                                    <span class="font-extrabold text-[#0052CC] text-[13.5px]">Rp {{ number_format((float) $p->amount, 0, ',', '.') }}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-[#64748B]">Waktu Transaksi</span>
                                    <span class="font-semibold text-[#161A30]">{{ $p->payment_date?->format('d M Y, H:i') ?? '-' }} WIB</span>
                                </div>

                                <div class="pt-1">
                                    <div class="rounded-lg bg-white px-3 py-2 flex items-center justify-between text-[11.5px]">
                                        <span class="font-semibold text-[#161A30] truncate">📎 {{ basename($p->proof_file_path) }}</span>
                                        <span class="font-bold text-[#0052CC] shrink-0 ml-2">Pratinjau 👁️</span>
                                    </div>
                                </div>
                            </div>

                            @if ($p->status_pembayaran === 'ditolak' && $p->finance_notes)
                                <div class="rounded-xl bg-[#FFF5F5] border border-[#FED7D7] p-3 text-[11.5px]">
                                    <p class="font-extrabold text-[#93000A]">⚠️ Catatan Keuangan:</p>
                                    <p class="text-[#434655] mt-0.5">{{ $p->finance_notes }}</p>
                                </div>
                            @elseif ($p->status_pembayaran === 'lunas')
                                <div class="rounded-xl bg-[#ECFDF5] border border-[#A7F3D0] px-3 py-2 text-[11.5px] font-bold text-[#059669]">
                                    &#10003; Divalidasi oleh Keuangan &bull; Rekening Resmi Polibatam
                                </div>
                            @endif

                            @if ($p->status_pembayaran === 'ditolak')
                                <a
                                    href="{{ route('keuangan.payments.show', $p->payment_id) }}"
                                    class="w-full rounded-xl border border-red-300 bg-white hover:bg-red-50 py-2.5 text-[13px] font-extrabold text-[#BE123C] flex items-center justify-center gap-2 transition"
                                >
                                    <span>Detail &amp; Edit Catatan</span>
                                    <span>&rarr;</span>
                                </a>
                            @elseif ($p->status_pembayaran === 'lunas')
                                <a
                                    href="{{ route('keuangan.payments.show', $p->payment_id) }}"
                                    class="w-full rounded-xl border border-[#CBD5E1] bg-white hover:bg-[#F8FAFC] py-2.5 text-[13px] font-extrabold text-[#003BA5] flex items-center justify-center gap-2 transition"
                                >
                                    <span>Lihat Bukti &amp; Kuitansi</span>
                                    <span>&rarr;</span>
                                </a>
                            @else
                                <a
                                    href="{{ route('keuangan.payments.show', $p->payment_id) }}"
                                    class="w-full rounded-xl bg-[#0052CC] hover:bg-[#003E9C] py-3 text-[13.5px] font-bold text-white flex items-center justify-center gap-2 transition"
                                >
                                    <span>Verifikasi Pembayaran</span>
                                    <span>&rarr;</span>
                                </a>
                            @endif
                        </div>
                    @empty
                        <div class="rounded-2xl bg-white border border-[#ECEEF8] p-8 text-center">
                            <p class="text-[14px] font-bold text-[#161A30]">Tidak ada transaksi pada kategori ini</p>
                            <p class="text-[12px] text-[#64748B] mt-1">Pilih filter tab lain di atas.</p>
                        </div>
                    @endforelse
                </div>
            </main>

            <!-- Bottom Navigation Bar (Keuangan) -->
            <nav class="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-[430px] bg-white border-t border-[#E6E8F2] px-6 py-2.5 flex items-center justify-around z-40">
                <a href="{{ route('keuangan.dashboard') }}" class="flex flex-col items-center gap-1 text-[#0052CC] font-extrabold text-[11px]">
                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
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
                <a href="{{ route('keuangan.profil') }}" class="flex flex-col items-center gap-1 text-[#64748B] hover:text-[#0052CC] font-semibold text-[11px]">
                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                        <circle cx="12" cy="7" r="4" />
                    </svg>
                    <span>Profil</span>
                </a>
            </nav>
        </div>
    </div>
</x-layouts.app>
