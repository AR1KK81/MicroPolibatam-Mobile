<x-layouts.app title="Riwayat Verifikasi Berkas — Admin PMB Polibatam">
    <div class="min-h-screen bg-[#EEF2FA] flex justify-center">
        <div class="w-full max-w-[430px] min-h-screen bg-[#FBF8FF] flex flex-col justify-between pb-24 relative shadow-[0_0_40px_rgba(15,23,42,0.06)]">
            <!-- Header (Frame 328:597) -->
            <header class="sticky top-0 z-30 bg-[#FBF8FF]/95 backdrop-blur-md border-b border-[#EAE8F5] px-4 py-3 flex items-center justify-between">
                <div>
                    <p class="text-[10.5px] font-extrabold tracking-wider text-[#003BA5] uppercase">🎓 PMB MICRO POLIBATAM</p>
                    <h1 class="text-[18px] font-extrabold text-[#161A30] leading-tight">Riwayat</h1>
                    <p class="text-[11.5px] text-[#64748B]">Rekam jejak aktivitas verifikasi berkas Maba</p>
                </div>
                <a href="{{ route('admin.profil') }}" class="w-9 h-9 rounded-full bg-[#003BA5] text-white flex items-center justify-center">
                    <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                        <circle cx="12" cy="7" r="4" />
                    </svg>
                </a>
            </header>

            <main class="px-4 pt-4 space-y-4 flex-1">
                <!-- Search -->
                <form method="GET" action="{{ route('admin.riwayat') }}" class="relative">
                    <input
                        type="text"
                        name="q"
                        value="{{ $search }}"
                        placeholder="Cari pendaftar atau ID registrasi..."
                        class="w-full rounded-2xl border border-[#E2E8F0] bg-white py-3 px-4 text-[13px] text-[#161A30] placeholder:text-[#94A3B8] focus:border-[#003BA5] focus:outline-none shadow-2xs"
                    >
                </form>

                <!-- Timeline Cards -->
                <div class="space-y-3">
                    @foreach ($registrations as $reg)
                        <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)] space-y-2.5 {{ $reg->status === 'perlu_revisi' ? 'border-l-4 border-l-red-500' : '' }}">
                            <div class="flex items-center justify-between">
                                <div>
                                    <p class="text-[13.5px] font-extrabold {{ $reg->status === 'perlu_revisi' ? 'text-[#93000A]' : 'text-[#161A30]' }}">
                                        @if ($reg->status === 'selesai_terverifikasi')
                                            Berkas Disetujui
                                        @elseif ($reg->status === 'perlu_revisi')
                                            Catatan Revisi Dikirim
                                        @else
                                            Menunggu Verifikasi
                                        @endif
                                    </p>
                                    <p class="text-[11px] text-[#64748B]">🕒 {{ $reg->updated_at?->format('d M Y, H:i') }} WIB</p>
                                </div>

                                @if ($reg->status === 'selesai_terverifikasi')
                                    <span class="rounded-full bg-[#D1FAE5] px-2.5 py-0.5 text-[10.5px] font-extrabold text-[#059669]">ACC</span>
                                @elseif ($reg->status === 'perlu_revisi')
                                    <span class="rounded-full bg-[#FFDAD6] px-2.5 py-0.5 text-[10.5px] font-extrabold text-[#93000A]">REVISI</span>
                                @else
                                    <span class="rounded-full bg-[#FEF3C7] px-2.5 py-0.5 text-[10.5px] font-extrabold text-[#B45309]">ANTREAN</span>
                                @endif
                            </div>

                            <div class="rounded-xl bg-[#F4F2FF] p-3 flex items-center justify-between gap-2">
                                <div>
                                    <p class="text-[14px] font-extrabold text-[#161A30]">{{ $reg->full_name }}</p>
                                    <p class="text-[11.5px] font-semibold text-[#434655]">{{ $reg->registrationCode() }}</p>
                                </div>
                                <span class="rounded-lg bg-[#DCE9FF] px-2.5 py-1 text-[10.5px] font-bold text-[#003BA5]">
                                    {{ $reg->track?->department_name ?? 'Informatika' }}
                                </span>
                            </div>

                            @if ($reg->admin_verification_notes)
                                <div class="rounded-xl bg-[#FFDAD6]/40 p-3 text-[12px]">
                                    <p class="font-extrabold text-[#93000A]">ⓘ CATATAN ADMIN:</p>
                                    <p class="mt-0.5 text-[#434655]">{{ $reg->admin_verification_notes }}</p>
                                </div>
                            @else
                                <p class="text-[12px] text-[#434655]">
                                    Total {{ $reg->documents->count() }} berkas telah terdaftar pada sistem admisi.
                                </p>
                            @endif

                            <div class="pt-1 flex items-center justify-between text-[12px]">
                                <span class="text-[#64748B]">🪪 Admin Registrasi</span>
                                <a href="{{ route('admin.registrations.show', $reg->registration_id) }}" class="font-bold text-[#0052CC] hover:underline">
                                    Detail &rsaquo;
                                </a>
                            </div>
                        </div>
                    @endforeach
                </div>

                <!-- Download CSV Button -->
                <div class="pt-2">
                    <a
                        href="{{ route('admin.riwayat.csv') }}"
                        class="w-full rounded-2xl bg-[#EBF1FF] hover:bg-[#DCE7FF] py-3.5 px-4 text-[13px] font-extrabold text-[#003BA5] flex items-center justify-center gap-2 transition"
                    >
                        <span>⬇ Unduh Rekapitulasi Audit (.CSV)</span>
                    </a>
                </div>
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
                <a href="{{ route('admin.riwayat') }}" class="flex flex-col items-center gap-1 text-[#0052CC] font-extrabold text-[11px]">
                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
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
