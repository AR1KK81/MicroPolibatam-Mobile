<x-layouts.app title="Daftar Akun Maba — Sistem PMB Microcredential Polibatam">
    <div class="min-h-screen flex flex-col justify-between bg-[#F9FBFF]">
        <!-- Top App Bar -->
        <header class="w-full max-w-[460px] mx-auto px-4 pt-4 pb-2 flex items-center justify-between">
            <div class="flex items-center gap-3">
                <a
                    href="{{ route('login') }}"
                    aria-label="Kembali ke halaman login"
                    class="w-9 h-9 rounded-full flex items-center justify-center text-[#0045AD] hover:bg-[#EBF2FF] transition"
                >
                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="19" y1="12" x2="5" y2="12" />
                        <polyline points="12 19 5 12 12 5" />
                    </svg>
                </a>
                <div class="leading-none">
                    <p class="text-[15px] font-extrabold text-[#0A4DA6] tracking-tight">PMB Micro</p>
                    <p class="text-[11.5px] font-bold text-[#334155] mt-0.5">Polibatam</p>
                </div>
            </div>

            <a
                href="{{ route('login') }}"
                title="Halaman Masuk Akun"
                class="w-10 h-10 rounded-full bg-[#0A3D91] hover:bg-[#002F7A] text-white flex items-center justify-center shadow-[0_4px_12px_rgba(10,61,145,0.22)] transition"
            >
                <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                    <circle cx="12" cy="7" r="4" />
                </svg>
            </a>
        </header>

        <!-- Main Content Container -->
        <main class="w-full max-w-[420px] mx-auto px-4 pt-3 pb-6">
            <!-- Hero Header -->
            <div class="text-center mb-5">
                <div class="w-3.5 h-3.5 rounded-full bg-white shadow-xs mx-auto mb-2"></div>
                <h1 class="text-[28px] sm:text-[30px] font-extrabold tracking-[-0.025em] text-[#0F172A] leading-tight">
                    Daftar Akun Maba
                </h1>
                <p class="mt-2 text-[13.5px] text-[#64748B] leading-[1.6] max-w-[330px] mx-auto">
                    Masukkan email Gmail kamu untuk menerima kode verifikasi OTP langsung ke inbox
                </p>
            </div>

            @if (session('status'))
                <div class="mb-4 rounded-[15px] border border-emerald-200 bg-emerald-50/90 px-4 py-3 text-[13px] text-emerald-800 flex items-start gap-2.5">
                    <svg class="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                        <polyline points="22 4 12 14.01 9 11.01" />
                    </svg>
                    <span>{{ session('status') }}</span>
                </div>
            @endif

            @if ($errors->any())
                <div class="mb-4 rounded-[15px] border border-red-200 bg-red-50/90 px-4 py-3 text-[13px] text-red-700 flex items-start gap-2.5">
                    <svg class="w-4 h-4 text-red-600 shrink-0 mt-0.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10" />
                        <line x1="12" y1="8" x2="12" y2="12" />
                        <line x1="12" y1="16" x2="12.01" y2="16" />
                    </svg>
                    <span>{{ $errors->first() }}</span>
                </div>
            @endif

            <!-- CARD 1: LANGKAH 1 DARI 2 (Input Akun) -->
            <div class="rounded-[22px] border border-[#E6EEFA] bg-white p-5 sm:p-6 shadow-[0_8px_28px_rgba(15,35,95,0.04)]">
                <div class="flex items-center justify-between mb-4">
                    <span class="inline-block rounded-full bg-[#DCE9FF] px-3 py-1 text-[10.5px] font-extrabold tracking-[0.04em] text-[#0052CC] uppercase">
                        LANGKAH 1 DARI 2
                    </span>
                    <span class="inline-flex items-center gap-1.5 text-[12px] font-bold text-[#334155]">
                        <span class="w-2 h-2 rounded-full bg-[#0052CC]"></span>
                        <span>Input Akun</span>
                    </span>
                </div>

                <form method="POST" action="{{ route('register.otp.send') }}" class="space-y-3.5">
                    @csrf

                    <!-- Alamat Gmail / Email Aktif -->
                    <div>
                        <div class="flex items-center justify-between mb-2">
                            <label for="registerEmail" class="text-[13.5px] font-bold text-[#0F172A]">
                                Alamat Gmail / Email Aktif
                            </label>
                            <span class="rounded-full bg-[#E8F0FE] px-2.5 py-0.5 text-[10.5px] font-bold text-[#0052CC]">
                                Wajib Aktif
                            </span>
                        </div>
                        <div class="relative">
                            <span class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4 text-[#64748B]">
                                <svg class="w-[18px] h-[18px]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="2" y="4" width="20" height="16" rx="2.5" />
                                    <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7" />
                                </svg>
                            </span>
                            <input
                                id="registerEmail"
                                name="email"
                                type="email"
                                value="{{ old('email', $pendingEmail) }}"
                                required
                                placeholder="nama.maba@gmail.com"
                                class="w-full rounded-[13px] border border-[#E2E8F0] bg-[#FAFBFD] py-3 pl-11 pr-4 text-[14px] text-[#0F172A] placeholder:text-[#94A3B8] focus:border-[#0052CC] focus:bg-white focus:ring-3 focus:ring-[#0052CC]/12 focus:outline-none transition"
                            >
                        </div>
                    </div>

                    <!-- Buat Kata Sandi Akun -->
                    <div>
                        <div class="flex items-center justify-between mb-1.5">
                            <label for="registerPassword" class="text-[13px] font-bold text-[#0F172A]">
                                Buat Kata Sandi Akun
                            </label>
                            <span class="text-[11px] font-medium text-[#64748B]">
                                Min. 6 karakter
                            </span>
                        </div>
                        <div class="relative">
                            <span class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4 text-[#64748B]">
                                <svg class="w-[17px] h-[17px]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="4" y="11" width="16" height="10" rx="2.5" />
                                    <path d="M8 11V7a4 4 0 0 1 8 0v4" />
                                </svg>
                            </span>
                            <input
                                id="registerPassword"
                                name="password"
                                type="password"
                                required
                                minlength="6"
                                placeholder="Buat kata sandi untuk login"
                                class="w-full rounded-[13px] border border-[#E2E8F0] bg-[#FAFBFD] py-2.5 pl-11 pr-10 text-[13.5px] text-[#0F172A] placeholder:text-[#94A3B8] focus:border-[#0052CC] focus:bg-white focus:ring-3 focus:ring-[#0052CC]/12 focus:outline-none transition"
                            >
                            <button
                                type="button"
                                onclick="toggleRegisterPassword()"
                                aria-label="Tampilkan kata sandi"
                                class="absolute inset-y-0 right-0 flex items-center pr-3.5 text-[#64748B] hover:text-[#0F172A] cursor-pointer"
                            >
                                <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                                    <circle cx="12" cy="12" r="3" />
                                </svg>
                            </button>
                        </div>
                    </div>

                    <!-- Helper Info -->
                    <div class="flex items-start gap-2 pt-0.5 text-[12px] text-[#64748B]">
                        <svg class="w-4 h-4 text-[#0052CC] shrink-0 mt-0.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="12" cy="12" r="10" />
                            <line x1="12" y1="16" x2="12" y2="12" />
                            <line x1="12" y1="8" x2="12.01" y2="8" />
                        </svg>
                        <span class="leading-snug">
                            Gunakan alamat email pribadi yang aktif di smartphone kamu
                        </span>
                    </div>

                    <!-- Button: Kirim Kode Verifikasi -->
                    <div class="pt-1">
                        <button
                            type="submit"
                            class="w-full rounded-[14px] bg-[#0052CC] hover:bg-[#0043A8] active:scale-[0.995] py-3.5 px-5 text-[14.5px] font-bold text-white shadow-[0_6px_18px_rgba(0,82,204,0.22)] inline-flex items-center justify-center gap-2 transition cursor-pointer"
                        >
                            <svg class="w-4 h-4 -rotate-12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                                <line x1="22" y1="2" x2="11" y2="13" />
                                <polygon points="22 2 15 22 11 13 2 9 22 2" />
                            </svg>
                            <span>Kirim Kode Verifikasi</span>
                        </button>
                    </div>
                </form>
            </div>

            <!-- CARD 2: LANGKAH 2 DARI 2 (KEAMANAN OTP) -->
            <form method="POST" action="{{ route('register.otp.verify') }}" id="otpVerifyForm" class="mt-4">
                @csrf
                <input type="hidden" name="otp" id="combinedOtpInput" value="">

                <div class="rounded-[22px] border border-[#E6EEFA] bg-white p-5 sm:p-6 shadow-[0_8px_28px_rgba(15,35,95,0.04)]">
                    <div class="flex items-center justify-between mb-4">
                        <span class="inline-block rounded-full bg-[#EBEEF5] px-3 py-1 text-[10.5px] font-extrabold tracking-[0.04em] text-[#475569] uppercase">
                            LANGKAH 2 DARI 2
                        </span>
                        <span class="inline-block rounded-full bg-[#F1F5FB] px-3 py-1 text-[10px] font-extrabold tracking-[0.05em] text-[#94A3B8] uppercase">
                            KEAMANAN OTP
                        </span>
                    </div>

                    <!-- Sent Destination Banner -->
                    <div class="rounded-[15px] bg-[#EBF3FF] px-4 py-3 flex items-center justify-between gap-2 mb-4">
                        <div class="flex items-start gap-2.5">
                            <span class="w-5 h-5 rounded-full bg-[#0045AD] text-white flex items-center justify-center shrink-0 mt-0.5">
                                <svg class="w-3 h-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                                    <polyline points="20 6 9 17 4 12" />
                                </svg>
                            </span>
                            <p class="text-[12.5px] text-[#475569] leading-snug">
                                Kode 6 digit telah dikirim ke
                                <strong class="text-[#0045AD] font-extrabold break-all">
                                    {{ $pendingEmail !== '' ? $pendingEmail : 'nama.maba@gmail.com' }}
                                </strong>
                            </p>
                        </div>
                        <button
                            type="button"
                            onclick="document.getElementById('registerEmail').focus()"
                            title="Ubah alamat email"
                            class="text-[#0045AD] hover:text-[#002F7A] p-1 shrink-0 cursor-pointer"
                        >
                            <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M17 3a2.85 2.83 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5Z" />
                            </svg>
                        </button>
                    </div>

                    @if (! empty($devOtp))
                        <div class="mb-4 rounded-[13px] border border-blue-200 bg-[#F5F9FF] px-3.5 py-2.5 text-[12px] text-[#1E293B] flex items-center justify-between gap-2">
                            <div>
                                <span class="font-bold text-[#0052CC]">Kode OTP Lokal:</span>
                                <span class="font-mono font-extrabold text-[15px] tracking-widest text-[#0A3D91] ml-1">{{ $devOtp }}</span>
                            </div>
                            <button
                                type="button"
                                onclick="fillOtpDigits('{{ $devOtp }}')"
                                class="rounded-lg bg-[#0052CC] text-white px-2.5 py-1 text-[11px] font-bold hover:bg-[#003E9C] transition cursor-pointer"
                            >
                                Isi Otomatis
                            </button>
                        </div>
                    @endif

                    <!-- 6-Digit OTP Boxes -->
                    <div>
                        <label class="block text-[13.5px] font-bold text-[#0F172A] mb-2.5">
                            Masukkan Kode 6-Digit
                        </label>
                        <div class="grid grid-cols-6 gap-2">
                            @for ($i = 0; $i < 6; $i++)
                                <input
                                    type="text"
                                    name="otp_digits[]"
                                    id="otpDigit{{ $i }}"
                                    maxlength="1"
                                    inputmode="numeric"
                                    pattern="[0-9]"
                                    placeholder="-"
                                    oninput="handleOtpInput(this, {{ $i }})"
                                    onkeydown="handleOtpKeydown(event, {{ $i }})"
                                    onpaste="handleOtpPaste(event)"
                                    class="otp-box h-13 w-full rounded-[13px] border-2 border-transparent bg-[#F1F5FC] text-center text-[20px] font-extrabold text-[#0A3D91] placeholder:text-[#94A3B8] focus:border-[#0052CC] focus:bg-[#DCE9FF]/70 focus:outline-none transition"
                                >
                            @endfor
                        </div>
                    </div>

                    <!-- Resend Row -->
                    <div class="mt-4 flex items-center justify-between text-[12.5px]">
                        <span class="text-[#64748B] font-medium">Belum terima kode?</span>
                        <button
                            type="button"
                            onclick="document.getElementById('resendOtpForm').submit()"
                            class="inline-flex items-center gap-1.5 font-extrabold text-[#0052CC] hover:text-[#003E9C] hover:underline cursor-pointer"
                        >
                            <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10" />
                                <polyline points="12 6 12 12 16 14" />
                            </svg>
                            <span id="resendTimerText">Kirim ulang (0:00)</span>
                        </button>
                    </div>
                </div>

                <!-- Big Primary Action Button: Verifikasi & Masuk -->
                <div class="mt-4">
                    <button
                        type="submit"
                        class="w-full rounded-[16px] bg-[#003E9C] hover:bg-[#002F7A] active:scale-[0.995] py-4 px-6 text-[16px] font-extrabold text-white shadow-[0_8px_22px_rgba(0,62,156,0.28)] inline-flex items-center justify-center gap-2.5 transition cursor-pointer"
                    >
                        <span>Verifikasi &amp; Masuk</span>
                        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="5" y1="12" x2="19" y2="12" />
                            <polyline points="12 5 19 12 12 19" />
                        </svg>
                    </button>

                    <p class="mt-2.5 text-center text-[11.5px] text-[#64748B] leading-relaxed max-w-[330px] mx-auto">
                        Dengan menekan tombol di atas, Anda menyetujui Ketentuan Layanan &amp; Privasi PMB Polibatam
                    </p>
                </div>
            </form>

            <!-- Hidden Resend Form -->
            <form id="resendOtpForm" method="POST" action="{{ route('register.otp.resend') }}" class="hidden">
                @csrf
            </form>

            <!-- Divider: ATAU DAFTAR LANGSUNG -->
            <div class="my-5 flex items-center gap-3">
                <div class="h-px flex-1 bg-[#E2E8F0]"></div>
                <span class="text-[11px] font-bold tracking-[0.06em] text-[#94A3B8] uppercase">
                    ATAU DAFTAR LANGSUNG
                </span>
                <div class="h-px flex-1 bg-[#E2E8F0]"></div>
            </div>

            <!-- Google Button -->
            <button
                type="button"
                onclick="document.getElementById('registerEmail').focus()"
                class="w-full rounded-[15px] border border-[#E8EEF8] bg-white hover:bg-[#F8FAFC] py-3.5 px-5 text-[14px] font-bold text-[#1E293B] shadow-[0_2px_12px_rgba(15,23,42,0.03)] inline-flex items-center justify-center gap-3 transition cursor-pointer"
            >
                <svg class="w-5 h-5" viewBox="0 0 24 24">
                    <path fill="#4285F4" d="M21.8 12.2c0-.7-.1-1.4-.2-2H12v3.8h5.5a4.7 4.7 0 0 1-2 3.1v2.6h3.3c1.9-1.8 3-4.4 3-7.5z" />
                    <path fill="#34A853" d="M12 22c2.7 0 5-.9 6.7-2.4l-3.3-2.6c-.9.6-2.1 1-3.4 1-2.6 0-4.9-1.8-5.7-4.2H2.9v2.6A10 10 0 0 0 12 22z" />
                    <path fill="#FBBC05" d="M6.3 13.8a6 6 0 0 1 0-3.6V7.6H2.9a10 10 0 0 0 0 8.8l3.4-2.6z" />
                    <path fill="#EA4335" d="M12 5.9c1.5 0 2.8.5 3.9 1.5l2.9-2.9A10 10 0 0 0 2.9 7.6l3.4 2.6C7.1 7.7 9.4 5.9 12 5.9z" />
                </svg>
                <span>Lanjutkan dengan Google</span>
            </button>

            <!-- Login Redirect -->
            <p class="mt-5 text-center text-[13.5px] text-[#64748B]">
                Sudah punya akun?
                <a href="{{ route('login') }}" class="font-extrabold text-[#0052CC] hover:text-[#003E9C] hover:underline ml-0.5">
                    Masuk di sini
                </a>
            </p>

            <!-- Operational Hours Pill Card -->
            <div class="mt-4 rounded-2xl bg-[#F2F6FC] px-4 py-3 flex items-center gap-3 text-[11.5px] text-[#64748B]">
                <svg class="w-5 h-5 text-[#475569] shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M3 18v-6a9 9 0 0 1 18 0v6" />
                    <path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3zM3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z" />
                </svg>
                <span class="leading-relaxed">
                    Jam operasional: Senin – Jumat (08.00 – 17.00 WIB) &bull; Layanan Bantuan Terpadu
                </span>
            </div>
        </main>

        <!-- Bottom Footer Block -->
        <footer class="w-full bg-[#F2F6FC] border-t border-[#E6ECF7] py-5 px-4 text-center">
            <p class="text-[13px] font-extrabold text-[#1E293B]">
                Layanan Bantuan &amp; Helpdesk PMB
            </p>
            <p class="mt-1 inline-flex items-center justify-center gap-1.5 text-[11.5px] text-[#64748B]">
                <svg class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10" />
                    <polyline points="12 6 12 12 16 14" />
                </svg>
                <span>Senin - Jumat: 08:00 - 16:00 WIB</span>
            </p>
            <p class="mt-2.5 text-[11px] font-medium text-[#94A3B8] max-w-[320px] mx-auto leading-relaxed">
                &copy; 2026 Microcredential Politeknik Negeri Batam. All Rights Reserved.
            </p>
        </footer>
    </div>

    <script>
        function toggleRegisterPassword() {
            const input = document.getElementById('registerPassword');
            input.type = input.type === 'password' ? 'text' : 'password';
        }

        function syncCombinedOtp() {
            let code = '';
            for (let i = 0; i < 6; i++) {
                const el = document.getElementById('otpDigit' + i);
                if (el) {
                    code += el.value.replace(/\D/g, '');
                }
            }
            const hidden = document.getElementById('combinedOtpInput');
            if (hidden) {
                hidden.value = code;
            }
        }

        function handleOtpInput(el, index) {
            el.value = el.value.replace(/\D/g, '').slice(-1);
            syncCombinedOtp();
            if (el.value !== '' && index < 5) {
                const next = document.getElementById('otpDigit' + (index + 1));
                if (next) {
                    next.focus();
                }
            }
        }

        function handleOtpKeydown(event, index) {
            if (event.key === 'Backspace' && event.target.value === '' && index > 0) {
                const prev = document.getElementById('otpDigit' + (index - 1));
                if (prev) {
                    prev.focus();
                }
            }
        }

        function handleOtpPaste(event) {
            event.preventDefault();
            const pasted = (event.clipboardData || window.clipboardData).getData('text').replace(/\D/g, '').slice(0, 6);
            fillOtpDigits(pasted);
        }

        function fillOtpDigits(code) {
            const clean = String(code).replace(/\D/g, '').slice(0, 6);
            for (let i = 0; i < 6; i++) {
                const el = document.getElementById('otpDigit' + i);
                if (el) {
                    el.value = clean[i] || '';
                }
            }
            syncCombinedOtp();
            const lastIndex = Math.min(clean.length, 5);
            const focusEl = document.getElementById('otpDigit' + lastIndex);
            if (focusEl) {
                focusEl.focus();
            }
        }

        @if ($otpSent)
            window.addEventListener('DOMContentLoaded', function () {
                const firstBox = document.getElementById('otpDigit0');
                if (firstBox) {
                    firstBox.focus();
                }
            });
        @endif
    </script>
</x-layouts.app>
