<x-layouts.app title="Riwayat Transaksi — Staf Keuangan PMB Polibatam">
    <div class="min-h-screen bg-[#EEF2FA] flex justify-center">
        <div class="w-full max-w-[430px] min-h-screen bg-[#FBF8FF] flex flex-col justify-between pb-24 relative shadow-[0_0_40px_rgba(15,23,42,0.06)]">
            <!-- Header (Frame 405:8) -->
            <header class="sticky top-0 z-30 bg-[#FBF8FF]/95 backdrop-blur-md border-b border-[#EAE8F5] px-4 h-16 flex items-center justify-between">
                <div>
                    <p class="text-[14.5px] font-extrabold text-[#161A30] leading-none">PMB Micro</p>
                    <p class="text-[11px] font-semibold text-[#64748B] mt-0.5">Keuangan</p>
                </div>
                <a href="{{ route('keuangan.profil') }}" class="w-9 h-9 rounded-full bg-[#003BA5] text-white flex items-center justify-center">
                    <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                        <circle cx="12" cy="7" r="4" />
                    </svg>
                </a>
            </header>

            <main class="px-4 pt-4 space-y-4 flex-1">
                <div>
                    <span class="inline-block rounded-full bg-[#DCE9FF] px-3 py-1 text-[10px] font-extrabold text-[#003BA5]">
                        &bull; Portal Keuangan &bull; Rekonsiliasi &amp; Audit
                    </span>
                    <h1 class="mt-2 text-[22px] font-extrabold text-[#161A30]">Riwayat Transaksi</h1>
                    <p class="text-[12px] text-[#64748B]">Rekam jejak verifikasi pembayaran Maba Polibatam</p>
                </div>

                <!-- 2 Summary Cards -->
                <div class="grid grid-cols-2 gap-3">
                    <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)]">
                        <p class="text-[10.5px] font-extrabold text-[#64748B] uppercase">TOTAL TRANSAKSI</p>
                        <p class="mt-1.5 text-[20px] font-extrabold text-[#161A30]">{{ $totalCount }} Transaksi</p>
                        <p class="text-[12px] font-extrabold text-[#0052CC]">Rp {{ number_format($totalAmount, 0, ',', '.') }}</p>
                    </div>

                    <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)]">
                        <p class="text-[10.5px] font-extrabold text-[#64748B] uppercase">VALIDASI</p>
                        <p class="mt-1.5 text-[16px] font-extrabold text-[#161A30]">
                            <span class="text-[#059669]">&bull; {{ $lunasCount }} Lunas</span>
                            <span class="text-[#E11D48] ml-1">&bull; {{ $issueCount }} Isu</span>
                        </p>
                        <p class="text-[11px] text-[#64748B] mt-1">Rekonsiliasi Realtime</p>
                    </div>
                </div>

                <!-- Search -->
                <form method="GET" action="{{ route('keuangan.riwayat') }}">
                    <input
                        type="text"
                        name="q"
                        value="{{ $search }}"
                        placeholder="Cari pendaftar, No. VA, atau Ref..."
                        class="w-full rounded-2xl border border-[#E2E8F0] bg-white py-3 px-4 text-[13px] text-[#161A30] placeholder:text-[#94A3B8] focus:border-[#003BA5] focus:outline-none shadow-2xs"
                    >
                </form>

                <!-- Transactions List -->
                <div class="space-y-3">
                    @foreach ($payments as $p)
                        @php
                            $reg = $p->registration;
                        @endphp
                        <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)] space-y-2.5">
                            <div class="flex items-start justify-between gap-2">
                                <div>
                                    <div class="flex items-center gap-2">
                                        <p class="text-[14.5px] font-extrabold text-[#161A30]">{{ $reg?->full_name ?? 'Calon Mahasiswa' }}</p>
                                        <span class="rounded-md bg-[#ECECFF] px-2 py-0.5 text-[10px] font-bold text-[#003BA5]">
                                            {{ $reg?->track?->department_name ?? 'Informatika' }}
                                        </span>
                                    </div>
                                    <p class="text-[11.5px] text-[#64748B]">{{ $reg?->registrationCode() ?? ('PMB-MC-26-' . $p->registration_id) }}</p>
                                </div>

                                @if ($p->status_pembayaran === 'lunas')
                                    <span class="rounded-full bg-[#D1FAE5] px-2.5 py-0.5 text-[10.5px] font-extrabold text-[#059669]">
                                        &#10003; LUNAS
                                    </span>
                                @elseif ($p->status_pembayaran === 'ditolak')
                                    <span class="rounded-full bg-[#FFDAD6] px-2.5 py-0.5 text-[10.5px] font-extrabold text-[#93000A]">
                                        ! BERMASALAH
                                    </span>
                                @else
                                    <span class="rounded-full bg-[#FEF3C7] px-2.5 py-0.5 text-[10.5px] font-extrabold text-[#B45309]">
                                        MENUNGGU
                                    </span>
                                @endif
                            </div>

                            <div class="flex items-center justify-between">
                                <p class="text-[17px] font-extrabold {{ $p->status_pembayaran === 'ditolak' ? 'text-[#E11D48]' : 'text-[#161A30]' }}">
                                    Rp {{ number_format((float) $p->amount, 0, ',', '.') }}
                                    <span class="text-[11.5px] font-normal text-[#64748B]">({{ $p->rekening?->bank_name ?? 'BNI' }})</span>
                                </p>
                                <span class="text-[11.5px] text-[#64748B]">🕒 {{ $p->payment_date?->format('d M, H:i') }} WIB</span>
                            </div>

                            @if ($p->finance_notes)
                                <div class="rounded-xl bg-[#FFDAD6]/40 p-3 text-[11.5px] text-[#161A30]">
                                    <p>⚠️ {{ $p->finance_notes }}</p>
                                </div>
                            @endif

                            <div class="flex justify-end">
                                <a href="{{ route('keuangan.payments.show', $p->payment_id) }}" class="text-[12px] font-bold text-[#0052CC] hover:underline">
                                    Tinjau Transaksi &rsaquo;
                                </a>
                            </div>
                        </div>
                    @endforeach
                </div>

                <!-- Export CSV Button -->
                <div class="pt-2">
                    <a
                        href="{{ route('keuangan.riwayat.csv') }}"
                        class="w-full rounded-2xl bg-white border border-[#DCE6F7] hover:bg-[#F4F8FF] py-3.5 px-4 text-[13px] font-extrabold text-[#161A30] flex items-center justify-center gap-2 shadow-2xs transition"
                    >
                        <span>⬇ Ekspor Log Transaksi (.CSV)</span>
                    </a>
                </div>
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
                <a href="{{ route('keuangan.riwayat') }}" class="flex flex-col items-center gap-1 text-[#0052CC] font-extrabold text-[11px]">
                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
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
