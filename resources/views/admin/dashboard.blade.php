<x-layouts.app title="Kelola Berkas — Admin Registrasi PMB Polibatam">
    <div class="min-h-screen bg-[#EEF2FA] flex justify-center">
        <div class="w-full max-w-[430px] min-h-screen bg-[#FBF8FF] flex flex-col justify-between pb-24 relative shadow-[0_0_40px_rgba(15,23,42,0.06)]">
            <!-- Header -->
            <header class="sticky top-0 z-30 bg-[#FBF8FF]/95 backdrop-blur-md border-b border-[#EAE8F5] px-4 h-16 flex items-center justify-between">
                <div>
                    <p class="text-[10.5px] font-extrabold tracking-wider text-[#003BA5] uppercase">MICRO POLIBATAM</p>
                    <p class="text-[15.5px] font-extrabold text-[#161A30] leading-tight">Kelola Berkas</p>
                </div>
                <div class="flex items-center gap-2">
                    <a href="{{ route('admin.riwayat') }}" class="w-9 h-9 rounded-full flex items-center justify-center text-[#434655] hover:bg-[#ECECFF]">
                        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9" />
                            <path d="M13.73 21a2 2 0 0 1-3.46 0" />
                        </svg>
                    </a>
                    <a href="{{ route('admin.profil') }}" class="w-9 h-9 rounded-full bg-[#003BA5] text-white flex items-center justify-center">
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

                <!-- Greeting Banner -->
                <div class="flex items-start justify-between gap-3">
                    <div>
                        <h1 class="text-[22px] font-extrabold text-[#161A30] leading-tight">Halo, Admin Registrasi</h1>
                        <p class="text-[12.5px] text-[#64748B] mt-0.5">Panel Validasi Dokumen &amp; Berkas Maba</p>
                        <span class="mt-2 inline-flex items-center gap-1.5 rounded-full bg-[#DCE9FF] px-3 py-1 text-[10.5px] font-extrabold text-[#003BA5]">
                            <span>🛡️ Staf Admisi &amp; Registrasi</span>
                        </span>
                    </div>
                    <div class="w-12 h-12 rounded-full bg-[#0052CC] text-white font-extrabold text-[15px] flex items-center justify-center shrink-0 shadow-sm">
                        AR
                    </div>
                </div>

                <!-- 2 Summary Stats Cards -->
                <div class="grid grid-cols-2 gap-3">
                    <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)]">
                        <div class="flex items-center justify-between">
                            <span class="text-[12px] font-semibold text-[#64748B]">Perlu Cek</span>
                            <span class="w-8 h-8 rounded-xl bg-[#FEF3C7] text-[#B45309] flex items-center justify-center text-sm">📋</span>
                        </div>
                        <p class="mt-2 text-[22px] font-extrabold text-[#161A30]">{{ $counts['pending_docs'] }} Berkas</p>
                        <p class="text-[11px] font-bold text-[#D97706]">Menunggu validasi</p>
                    </div>

                    <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)]">
                        <div class="flex items-center justify-between">
                            <span class="text-[12px] font-semibold text-[#64748B]">Selesai ACC</span>
                            <span class="w-8 h-8 rounded-xl bg-[#D1FAE5] text-[#059669] flex items-center justify-center text-sm">&#10003;</span>
                        </div>
                        <p class="mt-2 text-[22px] font-extrabold text-[#161A30]">{{ $counts['disetujui'] }} Maba</p>
                        <p class="text-[11px] font-bold text-[#059669]">Telah disetujui</p>
                    </div>
                </div>

                <!-- Search Bar -->
                <form method="GET" action="{{ route('admin.dashboard') }}" class="relative">
                    <input type="hidden" name="tab" value="{{ $tab }}">
                    <span class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3.5 text-[#64748B]">
                        <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8" />
                            <line x1="21" y1="21" x2="16.65" y2="16.65" />
                        </svg>
                    </span>
                    <input
                        type="text"
                        name="q"
                        value="{{ $search }}"
                        placeholder="Cari Nama atau No. Registrasi..."
                        class="w-full rounded-2xl border border-[#E2E8F0] bg-white py-3 pl-10 pr-4 text-[13px] text-[#161A30] placeholder:text-[#94A3B8] focus:border-[#003BA5] focus:outline-none shadow-2xs"
                    >
                </form>

                <!-- 3 Filter Pill Tabs (Perlu Cek, Perlu Revisi, Disetujui) -->
                <div class="flex items-center gap-2 overflow-x-auto pb-1">
                    <a
                        href="{{ route('admin.dashboard', ['tab' => 'perlu_cek', 'q' => $search]) }}"
                        class="rounded-full px-3.5 py-2 text-[12px] font-bold inline-flex items-center gap-1.5 shrink-0 transition {{ $tab === 'perlu_cek' ? 'bg-[#0052CC] text-white shadow-xs' : 'bg-white border border-[#E2E8F0] text-[#475569]' }}"
                    >
                        <span>Perlu Cek</span>
                        <span class="rounded-full px-1.5 py-0.2 text-[10.5px] {{ $tab === 'perlu_cek' ? 'bg-white/25 text-white' : 'bg-[#ECECFF] text-[#003BA5]' }}">
                            {{ $counts['perlu_cek'] }}
                        </span>
                    </a>

                    <a
                        href="{{ route('admin.dashboard', ['tab' => 'perlu_revisi', 'q' => $search]) }}"
                        class="rounded-full px-3.5 py-2 text-[12px] font-bold inline-flex items-center gap-1.5 shrink-0 transition {{ $tab === 'perlu_revisi' ? 'bg-[#0052CC] text-white shadow-xs' : 'bg-white border border-[#E2E8F0] text-[#475569]' }}"
                    >
                        <span>Perlu Revisi</span>
                        <span class="rounded-full px-1.5 py-0.2 text-[10.5px] {{ $tab === 'perlu_revisi' ? 'bg-white/25 text-white' : 'bg-[#ECECFF] text-[#003BA5]' }}">
                            {{ $counts['perlu_revisi'] }}
                        </span>
                    </a>

                    <a
                        href="{{ route('admin.dashboard', ['tab' => 'disetujui', 'q' => $search]) }}"
                        class="rounded-full px-3.5 py-2 text-[12px] font-bold inline-flex items-center gap-1.5 shrink-0 transition {{ $tab === 'disetujui' ? 'bg-[#0052CC] text-white shadow-xs' : 'bg-white border border-[#E2E8F0] text-[#475569]' }}"
                    >
                        <span>Disetujui</span>
                        <span class="rounded-full px-1.5 py-0.2 text-[10.5px] {{ $tab === 'disetujui' ? 'bg-white/25 text-white' : 'bg-[#ECECFF] text-[#003BA5]' }}">
                            {{ $counts['disetujui'] }}
                        </span>
                    </a>
                </div>

                <!-- Applicant Cards List -->
                <div class="flex items-center justify-between">
                    <div class="flex items-center gap-2">
                        <h2 class="text-[16px] font-extrabold text-[#161A30]">Daftar Berkas Masuk</h2>
                        <span class="rounded-full bg-[#DCE9FF] px-2.5 py-0.5 text-[10.5px] font-extrabold text-[#003BA5]">
                            {{ $registrations->count() }} Antrean
                        </span>
                    </div>
                </div>

                <div class="space-y-3">
                    @forelse ($registrations as $reg)
                        <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_12px_rgba(15,23,42,0.03)] space-y-3">
                            <div class="flex items-center justify-between gap-2">
                                <span class="rounded-full bg-[#DCE9FF] px-3 py-1 text-[11px] font-extrabold text-[#003BA5]">
                                    &lt;/&gt; {{ $reg->track?->department_name ?? 'Informatika' }}
                                </span>

                                @if ($reg->status === 'selesai_terverifikasi')
                                    <span class="rounded-full bg-[#D1FAE5] px-2.5 py-1 text-[10px] font-extrabold text-[#059669] uppercase">
                                        &#10003; DISETUJUI
                                    </span>
                                @elseif ($reg->status === 'perlu_revisi')
                                    <span class="rounded-full bg-[#FFDAD6] px-2.5 py-1 text-[10px] font-extrabold text-[#93000A] uppercase">
                                        ! PERLU REVISI
                                    </span>
                                @else
                                    <span class="rounded-full bg-[#FEF3C7] px-2.5 py-1 text-[10px] font-extrabold text-[#B45309] uppercase">
                                        &bull; BELUM VERIFIKASI
                                    </span>
                                @endif
                            </div>

                            <div class="flex items-center justify-between">
                                <div>
                                    <h3 class="text-[16.5px] font-extrabold text-[#161A30]">{{ $reg->full_name }}</h3>
                                    <p class="text-[12px] text-[#64748B] font-medium">{{ $reg->registrationCode() }} &bull; {{ $reg->origin_school }}</p>
                                </div>
                                <div class="w-9 h-9 rounded-full bg-[#ECECFF] text-[#003BA5] flex items-center justify-center font-bold text-xs">
                                    {{ $reg->initials() }}
                                </div>
                            </div>

                            <div class="rounded-xl bg-[#F4F2FF] p-3 space-y-1 text-[12px]">
                                <p class="text-[#434655]">
                                    📄 Berkas:
                                    <strong class="text-[#161A30]">
                                        {{ $reg->documents->pluck('doc_type')->map(fn ($t) => strtoupper((string) $t))->join(', ') ?: 'Belum ada berkas' }}
                                    </strong>
                                    ({{ $reg->documents->count() }}/3)
                                </p>
                                <p class="text-[#64748B]">
                                    🕒 Diperbarui: {{ $reg->updated_at?->format('d M Y, H:i') ?? '-' }} WIB
                                </p>
                            </div>

                            @if ($reg->status === 'perlu_revisi' && $reg->admin_verification_notes)
                                <div class="rounded-xl bg-[#FFF5F5] border border-[#FED7D7] p-3 text-[11.5px]">
                                    <p class="font-extrabold text-[#93000A]">⚠️ Catatan Admin:</p>
                                    <p class="text-[#434655] mt-0.5">{{ $reg->admin_verification_notes }}</p>
                                </div>
                            @elseif ($reg->status === 'selesai_terverifikasi')
                                <div class="rounded-xl bg-[#ECFDF5] border border-[#A7F3D0] px-3 py-2 text-[11.5px] font-bold text-[#059669]">
                                    &#10003; Verifikasi Berkas Selesai | {{ $reg->updated_at?->format('d M Y, H:i') }} WIB
                                </div>
                            @endif

                            @if ($reg->status === 'perlu_revisi')
                                <a
                                    href="{{ route('admin.registrations.show', $reg->registration_id) }}"
                                    class="w-full rounded-xl border border-[#0052CC] bg-white hover:bg-[#F3F8FF] py-2.5 text-[13px] font-extrabold text-[#0052CC] flex items-center justify-center gap-2 transition"
                                >
                                    <span>Detail &amp; Edit Catatan</span>
                                    <span>&rarr;</span>
                                </a>
                            @elseif ($reg->status === 'selesai_terverifikasi')
                                <a
                                    href="{{ route('admin.registrations.show', $reg->registration_id) }}"
                                    class="w-full rounded-xl border border-[#CBD5E1] bg-white hover:bg-[#F8FAFC] py-2.5 text-[13px] font-extrabold text-[#003BA5] flex items-center justify-center gap-2 transition"
                                >
                                    <span>Lihat Berkas Terverifikasi</span>
                                    <span>&rarr;</span>
                                </a>
                            @else
                                <a
                                    href="{{ route('admin.registrations.show', $reg->registration_id) }}"
                                    class="w-full rounded-xl bg-[#0052CC] hover:bg-[#003E9C] py-3 text-[13.5px] font-bold text-white flex items-center justify-center gap-2 transition"
                                >
                                    <span>Verifikasi Berkas</span>
                                    <span>&rarr;</span>
                                </a>
                            @endif
                        </div>
                    @empty
                        <div class="rounded-2xl bg-white border border-[#ECEEF8] p-8 text-center">
                            <p class="text-[14px] font-bold text-[#161A30]">Tidak ada antrean berkas pada kategori ini</p>
                            <p class="text-[12px] text-[#64748B] mt-1">Pilih tab kategori lain atau ubah kata kunci pencarian.</p>
                        </div>
                    @endforelse
                </div>
            </main>

            <!-- Bottom Navigation Bar (Admin) -->
            <nav class="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-[430px] bg-white border-t border-[#E6E8F2] px-6 py-2.5 flex items-center justify-around z-40">
                <a href="{{ route('admin.dashboard') }}" class="flex flex-col items-center gap-1 text-[#0052CC] font-extrabold text-[11px]">
                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
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
                <a href="{{ route('admin.profil') }}" class="flex flex-col items-center gap-1 text-[#64748B] hover:text-[#0052CC] font-semibold text-[11px]">
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
