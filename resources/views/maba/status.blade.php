<x-layouts.app title="Detail Status & Berkas — PMB Microcredential">
    @php
        $displayName = $registration?->full_name ?? ucfirst(strtok($user->email, '@') ?: 'Maba');
        $regCode = $registration?->registrationCode() ?? ('PMB-MC-26-' . $user->user_id);
        $docs = $registration?->documents ?? collect();
        $revisionDocsCount = $docs->where('status_verifikasi_admin', 'revisi')->count();
        $payment = $registration?->payment;
        $docLabels = [
            'ijazah' => ['title' => 'Ijazah / SKHU', 'sub' => 'Diverifikasi Admin Registrasi'],
            'ktp' => ['title' => 'Kartu Tanda Penduduk (KTP)', 'sub' => 'Diverifikasi Admin Registrasi'],
            'kk' => ['title' => 'Kartu Keluarga (KK)', 'sub' => 'Diverifikasi Admin Registrasi'],
        ];
    @endphp

    <div class="min-h-screen bg-[#EEF2FA] flex justify-center">
        <div class="w-full max-w-[430px] min-h-screen bg-[#FBF8FF] flex flex-col justify-between pb-24 relative shadow-[0_0_40px_rgba(15,23,42,0.06)]">
            <!-- Header -->
            <header class="sticky top-0 z-30 bg-[#FBF8FF]/95 backdrop-blur-md border-b border-[#EAE8F5] px-4 h-16 flex items-center justify-between">
                <div class="flex items-center gap-2.5">
                    <div class="w-9 h-9 rounded-xl bg-[#E8F0FE] text-[#003BA5] flex items-center justify-center">
                        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M22 10v6M2 10l10-5 10 5-10 5z" />
                            <path d="M6 12v5c3 3 9 3 12 0v-5" />
                        </svg>
                    </div>
                    <div>
                        <p class="text-[10px] font-bold tracking-wider text-[#64748B] uppercase">PMB MICROCREDENTIAL</p>
                        <p class="text-[15px] font-extrabold text-[#161A30] leading-tight">Status</p>
                    </div>
                </div>
                <a href="{{ route('maba.formulir') }}" class="rounded-xl bg-[#003BA5] text-white px-3 py-1.5 text-[11.5px] font-bold">
                    Formulir &rarr;
                </a>
            </header>

            <!-- Content -->
            <main class="px-4 pt-4 space-y-4 flex-1">
                @if (session('status'))
                    <div class="rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-[12.5px] font-semibold text-emerald-800">
                        {{ session('status') }}
                    </div>
                @endif

                <!-- Context Pill & Title -->
                <div>
                    <span class="inline-flex items-center gap-1.5 rounded-full bg-[#ECECFF] px-3 py-1 text-[11px] font-extrabold text-[#003BA5]">
                        <span class="w-2 h-2 rounded-full bg-[#003BA5]"></span>
                        <span>{{ $regCode }} &bull; {{ $displayName }}</span>
                    </span>
                    <h1 class="mt-2.5 text-[22px] font-extrabold text-[#161A30]">Detail Status &amp; Berkas</h1>
                    <p class="text-[12.5px] text-[#64748B]">Rincian verifikasi pendaftaran kamu</p>
                </div>

                @if ($revisionDocsCount > 0 || $registration?->status === 'perlu_revisi')
                    <a href="{{ route('maba.formulir', ['tab' => 'dokumen']) }}" class="block rounded-2xl bg-white border border-red-200 p-3.5 shadow-2xs">
                        <div class="flex items-center justify-between gap-3">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-xl bg-[#FFDAD6] text-[#93000A] flex items-center justify-center shrink-0 font-bold">
                                    !
                                </div>
                                <div>
                                    <p class="text-[13.5px] font-extrabold text-[#161A30]">{{ max($revisionDocsCount, 1) }} Berkas Perlu Tindakan</p>
                                    <p class="text-[11.5px] text-[#64748B]">Segera perbarui berkas di menu Formulir</p>
                                </div>
                            </div>
                            <span class="rounded-full bg-[#FFDAD6] px-3 py-1 text-[11px] font-extrabold text-[#93000A]">
                                Revisi
                            </span>
                        </div>
                    </a>
                @endif

                <!-- Verifikasi Berkas Akademik -->
                <div>
                    <h2 class="text-[15px] font-extrabold text-[#161A30]">🛡️ Verifikasi Berkas Akademik</h2>
                    <p class="text-[11.5px] text-[#64748B] mb-3">Divalidasi oleh Tim Registrasi &amp; Admisi</p>

                    <div class="space-y-3">
                        @foreach ($docLabels as $type => $meta)
                            @php
                                $doc = $docs->firstWhere('doc_type', $type);
                            @endphp
                            <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)] space-y-3">
                                <div class="flex items-start justify-between gap-2">
                                    <div>
                                        <p class="text-[14px] font-extrabold text-[#161A30]">{{ $meta['title'] }}</p>
                                        <p class="text-[11.5px] text-[#64748B]">{{ $meta['sub'] }}</p>
                                    </div>
                                    @if ($doc?->status_verifikasi_admin === 'valid')
                                        <span class="rounded-full bg-[#DCE9FF] px-3 py-1 text-[10.5px] font-extrabold text-[#003BA5] uppercase">
                                            DISETUJUI
                                        </span>
                                    @elseif ($doc?->status_verifikasi_admin === 'revisi')
                                        <span class="rounded-full bg-[#FFDAD6] px-3 py-1 text-[10.5px] font-extrabold text-[#93000A] uppercase">
                                            PERLU REVISI
                                        </span>
                                    @elseif ($doc !== null)
                                        <span class="rounded-full bg-[#FEF3C7] px-3 py-1 text-[10.5px] font-extrabold text-[#B45309] uppercase">
                                            MENUNGGU
                                        </span>
                                    @else
                                        <span class="rounded-full bg-[#F1F5F9] px-3 py-1 text-[10.5px] font-extrabold text-[#64748B] uppercase">
                                            BELUM ADA
                                        </span>
                                    @endif
                                </div>

                                @if ($doc !== null)
                                    <div class="rounded-xl bg-[#F4F2FF] px-3.5 py-2.5 flex items-center justify-between text-[12.5px]">
                                        <span class="font-semibold text-[#161A30] truncate">{{ basename($doc->file_path) }}</span>
                                        <a href="{{ route('maba.formulir', ['tab' => 'dokumen']) }}" class="text-[#003BA5] font-bold text-[11.5px] shrink-0 ml-2">
                                            Ubah
                                        </a>
                                    </div>
                                @else
                                    <a href="{{ route('maba.formulir', ['tab' => 'dokumen']) }}" class="block rounded-xl border border-dashed border-[#C8DCFF] bg-[#F8FAFF] py-2.5 text-center text-[12px] font-bold text-[#003BA5]">
                                        + Unggah {{ $meta['title'] }}
                                    </a>
                                @endif

                                @if ($doc?->status_verifikasi_admin === 'revisi' || ($type === 'ijazah' && $registration?->admin_verification_notes))
                                    <div class="rounded-xl bg-[#FFDAD6]/45 p-3 text-[12px] text-[#161A30]">
                                        <p class="font-extrabold text-[#93000A]">⚠️ Catatan Admin:</p>
                                        <p class="mt-1 text-[#434655] leading-relaxed">
                                            {{ $doc?->admin_revision_notes ?: $registration?->admin_verification_notes }}
                                        </p>
                                    </div>
                                @endif
                            </div>
                        @endforeach
                    </div>
                </div>

                <!-- Verifikasi Pembayaran -->
                <div>
                    <h2 class="text-[15px] font-extrabold text-[#161A30]">💳 Verifikasi Pembayaran</h2>
                    <p class="text-[11.5px] text-[#64748B] mb-3">Divalidasi oleh Bagian Keuangan Polibatam</p>

                    <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)] space-y-3">
                        <div class="flex items-start justify-between gap-2">
                            <div>
                                <p class="text-[14px] font-extrabold text-[#161A30]">Bukti Transfer Admisi</p>
                                <p class="text-[11.5px] text-[#64748B]">Diverifikasi Staf Keuangan</p>
                            </div>
                            @if ($payment?->status_pembayaran === 'lunas')
                                <span class="rounded-full bg-[#DCE9FF] px-3 py-1 text-[10.5px] font-extrabold text-[#003BA5] uppercase">
                                    DISETUJUI
                                </span>
                            @elseif ($payment?->status_pembayaran === 'ditolak')
                                <span class="rounded-full bg-[#FFDAD6] px-3 py-1 text-[10.5px] font-extrabold text-[#93000A] uppercase">
                                    DITOLAK / REVISI
                                </span>
                            @elseif ($payment !== null)
                                <span class="rounded-full bg-[#FEF3C7] px-3 py-1 text-[10.5px] font-extrabold text-[#B45309] uppercase">
                                    MENUNGGU
                                </span>
                            @else
                                <span class="rounded-full bg-[#F1F5F9] px-3 py-1 text-[10.5px] font-extrabold text-[#64748B] uppercase">
                                    BELUM BAYAR
                                </span>
                            @endif
                        </div>

                        <div class="rounded-xl bg-[#F4F2FF] p-3.5 space-y-2 text-[12.5px]">
                            <div class="flex justify-between">
                                <span class="text-[#64748B]">Metode Bayar</span>
                                <span class="font-bold text-[#161A30]">{{ $payment?->rekening?->bank_name ?? 'Transfer Rekening BNI' }}</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-[#64748B]">No. Rekening Tujuan</span>
                                <span class="font-bold text-[#161A30]">{{ $payment?->rekening?->account_number ?? '1003301245' }}</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-[#64748B]">Status Pelunasan</span>
                                <span class="font-extrabold text-[#003BA5]">
                                    Rp {{ number_format((float) ($payment?->amount ?? 200000), 0, ',', '.') }}
                                </span>
                            </div>
                        </div>

                        @if ($payment?->finance_notes)
                            <div class="rounded-xl bg-[#FFDAD6]/45 p-3 text-[12px]">
                                <p class="font-extrabold text-[#93000A]">Catatan Staf Keuangan:</p>
                                <p class="mt-0.5 text-[#434655]">{{ $payment->finance_notes }}</p>
                            </div>
                        @endif
                    </div>
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
                <a href="{{ route('maba.status') }}" class="flex flex-col items-center gap-1 text-[#003BA5] font-extrabold text-[11px]">
                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
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
</x-layouts.app>
