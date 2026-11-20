<x-layouts.app title="Beranda Pendaftar — PMB Microcredential Polibatam">
    @php
        $displayName = $registration?->full_name ?? ucfirst( strtok($user->email, '@') ?: 'Maba' );
        $initials = $registration?->initials() ?? strtoupper(substr($displayName, 0, 2));
        $regCode = $registration?->registrationCode() ?? ('PMB-MC-26-' . $user->user_id);
        $programName = $registration?->track?->department_name ?? 'BELUM DIPILIH';
        $docsCount = $registration?->documents?->count() ?? 0;
        $hasRevisionDoc = $registration?->documents?->where('status_verifikasi_admin', 'revisi')->isNotEmpty() ?? false;
        $allDocsValid = $docsCount >= 3 && ($registration?->documents?->every(fn ($d) => $d->status_verifikasi_admin === 'valid') ?? false);
        $payment = $registration?->payment;
    @endphp

    <div class="min-h-screen bg-[#EEF2FA] flex justify-center">
        <div class="w-full max-w-[430px] min-h-screen bg-[#FBF8FF] flex flex-col justify-between pb-24 relative shadow-[0_0_40px_rgba(15,23,42,0.06)]">
            <!-- Top App Bar -->
            <header class="sticky top-0 z-30 bg-[#FBF8FF]/90 backdrop-blur-md border-b border-[#EAE8F5] px-4 h-16 flex items-center justify-between">
                <h1 class="text-[16px] font-extrabold text-[#161A30]">Beranda</h1>
                <div class="flex items-center gap-2">
                    <button
                        type="button"
                        onclick="document.getElementById('mabaHelpModal').classList.remove('hidden'); document.getElementById('mabaHelpModal').classList.add('flex');"
                        aria-label="Pusat Bantuan"
                        class="w-9 h-9 rounded-full flex items-center justify-center text-[#434655] hover:bg-[#ECECFF] transition cursor-pointer"
                    >
                        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="12" cy="12" r="9.5" />
                            <path d="M9.4 9.3a2.7 2.7 0 0 1 5.1 1c0 1.8-2.5 2.2-2.5 3.6" />
                            <circle cx="12" cy="17.2" r="0.6" fill="currentColor" />
                        </svg>
                    </button>
                    <a
                        href="{{ route('maba.profil') }}"
                        class="w-9 h-9 rounded-full bg-[#003BA5] text-white flex items-center justify-center shadow-xs"
                    >
                        <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                            <circle cx="12" cy="7" r="4" />
                        </svg>
                    </a>
                </div>
            </header>

            <!-- Scrollable Content -->
            <main class="px-4 pt-4 space-y-4 flex-1">
                @if (session('status'))
                    <div class="rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-[12.5px] font-semibold text-emerald-800">
                        {{ session('status') }}
                    </div>
                @endif

                <!-- Greeting Header -->
                <div class="flex items-center justify-between gap-3">
                    <div class="flex items-center gap-3">
                        <div class="w-12 h-12 rounded-full bg-[#D6E3FE] text-[#003BA5] font-extrabold text-[16px] flex items-center justify-center shrink-0">
                            {{ $initials }}
                        </div>
                        <div>
                            <h2 class="text-[19px] font-extrabold text-[#161A30] leading-tight">
                                Halo, {{ $displayName }} 👋
                            </h2>
                            <p class="text-[12px] text-[#64748B] mt-0.5">
                                Calon Mahasiswa - Jalur Microcredential
                            </p>
                        </div>
                    </div>
                    <a
                        href="{{ route('maba.status') }}"
                        class="w-11 h-11 rounded-full bg-white border border-[#E8ECF8] shadow-2xs flex items-center justify-center text-[#161A30] hover:bg-[#F4F2FF] transition"
                    >
                        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9" />
                            <path d="M13.73 21a2 2 0 0 1-3.46 0" />
                        </svg>
                    </a>
                </div>

                <!-- Registration Number & Program Card -->
                <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_12px_rgba(15,23,42,0.03)] grid grid-cols-2 divide-x divide-[#E8ECF8]">
                    <div class="pr-3">
                        <p class="text-[10.5px] font-bold tracking-wider text-[#64748B] uppercase">NO. REGISTRASI</p>
                        <p class="text-[15px] font-extrabold text-[#161A30] mt-1">{{ $regCode }}</p>
                    </div>
                    <div class="pl-3 text-right">
                        <p class="text-[10.5px] font-bold tracking-wider text-[#64748B] uppercase">PROGRAM PILIHAN</p>
                        <p class="text-[14px] font-extrabold text-[#003BA5] mt-1 uppercase truncate">{{ $programName }}</p>
                    </div>
                </div>

                <!-- Akses Portal Pendaftaran CTA Banner -->
                <div class="rounded-2xl bg-[#EBF1FF] border border-[#D6E3FE] p-4 flex items-start justify-between gap-3">
                    <div class="flex items-start gap-3">
                        <div class="w-9 h-9 rounded-xl bg-white text-[#003BA5] flex items-center justify-center shrink-0 shadow-2xs">
                            <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10" />
                                <line x1="12" y1="16" x2="12" y2="12" />
                                <line x1="12" y1="8" x2="12.01" y2="8" />
                            </svg>
                        </div>
                        <div>
                            <p class="text-[13.5px] font-extrabold text-[#161A30]">Akses Portal Pendaftaran</p>
                            <p class="text-[12px] text-[#434655] leading-relaxed mt-0.5">
                                Lengkapi biodata, unggah 3 berkas wajib (KTP, KK, Ijazah), dan bukti transfer BNI di sini.
                            </p>
                            <a
                                href="{{ route('maba.formulir') }}"
                                class="mt-2.5 inline-flex items-center gap-1.5 rounded-xl bg-[#003BA5] hover:bg-[#002D80] text-white px-3.5 py-2 text-[12px] font-bold shadow-xs transition"
                            >
                                <span>{{ $registration ? 'Buka Formulir & Berkas' : 'Isi Formulir Sekarang' }}</span>
                                <span>&rarr;</span>
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Status Pendaftaran Section -->
                <div>
                    <div class="flex items-center justify-between mb-2.5">
                        <h3 class="text-[15.5px] font-extrabold text-[#161A30]">Status Pendaftaran</h3>
                        <a href="{{ route('maba.status') }}" class="text-[12px] font-bold text-[#003BA5] hover:underline">Terkini</a>
                    </div>

                    <div class="space-y-2.5">
                        <!-- Card: Verifikasi Berkas & Ijazah -->
                        <a href="{{ route('maba.formulir', ['tab' => 'dokumen']) }}" class="block rounded-2xl bg-white border border-[#ECEEF8] p-3.5 shadow-[0_2px_10px_rgba(15,23,42,0.025)] hover:border-[#C8DCFF] transition">
                            <div class="flex items-center justify-between gap-2">
                                <div class="flex items-center gap-3">
                                    <div class="w-10 h-10 rounded-xl bg-[#E8F0FE] text-[#003BA5] flex items-center justify-center shrink-0">
                                        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2" />
                                            <rect x="8" y="2" width="8" height="4" rx="1" ry="1" />
                                            <path d="M9 14h6" />
                                            <path d="M9 10h6" />
                                        </svg>
                                    </div>
                                    <div>
                                        <p class="text-[13.5px] font-extrabold text-[#161A30]">Verifikasi Berkas &amp; Ijazah</p>
                                        <p class="text-[11.5px] text-[#64748B]">Divalidasi oleh Admin Registrasi ({{ $docsCount }}/3 berkas)</p>
                                    </div>
                                </div>

                                @if ($registration?->status === 'selesai_terverifikasi' || $allDocsValid)
                                    <span class="rounded-full bg-[#D1FAE5] px-2.5 py-1 text-[10px] font-extrabold text-[#059669] uppercase shrink-0">
                                        &#10003; VALID
                                    </span>
                                @elseif ($registration?->status === 'perlu_revisi' || $hasRevisionDoc)
                                    <span class="rounded-full bg-[#FFDAD6] px-2.5 py-1 text-[10px] font-extrabold text-[#93000A] uppercase shrink-0">
                                        ! PERLU REVISI
                                    </span>
                                @else
                                    <span class="rounded-full bg-[#FEF3C7] px-2.5 py-1 text-[10px] font-extrabold text-[#B45309] uppercase shrink-0">
                                        &bull; SEDANG DIPROSES
                                    </span>
                                @endif
                            </div>
                        </a>

                        <!-- Card: Verifikasi Pembayaran -->
                        <a href="{{ route('maba.formulir', ['tab' => 'bayar']) }}" class="block rounded-2xl bg-white border border-[#ECEEF8] p-3.5 shadow-[0_2px_10px_rgba(15,23,42,0.025)] hover:border-[#C8DCFF] transition">
                            <div class="flex items-center justify-between gap-2">
                                <div class="flex items-center gap-3">
                                    <div class="w-10 h-10 rounded-xl bg-[#ECECFF] text-[#003BA5] flex items-center justify-center shrink-0">
                                        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <rect x="2" y="5" width="20" height="14" rx="2" />
                                            <line x1="2" y1="10" x2="22" y2="10" />
                                        </svg>
                                    </div>
                                    <div>
                                        <p class="text-[13.5px] font-extrabold text-[#161A30]">Verifikasi Pembayaran</p>
                                        <p class="text-[11.5px] text-[#64748B]">Divalidasi oleh Staf Keuangan</p>
                                    </div>
                                </div>

                                @if ($payment?->status_pembayaran === 'lunas')
                                    <span class="rounded-full bg-[#D1FAE5] px-2.5 py-1 text-[10px] font-extrabold text-[#059669] uppercase shrink-0">
                                        &#10003; LUNAS / DISETUJUI
                                    </span>
                                @elseif ($payment?->status_pembayaran === 'ditolak')
                                    <span class="rounded-full bg-[#FFDAD6] px-2.5 py-1 text-[10px] font-extrabold text-[#93000A] uppercase shrink-0">
                                        ! PERLU REVISI
                                    </span>
                                @elseif ($payment !== null)
                                    <span class="rounded-full bg-[#FEF3C7] px-2.5 py-1 text-[10px] font-extrabold text-[#B45309] uppercase shrink-0">
                                        &bull; MENUNGGU CEK
                                    </span>
                                @else
                                    <span class="rounded-full bg-[#F1F5F9] px-2.5 py-1 text-[10px] font-extrabold text-[#64748B] uppercase shrink-0">
                                        BELUM UNGGAH
                                    </span>
                                @endif
                            </div>
                        </a>
                    </div>
                </div>

                <!-- Tahapan Pendaftaran Stepper Card -->
                <div>
                    <div class="flex items-center justify-between mb-2.5">
                        <h3 class="text-[15.5px] font-extrabold text-[#161A30]">Tahapan Pendaftaran</h3>
                        <span class="text-[11.5px] font-semibold text-[#64748B]">Jalur Microcredential 2026</span>
                    </div>

                    <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_12px_rgba(15,23,42,0.025)] space-y-5">
                        <!-- Step 1 -->
                        <div class="flex items-start justify-between gap-3">
                            <div class="flex items-start gap-3">
                                <div class="w-8 h-8 rounded-full {{ $registration ? 'bg-[#003BA5] text-white' : 'bg-[#E8F0FE] text-[#003BA5]' }} flex items-center justify-center shrink-0 text-xs font-extrabold">
                                    &#10003;
                                </div>
                                <div>
                                    <p class="text-[13.5px] font-extrabold text-[#161A30]">Pengisian Data &amp; Berkas</p>
                                    <p class="text-[11.5px] text-[#64748B]">{{ $registration ? 'Biodata tersimpan di Portal' : 'Silakan isi biodata peserta' }}</p>
                                </div>
                            </div>
                            <span class="text-[11px] font-extrabold text-[#003BA5] uppercase">
                                {{ $registration ? 'SELESAI' : 'MULAI' }}
                            </span>
                        </div>

                        <!-- Step 2 -->
                        <div class="flex items-start justify-between gap-3">
                            <div class="flex items-start gap-3">
                                <div class="w-8 h-8 rounded-full {{ $registration?->status === 'selesai_terverifikasi' ? 'bg-[#059669] text-white' : 'bg-[#D6E3FE] text-[#003BA5]' }} flex items-center justify-center shrink-0 text-xs font-extrabold">
                                    2
                                </div>
                                <div>
                                    <p class="text-[13.5px] font-extrabold text-[#003BA5]">Verifikasi Berkas</p>
                                    <p class="text-[11.5px] text-[#64748B]">Pengecekan Ijazah, KK &amp; KTP oleh Admin</p>
                                </div>
                            </div>
                            <span class="rounded-full bg-[#FEF3C7] px-2.5 py-0.5 text-[10px] font-extrabold text-[#B45309] uppercase">
                                {{ $registration?->status === 'selesai_terverifikasi' ? 'VALID' : ($registration?->status === 'perlu_revisi' ? 'REVISI' : 'DIPROSES') }}
                            </span>
                        </div>

                        <!-- Step 3 -->
                        <div class="flex items-start justify-between gap-3">
                            <div class="flex items-start gap-3">
                                <div class="w-8 h-8 rounded-full {{ $payment?->status_pembayaran === 'lunas' ? 'bg-[#059669] text-white' : 'bg-[#F1F5F9] text-[#64748B]' }} flex items-center justify-center shrink-0 text-xs font-extrabold">
                                    3
                                </div>
                                <div>
                                    <p class="text-[13.5px] font-bold text-[#475569]">Verifikasi Pembayaran</p>
                                    <p class="text-[11.5px] text-[#64748B]">Pengecekan bukti transfer oleh Staf Keuangan</p>
                                </div>
                            </div>
                            <span class="text-[10.5px] font-bold text-[#64748B] uppercase">
                                {{ strtoupper($payment?->status_pembayaran ?? 'MENUNGGU') }}
                            </span>
                        </div>

                        <!-- Step 4 -->
                        <div class="flex items-start justify-between gap-3">
                            <div class="flex items-start gap-3">
                                <div class="w-8 h-8 rounded-full {{ ($registration?->status === 'selesai_terverifikasi' && $payment?->status_pembayaran === 'lunas') ? 'bg-[#059669] text-white' : 'bg-[#F1F5F9] text-[#64748B]' }} flex items-center justify-center shrink-0 text-xs font-extrabold">
                                    4
                                </div>
                                <div>
                                    <p class="text-[13.5px] font-bold text-[#475569]">Status Akhir Pendaftaran</p>
                                    <p class="text-[11.5px] text-[#64748B]">Pendaftaran Resmi Terverifikasi</p>
                                </div>
                            </div>
                            <span class="text-[10.5px] font-bold text-[#64748B] uppercase">
                                {{ ($registration?->status === 'selesai_terverifikasi' && $payment?->status_pembayaran === 'lunas') ? 'LOLOS' : 'MENUNGGU' }}
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Helpdesk Card -->
                <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 flex items-center justify-between gap-3 shadow-[0_2px_10px_rgba(15,23,42,0.025)]">
                    <div>
                        <p class="text-[13.5px] font-extrabold text-[#161A30]">Butuh Bantuan Pendaftaran?</p>
                        <p class="text-[11.5px] text-[#64748B]">Hubungi Helpdesk PMB Polibatam</p>
                    </div>
                    <button
                        type="button"
                        onclick="document.getElementById('mabaHelpModal').classList.remove('hidden'); document.getElementById('mabaHelpModal').classList.add('flex');"
                        class="rounded-xl bg-[#ECECFF] hover:bg-[#DCE2FF] px-3.5 py-2 text-[12.5px] font-extrabold text-[#003BA5] inline-flex items-center gap-1.5 transition cursor-pointer"
                    >
                        <span>🎧 Bantuan</span>
                    </button>
                </div>
            </main>

            <!-- Bottom Navigation Bar (Maba) -->
            <nav class="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-[430px] bg-white border-t border-[#E6E8F2] px-6 py-2.5 flex items-center justify-around z-40">
                <a href="{{ route('maba.dashboard') }}" class="flex flex-col items-center gap-1 text-[#003BA5] font-extrabold text-[11px]">
                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
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
                <a href="{{ route('maba.profil') }}" class="flex flex-col items-center gap-1 text-[#64748B] hover:text-[#003BA5] font-semibold text-[11px]">
                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                        <circle cx="12" cy="7" r="4" />
                    </svg>
                    <span>Profil</span>
                </a>
            </nav>
        </div>
    </div>

    <!-- Modal Pusat Bantuan -->
    <div
        id="mabaHelpModal"
        class="fixed inset-0 z-50 hidden items-center justify-center bg-slate-900/45 backdrop-blur-xs p-4"
        onclick="if (event.target === this) { this.classList.add('hidden'); this.classList.remove('flex'); }"
    >
        <div class="w-full max-w-sm rounded-3xl bg-white p-6 shadow-2xl">
            <h3 class="text-lg font-extrabold text-[#161A30]">Pusat Bantuan &amp; Info PMB</h3>
            <p class="text-[12.5px] text-[#64748B] mt-0.5">Hubungi petugas resmi Politeknik Negeri Batam</p>
            <div class="mt-4 space-y-2.5">
                @foreach ($contactPersons as $cp)
                    <div class="rounded-2xl border border-[#E2E8F0] bg-[#F8FAFC] p-3.5 flex items-center justify-between gap-2">
                        <div>
                            <p class="text-[13px] font-bold text-[#161A30]">{{ $cp->name }}</p>
                            <p class="text-[11.5px] text-[#64748B]">{{ $cp->phone }}</p>
                        </div>
                        <a href="{{ $cp->whatsappUrl() }}" target="_blank" class="rounded-xl bg-[#10B981] text-white px-3 py-1.5 text-[11.5px] font-bold">
                            Chat WA
                        </a>
                    </div>
                @endforeach
            </div>
            <button
                type="button"
                onclick="document.getElementById('mabaHelpModal').classList.add('hidden'); document.getElementById('mabaHelpModal').classList.remove('flex');"
                class="mt-4 w-full rounded-xl bg-[#F1F5F9] py-2.5 text-[13px] font-bold text-[#334155] cursor-pointer"
            >
                Tutup
            </button>
        </div>
    </div>
</x-layouts.app>
