<x-layouts.app title="Masuk — Sistem PMB Microcredential Polibatam">
    <div class="min-h-screen flex flex-col justify-between bg-gradient-to-b from-[#F4F8FF] via-[#FAFCFF] to-[#FFFFFF] px-4 py-5 sm:px-6 sm:py-6">
        <!-- Top Right Help Button -->
        <div class="w-full max-w-5xl mx-auto flex justify-end">
            <button
                type="button"
                onclick="openModal('helpModal')"
                class="inline-flex items-center gap-2 rounded-full border border-[#C8DCFF] bg-[#F3F8FF] px-4 py-2 text-[13px] font-bold text-[#0052CC] shadow-[0_2px_10px_rgba(0,82,204,0.06)] hover:bg-[#E7F0FF] transition cursor-pointer"
            >
                <svg class="w-4 h-4 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="9.5" />
                    <path d="M9.4 9.3a2.7 2.7 0 0 1 5.1 1c0 1.8-2.5 2.2-2.5 3.6" />
                    <circle cx="12" cy="17.2" r="0.6" fill="currentColor" />
                </svg>
                <span>Pusat Bantuan &amp; Info</span>
            </button>
        </div>

        <!-- Center Login Content -->
        <main class="w-full flex flex-col items-center justify-center my-auto py-6">
            <div class="w-full max-w-[410px] text-center">
                <!-- Logo Container -->
                <div class="w-16 h-16 rounded-2xl bg-white shadow-[0_2px_14px_rgba(15,23,42,0.04)] flex items-center justify-center mx-auto">
                    <x-mp-logo class="w-12 h-7" />
                </div>

                <!-- Official Portal Badge -->
                <div class="mt-3.5">
                    <span class="inline-block rounded-full bg-[#CCFBF1] px-4 py-1 text-[11px] font-extrabold tracking-[0.06em] text-[#059669] uppercase">
                        PORTAL ADMISI RESMI
                    </span>
                </div>

                <!-- Main Heading & Subtitle -->
                <h1 class="mt-3 text-[25px] sm:text-[28px] font-extrabold tracking-[-0.025em] text-[#0F172A] leading-tight">
                    Sistem PMB Microcredential
                </h1>
                <p class="mt-2 text-[13.5px] text-[#64748B] leading-[1.6] max-w-[360px] mx-auto">
                    Gerbang pendaftaran, verifikasi seleksi, dan validasi berkas akademik terintegrasi
                </p>

                <!-- Login Card -->
                <div class="mt-6 w-full rounded-[22px] border border-[#E3ECFB] bg-white p-6 sm:p-7 text-left shadow-[0_10px_35px_rgba(15,35,95,0.045)]">
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

                    <form method="POST" action="{{ route('login.attempt') }}" class="space-y-4">
                        @csrf

                        <!-- Email Akun -->
                        <div>
                            <div class="flex items-center justify-between mb-2">
                                <label for="email" class="text-[13.5px] font-bold text-[#0F172A]">
                                    Email Akun
                                </label>
                                <span class="text-[12px] font-medium text-[#64748B]">
                                    SSO / Terdaftar
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
                                    value="{{ old('email') }}"
                                    required
                                    autofocus
                                    autocomplete="email"
                                    placeholder="nama@gmail.com"
                                    class="w-full rounded-[13px] border {{ $errors->has('email') ? 'border-red-300 bg-red-50/30' : 'border-[#E2E8F0] bg-[#F8FAFC]' }} py-3 pl-11 pr-4 text-[14px] text-[#0F172A] placeholder:text-[#94A3B8] focus:border-[#0052CC] focus:bg-white focus:ring-3 focus:ring-[#0052CC]/12 focus:outline-none transition"
                                >
                            </div>
                        </div>

                        <!-- Kata Sandi -->
                        <div class="pt-0.5">
                            <div class="flex items-center justify-between mb-2">
                                <label for="password" class="text-[13.5px] font-bold text-[#0F172A]">
                                    Kata Sandi
                                </label>
                                <button
                                    type="button"
                                    onclick="openModal('forgotPasswordModal')"
                                    class="text-[12.5px] font-bold text-[#0052CC] hover:text-[#003E9C] hover:underline cursor-pointer"
                                >
                                    Lupa kata sandi?
                                </button>
                            </div>
                            <div class="relative">
                                <span class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4 text-[#64748B]">
                                    <svg class="w-[18px] h-[18px]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round">
                                        <rect x="4" y="11" width="16" height="10" rx="2.5" />
                                        <path d="M8 11V7a4 4 0 0 1 8 0v4" />
                                    </svg>
                                </span>
                                <input
                                    id="password"
                                    name="password"
                                    type="password"
                                    required
                                    autocomplete="current-password"
                                    placeholder="••••••••••••"
                                    class="w-full rounded-[13px] border border-[#E2E8F0] bg-[#F8FAFC] py-3 pl-11 pr-11 text-[14px] text-[#0F172A] placeholder:text-[#94A3B8] placeholder:tracking-widest focus:border-[#0052CC] focus:bg-white focus:ring-3 focus:ring-[#0052CC]/12 focus:outline-none transition"
                                >
                                <button
                                    type="button"
                                    onclick="togglePasswordVisibility()"
                                    aria-label="Tampilkan atau sembunyikan kata sandi"
                                    class="absolute inset-y-0 right-0 flex items-center pr-4 text-[#64748B] hover:text-[#0F172A] transition cursor-pointer"
                                >
                                    <!-- Eye Off Icon (Default) -->
                                    <svg id="eyeOffIcon" class="w-[18px] h-[18px]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94" />
                                        <path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19" />
                                        <path d="M14.12 14.12a3 3 0 1 1-4.24-4.24" />
                                        <line x1="2" y1="2" x2="22" y2="22" />
                                    </svg>
                                    <!-- Eye Icon (When visible) -->
                                    <svg id="eyeOnIcon" class="w-[18px] h-[18px] hidden" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z" />
                                        <circle cx="12" cy="12" r="3" />
                                    </svg>
                                </button>
                            </div>
                        </div>

                        <!-- Remember Session & JWT Secure Token Badge -->
                        <div class="flex items-center justify-between gap-2 pt-1">
                            <label class="inline-flex items-center gap-2.5 cursor-pointer select-none">
                                <input
                                    type="checkbox"
                                    name="remember"
                                    value="1"
                                    {{ old('email') !== null ? (old('remember') ? 'checked' : '') : 'checked' }}
                                    class="peer sr-only"
                                >
                                <span class="w-[20px] h-[20px] rounded-[6px] border-2 border-[#CBD5E1] bg-white peer-checked:bg-[#0052CC] peer-checked:border-[#0052CC] flex items-center justify-center transition shadow-2xs">
                                    <svg class="w-3 h-3 text-white" viewBox="0 0 14 14" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round">
                                        <polyline points="2.5 7.5 5.5 10.5 11.5 3.5" />
                                    </svg>
                                </span>
                                <span class="text-[13px] font-medium text-[#334155]">
                                    Ingat sesi saya
                                </span>
                            </label>

                            <span class="inline-flex items-center gap-1.5 rounded-[8px] bg-[#D1FAE5]/85 px-2.5 py-1.5 text-[11.5px] font-bold text-[#059669]">
                                <svg class="w-3.5 h-3.5 shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
                                    <path d="m9 12 2 2 4-4" />
                                </svg>
                                <span>JWT Secure Token</span>
                            </span>
                        </div>

                        <!-- Submit Button -->
                        <div class="pt-1.5">
                            <button
                                type="submit"
                                class="w-full rounded-[14px] bg-[#0052CC] hover:bg-[#0043A8] active:scale-[0.995] py-3.5 px-5 text-[15px] font-bold text-white shadow-[0_6px_18px_rgba(0,82,204,0.24)] inline-flex items-center justify-center gap-2.5 transition cursor-pointer"
                            >
                                <svg class="w-[19px] h-[19px]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M14 8V6a2 2 0 0 0-2-2H6a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2v-2" />
                                    <path d="M20 12H9" />
                                    <path d="m13 8-4 4 4 4" />
                                </svg>
                                <span>Masuk</span>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>

        <!-- Footer Info -->
        <footer class="w-full max-w-[420px] mx-auto text-center pt-4">
            <p class="text-[13.5px] text-[#64748B] leading-relaxed">
                Belum punya akun?
                <a
                    href="https://registrasi.polibatam.ac.id"
                    target="_blank"
                    rel="noopener noreferrer"
                    class="font-bold text-[#0052CC] hover:text-[#003E9C] hover:underline"
                >
                    Silakan mendaftar via Website Resmi PMB.
                </a>
            </p>

            <div class="mt-4 border-t border-[#E2E8F0] pt-3.5 pb-1 flex items-center justify-center gap-2.5 text-[12px] text-[#64748B]">
                <svg class="w-[18px] h-[18px] text-[#10B981] shrink-0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M3 18v-6a9 9 0 0 1 18 0v6" />
                    <path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3zM3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z" />
                </svg>
                <span class="leading-snug">
                    Jam operasional: Senin – Jumat (08.00 – 17.00 WIB) &bull; Layanan WhatsApp Terpadu
                </span>
            </div>
        </footer>
    </div>

    <!-- Modal: Pusat Bantuan & Info (Connected to contact_persons table) -->
    <div
        id="helpModal"
        class="fixed inset-0 z-50 hidden items-center justify-center bg-slate-900/45 backdrop-blur-xs p-4"
        onclick="if (event.target === this) closeModal('helpModal')"
    >
        <div class="w-full max-w-md rounded-[22px] bg-white border border-[#E3ECFB] p-6 shadow-2xl">
            <div class="flex items-start justify-between gap-3 mb-4">
                <div>
                    <span class="inline-block rounded-full bg-[#CCFBF1] px-3 py-0.5 text-[10.5px] font-extrabold tracking-wider text-[#059669] uppercase">
                        Layanan Terpadu
                    </span>
                    <h2 class="mt-1.5 text-lg font-extrabold text-[#0F172A]">
                        Pusat Bantuan &amp; Informasi PMB
                    </h2>
                    <p class="text-[12.5px] text-[#64748B] mt-0.5">
                        Senin – Jumat (08.00 – 17.00 WIB)
                    </p>
                </div>
                <button
                    type="button"
                    onclick="closeModal('helpModal')"
                    class="rounded-full p-1.5 text-[#64748B] hover:bg-slate-100 hover:text-[#0F172A] transition cursor-pointer"
                >
                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="6" x2="6" y2="18" />
                        <line x1="6" y1="6" x2="18" y2="18" />
                    </svg>
                </button>
            </div>

            <div class="space-y-3">
                @forelse ($contactPersons as $cp)
                    <div class="rounded-[14px] border border-[#E2E8F0] bg-[#F8FAFC] p-4 flex items-center justify-between gap-3">
                        <div>
                            <p class="text-[13.5px] font-bold text-[#0F172A]">{{ $cp->name }}</p>
                            <p class="text-[12px] text-[#64748B] mt-0.5">{{ $cp->email }}</p>
                            <p class="text-[12px] font-semibold text-[#0052CC] mt-1">{{ $cp->phone }}</p>
                        </div>
                        <a
                            href="{{ $cp->whatsappUrl() }}"
                            target="_blank"
                            rel="noopener noreferrer"
                            class="shrink-0 rounded-xl bg-[#10B981] hover:bg-[#059669] px-3.5 py-2 text-[12px] font-bold text-white transition"
                        >
                            Chat WA
                        </a>
                    </div>
                @empty
                    <p class="text-[13px] text-[#64748B] py-2">
                        Silakan hubungi layanan akademik Politeknik Negeri Batam pada jam operasional.
                    </p>
                @endforelse
            </div>

            <div class="mt-5 flex justify-end">
                <button
                    type="button"
                    onclick="closeModal('helpModal')"
                    class="rounded-xl bg-[#F1F5F9] hover:bg-[#E2E8F0] px-4 py-2 text-[13px] font-bold text-[#334155] transition cursor-pointer"
                >
                    Tutup
                </button>
            </div>
        </div>
    </div>

    <!-- Modal: Lupa Kata Sandi -->
    <div
        id="forgotPasswordModal"
        class="fixed inset-0 z-50 hidden items-center justify-center bg-slate-900/45 backdrop-blur-xs p-4"
        onclick="if (event.target === this) closeModal('forgotPasswordModal')"
    >
        <div class="w-full max-w-md rounded-[22px] bg-white border border-[#E3ECFB] p-6 shadow-2xl">
            <h2 class="text-lg font-extrabold text-[#0F172A]">Pemulihan Kata Sandi</h2>
            <p class="mt-2 text-[13.5px] text-[#64748B] leading-relaxed">
                Untuk pengaturan ulang kata sandi akun SSO atau akun pendaftar PMB Microcredential, silakan hubungi
                <strong class="text-[#0F172A]">Admin Akademik PMB</strong> melalui Pusat Bantuan WhatsApp resmi dengan menyertakan email terdaftar Anda.
            </p>
            <div class="mt-5 flex items-center justify-end gap-2.5">
                <button
                    type="button"
                    onclick="closeModal('forgotPasswordModal')"
                    class="rounded-xl bg-[#F1F5F9] hover:bg-[#E2E8F0] px-4 py-2 text-[13px] font-bold text-[#334155] transition cursor-pointer"
                >
                    Batal
                </button>
                <button
                    type="button"
                    onclick="closeModal('forgotPasswordModal'); openModal('helpModal');"
                    class="rounded-xl bg-[#0052CC] hover:bg-[#0043A8] px-4 py-2 text-[13px] font-bold text-white transition cursor-pointer"
                >
                    Hubungi Admin
                </button>
            </div>
        </div>
    </div>

    <script>
        function togglePasswordVisibility() {
            const passwordInput = document.getElementById('password');
            const eyeOffIcon = document.getElementById('eyeOffIcon');
            const eyeOnIcon = document.getElementById('eyeOnIcon');

            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                eyeOffIcon.classList.add('hidden');
                eyeOnIcon.classList.remove('hidden');
            } else {
                passwordInput.type = 'password';
                eyeOffIcon.classList.remove('hidden');
                eyeOnIcon.classList.add('hidden');
            }
        }

        function openModal(id) {
            const modal = document.getElementById(id);
            if (modal) {
                modal.classList.remove('hidden');
                modal.classList.add('flex');
            }
        }

        function closeModal(id) {
            const modal = document.getElementById(id);
            if (modal) {
                modal.classList.add('hidden');
                modal.classList.remove('flex');
            }
        }
    </script>
</x-layouts.app>

