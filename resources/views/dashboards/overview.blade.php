<x-layouts.app :title="'Dashboard ' . $roleLabel . ' — Sistem PMB Microcredential'">
    <div class="min-h-screen bg-[#F8FAFF]">
        <!-- Top Navigation -->
        <header class="bg-white border-b border-[#E3ECFB]">
            <div class="max-w-6xl mx-auto px-4 sm:px-6 h-16 flex items-center justify-between gap-4">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-xl bg-[#F4F8FF] border border-[#DCE8FF] flex items-center justify-center">
                        <x-mp-logo class="w-8 h-5" />
                    </div>
                    <div>
                        <p class="text-[14px] font-extrabold text-[#0F172A] leading-tight">Sistem PMB Microcredential</p>
                        <p class="text-[11.5px] font-semibold text-[#059669]">{{ $roleLabel }}</p>
                    </div>
                </div>

                <div class="flex items-center gap-3">
                    <span class="hidden sm:inline-block text-[13px] font-medium text-[#475569]">
                        {{ $user->email }}
                    </span>
                    <form method="POST" action="{{ route('logout') }}">
                        @csrf
                        <button
                            type="submit"
                            class="inline-flex items-center gap-1.5 rounded-xl border border-[#E2E8F0] bg-white hover:bg-red-50 hover:border-red-200 hover:text-red-600 px-3.5 py-2 text-[13px] font-bold text-[#334155] transition cursor-pointer"
                        >
                            <span>Keluar</span>
                        </button>
                    </form>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="max-w-6xl mx-auto px-4 sm:px-6 py-8">
            <div class="rounded-[22px] border border-[#E3ECFB] bg-white p-6 sm:p-8 shadow-[0_8px_30px_rgba(15,35,95,0.04)]">
                <span class="inline-block rounded-full bg-[#CCFBF1] px-3.5 py-1 text-[11px] font-extrabold tracking-wider text-[#059669] uppercase">
                    Sesi Aktif &bull; {{ $roleLabel }}
                </span>
                <h1 class="mt-3 text-2xl font-extrabold text-[#0F172A]">
                    Selamat Datang di Dashboard {{ $roleLabel }}
                </h1>
                <p class="mt-1 text-[14px] text-[#64748B]">
                    Anda berhasil masuk menggunakan akun <strong class="text-[#0F172A]">{{ $user->email }}</strong>. Data di bawah ini ditarik langsung dari database <code class="text-[#0052CC] font-semibold">micropolibatam</code>.
                </p>

                <div class="mt-6 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                    @foreach ($stats as $stat)
                        <div class="rounded-2xl border border-[#E2E8F0] bg-[#F8FAFC] p-4">
                            <p class="text-[12px] font-semibold text-[#64748B]">{{ $stat['label'] }}</p>
                            <p class="mt-1.5 text-[17px] font-extrabold text-[#0F172A]">{{ $stat['value'] }}</p>
                        </div>
                    @endforeach
                </div>
            </div>
        </main>
    </div>
</x-layouts.app>

