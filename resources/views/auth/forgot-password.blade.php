<x-layouts.app title="Pemulihan Kata Sandi — Sistem PMB Microcredential Polibatam">
    <div class="min-h-screen flex flex-col justify-between bg-gradient-to-b from-[#F4F8FF] via-[#FAFCFF] to-[#FFFFFF] px-4 py-5 sm:px-6 sm:py-6">
        <!-- Top Right Back to Login -->
        <div class="w-full max-w-5xl mx-auto flex justify-end">
            <a
                href="{{ route('login') }}"
                class="inline-flex items-center gap-2 rounded-full border border-[#C8DCFF] bg-[#F3F8FF] px-4 py-2 text-[13px] font-bold text-[#0052CC] shadow-[0_2px_10px_rgba(0,82,204,0.06)] hover:bg-[#E7F0FF] transition"
            >
                <svg class="w-4 h-4 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="m15 18-6-6 6-6" />
                </svg>
                <span>Kembali ke Login</span>
            </a>
        </div>

        <!-- Center Content -->
        <main class="w-full flex flex-col items-center justify-center my-auto py-6">
            <div class="w-full max-w-[410px] text-center">
                <!-- Logo Container -->
                <div class="w-16 h-16 rounded-2xl bg-white shadow-[0_2px_14px_rgba(15,23,42,0.04)] flex items-center justify-center mx-auto">
                    <x-mp-logo class="w-12 h-7" />
                </div>

                <!-- Badge -->
                <div class="mt-3.5">
                    <span class="inline-block rounded-full bg-[#CCFBF1] px-4 py-1 text-[11px] font-extrabold tracking-[0.06em] text-[#059669] uppercase">
                        PEMULIHAN MANDIRI VIA OTP
                    </span>
                </div>

                <!-- Title & Subtitle -->
                <h1 class="mt-3 text-[24px] sm:text-[26px] font-extrabold tracking-[-0.025em] text-[#0F172A] leading-tight">
                    @if ($step === 'email')
                        Lupa Kata Sandi?
                    @elseif ($step === 'verify')
                        Verifikasi Kode OTP
                    @else
                        Buat Kata Sandi Baru
                    @endif
                </h1>
                <p class="mt-2 text-[13.5px] text-[#64748B] leading-[1.6] max-w-[360px] mx-auto">
                    @if ($step === 'email')
                        Masukkan email akun terdaftar Anda untuk menerima kode OTP 6-digit pemulihan kata sandi.
                    @elseif ($step === 'verify')
                        Masukkan 6-digit kode OTP yang telah dikirimkan ke <strong class="text-[#0F172A]">{{ $email }}</strong>.
                    @else
                        Verifikasi OTP berhasil. Silakan masukkan kata sandi baru untuk akun <strong class="text-[#0F172A]">{{ $email }}</strong>.
                    @endif
                </p>

                <!-- Step Indicator -->
                <div class="mt-4 flex items-center justify-center gap-2 text-[11.5px] font-bold">
                    <span class="px-2.5 py-1 rounded-full {{ $step === 'email' ? 'bg-[#0052CC] text-white' : 'bg-[#D1FAE5] text-[#059669]' }}">1. Email</span>
                    <span class="text-[#CBD5E1]">&rarr;</span>
                    <span class="px-2.5 py-1 rounded-full {{ $step === 'verify' ? 'bg-[#0052CC] text-white' : ($step === 'reset' ? 'bg-[#D1FAE5] text-[#059669]' : 'bg-[#F1F5F9] text-[#64748B]') }}">2. Kode OTP</span>
                    <span class="text-[#CBD5E1]">&rarr;</span>
                    <span class="px-2.5 py-1 rounded-full {{ $step === 'reset' ? 'bg-[#0052CC] text-white' : 'bg-[#F1F5F9] text-[#64748B]' }}">3. Sandi Baru</span>
                </div>

                <!-- Card -->
                <div class="mt-5 w-full rounded-[22px] border border-[#E3ECFB] bg-white p-6 sm:p-7 text-left shadow-[0_10px_35px_rgba(15,35,95,0.045)]">
                    @if (session('status'))
                        <div class="mb-5 rounded-[13px] border border-emerald-200 bg-emerald-50/80 px-4 py-3 text-[13px] text-emerald-800 flex items-start gap-2.5">
                            <svg class="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                                <polyline points="22 4 12 14.01 9 11.01" />
                            </svg>
                            <span>{{ session('status') }}</span>
                        </div>
                    @endif

                    @if (! empty($devOtp))
                        <div class="mb-5 rounded-[13px] border border-blue-200 bg-[#F3F8FF] px-4 py-3 text-[12.5px] text-[#0F172A]">
                            <p class="font-bold text-[#0052CC]">Mode Lokal (Simulasi OTP Email):</p>
                            <p class="mt-0.5 text-[#475569]">
                                Karena SMTP Gmail belum diisi di <code class="font-mono">.env</code>, berikut kode OTP Anda untuk pengujian:
                            </p>
                            <div class="mt-2 inline-block rounded-xl bg-white border border-[#C8DCFF] px-3.5 py-1.5 font-mono text-lg font-extrabold tracking-[0.25em] text-[#0052CC]">
                                {{ $devOtp }}
                            </div>
                        </div>
                    @endif

                    @if ($errors->any())
                        <div class="mb-5 rounded-[13px] border border-red-200 bg-red-50/80 px-4 py-3 text-[13px] text-red-700 flex items-start gap-2.5">
                            <svg class="w-4 h-4 text-red-600 shrink-0 mt-0.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10" />
                                <line x1="12" y1="8" x2="12" y2="12" />
                                <line x1="12" y1="16" x2="12.01" y2="16" />
                            </svg>
                            <span>{{ $errors->first() }}</span>
                        </div>
                    @endif

                    @if ($step === 'email')
                        <form method="POST" action="{{ route('password.otp.send') }}" class="space-y-4">
                            @csrf
                            <div>
                                <div class="flex items-center justify-between mb-2">
                                    <label for="email" class="text-[13.5px] font-bold text-[#0F172A]">
                                        Email Akun Terdaftar
                                    </label>
                                    <span class="text-[12px] font-medium text-[#64748B]">
                                        Gmail / SSO
                                    </span>
                                </div>
                                <div class="relative">
                                    <span class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4 text-[#64748B]">
                                        <svg class="w-[18px] h-[18px]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round">
                                            <circle cx="12" cy="12" r="4" />
                                            <path d="M16 8v5a3 3 0 0 0 6 0v-1a10 10 0 1 0-4 8" />
                                        </svg>
                                    </span>
                                    <input
                                        id="email"
                                        name="email"
                                        type="email"
                                        value="{{ old('email', $email) }}"
                                        required
                                        autofocus
                                        placeholder="nama@gmail.com"
                                        class="w-full rounded-[13px] border border-[#E2E8F0] bg-[#F8FAFC] py-3 pl-11 pr-4 text-[14px] text-[#0F172A] placeholder:text-[#94A3B8] focus:border-[#0052CC] focus:bg-white focus:ring-3 focus:ring-[#0052CC]/12 focus:outline-none transition"
                                    >
                                </div>
                            </div>

                            <div class="pt-1">
                                <button
                                    type="submit"
                                    class="w-full rounded-[14px] bg-[#0052CC] hover:bg-[#0043A8] active:scale-[0.995] py-3.5 px-5 text-[15px] font-bold text-white shadow-[0_6px_18px_rgba(0,82,204,0.24)] inline-flex items-center justify-center gap-2 transition cursor-pointer"
                                >
                                    <span>Kirim Kode OTP ke Email</span>
                                </button>
                            </div>
                        </form>
                    @elseif ($step === 'verify')
                        <form method="POST" action="{{ route('password.otp.verify') }}" class="space-y-4">
                            @csrf
                            <div>
                                <div class="flex items-center justify-between mb-2">
                                    <label for="otp" class="text-[13.5px] font-bold text-[#0F172A]">
                                        Kode OTP 6-Digit
                                    </label>
                                    <span class="text-[12px] font-medium text-[#059669]">
                                        Berlaku 10 Menit
                                    </span>
                                </div>
                                <input
                                    id="otp"
                                    name="otp"
                                    type="text"
                                    inputmode="numeric"
                                    pattern="[0-9]{6}"
                                    maxlength="6"
                                    required
                                    autofocus
                                    placeholder="000000"
                                    class="w-full rounded-[13px] border border-[#E2E8F0] bg-[#F8FAFC] py-3.5 px-4 text-center font-mono text-[22px] font-extrabold tracking-[0.45em] text-[#0F172A] placeholder:text-[#CBD5E1] focus:border-[#0052CC] focus:bg-white focus:ring-3 focus:ring-[#0052CC]/12 focus:outline-none transition"
                                >
                            </div>

                            <div class="pt-1">
                                <button
                                    type="submit"
                                    class="w-full rounded-[14px] bg-[#0052CC] hover:bg-[#0043A8] active:scale-[0.995] py-3.5 px-5 text-[15px] font-bold text-white shadow-[0_6px_18px_rgba(0,82,204,0.24)] inline-flex items-center justify-center gap-2 transition cursor-pointer"
                                >
                                    <span>Verifikasi Kode OTP</span>
                                </button>
                            </div>
                        </form>

                        <div class="mt-4 pt-4 border-t border-[#E2E8F0] flex items-center justify-between text-[12.5px]">
                            <a href="{{ route('password.otp.request') }}" class="text-[#64748B] hover:text-[#0F172A] font-medium">
                                Ganti alamat email
                            </a>
                            <form method="POST" action="{{ route('password.otp.send') }}">
                                @csrf
                                <input type="hidden" name="email" value="{{ $email }}">
                                <button type="submit" class="font-bold text-[#0052CC] hover:underline cursor-pointer">
                                    Kirim Ulang OTP
                                </button>
                            </form>
                        </div>
                    @else
                        <form method="POST" action="{{ route('password.otp.reset') }}" class="space-y-4">
                            @csrf
                            <div>
                                <label for="password" class="block text-[13.5px] font-bold text-[#0F172A] mb-2">
                                    Kata Sandi Baru
                                </label>
                                <input
                                    id="password"
                                    name="password"
                                    type="password"
                                    required
                                    autofocus
                                    minlength="8"
                                    placeholder="Minimal 8 karakter"
                                    class="w-full rounded-[13px] border border-[#E2E8F0] bg-[#F8FAFC] py-3 px-4 text-[14px] text-[#0F172A] placeholder:text-[#94A3B8] focus:border-[#0052CC] focus:bg-white focus:ring-3 focus:ring-[#0052CC]/12 focus:outline-none transition"
                                >
                            </div>

                            <div>
                                <label for="password_confirmation" class="block text-[13.5px] font-bold text-[#0F172A] mb-2">
                                    Konfirmasi Kata Sandi Baru
                                </label>
                                <input
                                    id="password_confirmation"
                                    name="password_confirmation"
                                    type="password"
                                    required
                                    minlength="8"
                                    placeholder="Ulangi kata sandi baru"
                                    class="w-full rounded-[13px] border border-[#E2E8F0] bg-[#F8FAFC] py-3 px-4 text-[14px] text-[#0F172A] placeholder:text-[#94A3B8] focus:border-[#0052CC] focus:bg-white focus:ring-3 focus:ring-[#0052CC]/12 focus:outline-none transition"
                                >
                            </div>

                            <div class="pt-1">
                                <button
                                    type="submit"
                                    class="w-full rounded-[14px] bg-[#0052CC] hover:bg-[#0043A8] active:scale-[0.995] py-3.5 px-5 text-[15px] font-bold text-white shadow-[0_6px_18px_rgba(0,82,204,0.24)] inline-flex items-center justify-center gap-2 transition cursor-pointer"
                                >
                                    <span>Simpan Kata Sandi Baru</span>
                                </button>
                            </div>
                        </form>
                    @endif
                </div>
            </div>
        </main>

        <footer class="w-full max-w-[420px] mx-auto text-center pt-4">
            <div class="border-t border-[#E2E8F0] pt-3.5 pb-1 flex items-center justify-center gap-2.5 text-[12px] text-[#64748B]">
                <svg class="w-[18px] h-[18px] text-[#10B981] shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                    <path d="m9 12 2 2 4-4" />
                </svg>
                <span>Pemulihan Akun Terenkripsi &bull; Sistem PMB Microcredential</span>
            </div>
        </footer>
    </div>
</x-layouts.app>
