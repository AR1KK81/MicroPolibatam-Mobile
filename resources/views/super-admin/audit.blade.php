<x-layouts.app title="Audit Log Keamanan — Super Admin Polibatam">
    <div class="min-h-screen bg-[#EEF2FA] flex justify-center">
        <div class="w-full max-w-[430px] min-h-screen bg-[#FBF8FF] flex flex-col justify-between pb-24 relative shadow-[0_0_40px_rgba(15,23,42,0.06)]">
            <!-- Header -->
            <header class="sticky top-0 z-30 bg-[#FBF8FF]/95 backdrop-blur-md border-b border-[#EAE8F5] px-4 h-16 flex items-center justify-between">
                <div>
                    <p class="text-[10.5px] font-extrabold tracking-wider text-[#003BA5] uppercase">KEAMANAN &amp; JEJAK AUDIT</p>
                    <p class="text-[15.5px] font-extrabold text-[#161A30] leading-tight">Audit Logs (`audit_logs`)</p>
                </div>
                <a href="{{ route('super-admin.audit.csv') }}" class="rounded-xl bg-[#DCE9FF] px-3 py-1.5 text-[11.5px] font-extrabold text-[#003BA5]">
                    ⬇ CSV
                </a>
            </header>

            <main class="px-4 pt-4 space-y-4 flex-1">
                <form method="GET" action="{{ route('super-admin.audit') }}">
                    <input
                        type="text"
                        name="q"
                        value="{{ $search }}"
                        placeholder="Cari email aktor, aksi (LOGIN, ACC_BERKAS), atau hasil..."
                        class="w-full rounded-2xl border border-[#E2E8F0] bg-white py-3 px-4 text-[13px] text-[#161A30] placeholder:text-[#94A3B8] focus:border-[#003BA5] focus:outline-none shadow-2xs"
                    >
                </form>

                <div class="space-y-2.5">
                    @forelse ($logs as $log)
                        <div class="rounded-2xl bg-white border border-[#ECEEF8] p-3.5 shadow-2xs space-y-1.5">
                            <div class="flex items-center justify-between gap-2">
                                <span class="rounded-md bg-[#ECECFF] px-2 py-0.5 text-[10px] font-extrabold text-[#003BA5] uppercase">
                                    {{ $log->action }}
                                </span>
                                <span class="text-[11px] text-[#64748B]">
                                    {{ $log->timestamp?->format('d M Y, H:i:s') ?? '-' }}
                                </span>
                            </div>
                            <p class="text-[13px] font-extrabold text-[#161A30]">{{ $log->actor }}</p>
                            <p class="text-[11.5px] text-[#434655]">Objek: <strong>{{ $log->object }}</strong></p>
                            <p class="text-[11.5px] text-[#64748B]">{{ $log->result }}</p>
                        </div>
                    @empty
                        <div class="rounded-2xl bg-white p-8 text-center text-[13px] text-[#64748B]">
                            Belum ada catatan log audit.
                        </div>
                    @endforelse
                </div>
            </main>

            <!-- Bottom Navigation Bar (Super Admin) -->
            <nav class="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-[430px] bg-white border-t border-[#E6E8F2] px-4 py-2.5 flex items-center justify-around z-40">
                <a href="{{ route('super-admin.dashboard') }}" class="flex flex-col items-center gap-1 text-[#64748B] hover:text-[#0052CC] font-semibold text-[11px]">
                    <span>👥 Pengguna</span>
                </a>
                <a href="{{ route('super-admin.master') }}" class="flex flex-col items-center gap-1 text-[#64748B] hover:text-[#0052CC] font-semibold text-[11px]">
                    <span>🗂️ Master Data</span>
                </a>
                <a href="{{ route('super-admin.audit') }}" class="flex flex-col items-center gap-1 text-[#0052CC] font-extrabold text-[11px]">
                    <span>🛡️ Audit Log</span>
                </a>
                <a href="{{ route('super-admin.profil') }}" class="flex flex-col items-center gap-1 text-[#64748B] hover:text-[#0052CC] font-semibold text-[11px]">
                    <span>👤 Profil</span>
                </a>
            </nav>
        </div>
    </div>
</x-layouts.app>
