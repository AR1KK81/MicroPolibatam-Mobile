<x-layouts.app title="Profil Super Admin — PMB Microcredential Polibatam">
    <div class="min-h-screen bg-[#EEF2FA] flex justify-center">
        <div class="w-full max-w-[430px] min-h-screen bg-[#FBF8FF] flex flex-col justify-between pb-24 relative shadow-[0_0_40px_rgba(15,23,42,0.06)]">
            <!-- Header -->
            <header class="sticky top-0 z-30 bg-[#FBF8FF]/95 backdrop-blur-md border-b border-[#EAE8F5] px-4 h-16 flex items-center justify-between">
                <div>
                    <p class="text-[10.5px] font-extrabold tracking-wider text-[#003BA5] uppercase">SUPER ADMIN PORTAL</p>
                    <p class="text-[15.5px] font-extrabold text-[#161A30] leading-tight">Profil &amp; Otoritas</p>
                </div>
            </header>

            <main class="px-4 pt-4 space-y-5 flex-1">
                <div class="rounded-3xl bg-white border border-[#ECEEF8] p-6 text-center shadow-[0_4px_20px_rgba(15,23,42,0.03)]">
                    <div class="w-20 h-20 rounded-full bg-[#003BA5] text-white font-extrabold text-2xl flex items-center justify-center mx-auto shadow-md">
                        SA
                    </div>
                    <h1 class="mt-3 text-[18px] font-extrabold text-[#161A30]">Super Administrator</h1>
                    <p class="text-[12.5px] text-[#64748B]">{{ $user->email }}</p>
                    <span class="mt-2.5 inline-block rounded-full bg-[#CCFBF1] px-3.5 py-1 text-[11px] font-extrabold text-[#059669]">
                        ⚡ Hak Akses Penuh 8 Tabel Database
                    </span>
                </div>

                <div class="grid grid-cols-2 gap-3">
                    <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4">
                        <p class="text-[11.5px] text-[#64748B]">Total Akun Terdaftar</p>
                        <p class="mt-1 text-[22px] font-extrabold text-[#161A30]">{{ $totalUsers }}</p>
                    </div>
                    <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4">
                        <p class="text-[11.5px] text-[#64748B]">Rekam Audit Log</p>
                        <p class="mt-1 text-[22px] font-extrabold text-[#0052CC]">{{ $totalAudit }}</p>
                    </div>
                </div>

                <form method="POST" action="{{ route('logout') }}">
                    @csrf
                    <button
                        type="submit"
                        class="w-full rounded-2xl bg-[#FFDAD6] hover:bg-[#FFC4BE] py-3.5 px-5 text-[14px] font-extrabold text-[#93000A] flex items-center justify-center gap-2 transition cursor-pointer"
                    >
                        <span>&rarr; Keluar dari Sesi Super Admin</span>
                    </button>
                </form>
            </main>

            <!-- Bottom Navigation Bar (Super Admin) -->
            <nav class="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-[430px] bg-white border-t border-[#E6E8F2] px-4 py-2.5 flex items-center justify-around z-40">
                <a href="{{ route('super-admin.dashboard') }}" class="flex flex-col items-center gap-1 text-[#64748B] hover:text-[#0052CC] font-semibold text-[11px]">
                    <span>👥 Pengguna</span>
                </a>
                <a href="{{ route('super-admin.master') }}" class="flex flex-col items-center gap-1 text-[#64748B] hover:text-[#0052CC] font-semibold text-[11px]">
                    <span>🗂️ Master Data</span>
                </a>
                <a href="{{ route('super-admin.audit') }}" class="flex flex-col items-center gap-1 text-[#64748B] hover:text-[#0052CC] font-semibold text-[11px]">
                    <span>🛡️ Audit Log</span>
                </a>
                <a href="{{ route('super-admin.profil') }}" class="flex flex-col items-center gap-1 text-[#0052CC] font-extrabold text-[11px]">
                    <span>👤 Profil</span>
                </a>
            </nav>
        </div>
    </div>
</x-layouts.app>
