<x-layouts.app title="Verifikasi Pembayaran — Staf Keuangan PMB Polibatam">
    @php
        $reg = $payment->registration;
    @endphp

    <div class="min-h-screen bg-[#EEF2FA] flex justify-center">
        <div class="w-full max-w-[430px] min-h-screen bg-[#FBF8FF] flex flex-col justify-between pb-28 relative shadow-[0_0_40px_rgba(15,23,42,0.06)]">
            <!-- Header (Frame 405:14) -->
            <header class="sticky top-0 z-30 bg-[#FBF8FF]/95 backdrop-blur-md border-b border-[#EAE8F5] px-4 h-16 flex items-center justify-between">
                <div class="flex items-center gap-2.5">
                    <a
                        href="{{ route('keuangan.dashboard') }}"
                        class="w-9 h-9 rounded-full flex items-center justify-center text-[#161A30] hover:bg-[#ECECFF] transition"
                    >
                        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="19" y1="12" x2="5" y2="12" />
                            <polyline points="12 19 5 12 12 5" />
                        </svg>
                    </a>
                    <h1 class="text-[15.5px] font-extrabold text-[#161A30]">Verifikasi Pembayaran</h1>
                </div>
                <a href="{{ route('keuangan.profil') }}" class="w-9 h-9 rounded-full bg-[#003BA5] text-white flex items-center justify-center">
                    <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                        <circle cx="12" cy="7" r="4" />
                    </svg>
                </a>
            </header>

            <form method="POST" action="{{ route('keuangan.payments.verify', $payment->payment_id) }}">
                @csrf
                <input type="hidden" name="action_type" id="paymentActionType" value="confirm_lunas">

                <main class="px-4 pt-4 space-y-4">
                    @if ($errors->any())
                        <div class="rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-[12.5px] font-semibold text-red-700">
                            {{ $errors->first() }}
                        </div>
                    @endif

                    <!-- Meta Info Bar -->
                    <div class="space-y-1.5">
                        <div class="flex items-center gap-2">
                            <span class="rounded-full bg-[#DCE9FF] px-3 py-1 text-[11px] font-extrabold text-[#003BA5]">
                                {{ $reg?->track?->department_name ?? 'Informatika' }}
                            </span>
                            <span class="rounded-full bg-[#ECECFF] px-3 py-1 text-[11px] font-bold text-[#161A30]">
                                {{ $reg?->registrationCode() ?? ('PMB-MC-26-' . $payment->registration_id) }}
                            </span>
                        </div>
                        <span class="inline-block rounded-full bg-[#FEF3C7] px-3 py-0.5 text-[10.5px] font-extrabold text-[#B45309] uppercase">
                            🕒 {{ strtoupper($payment->status_pembayaran) }}
                        </span>
                    </div>

                    <!-- Applicant & Billing Summary Card -->
                    <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)] space-y-3.5">
                        <div class="flex items-center gap-3">
                            <div class="w-11 h-11 rounded-xl bg-[#E8F0FE] text-[#003BA5] flex items-center justify-center font-bold">
                                🎓
                            </div>
                            <div>
                                <h2 class="text-[16px] font-extrabold text-[#161A30]">{{ $reg?->full_name ?? 'Calon Mahasiswa' }}</h2>
                                <p class="text-[11.5px] text-[#64748B]">Calon Mahasiswa Baru &bull; {{ $reg?->track?->track_name ?? 'Jalur Microcredential' }}</p>
                            </div>
                        </div>

                        <div class="rounded-xl bg-[#F4F2FF] p-3.5">
                            <p class="text-[10.5px] font-extrabold tracking-wider text-[#434655] uppercase">NOMINAL TAGIHAN ADMISI</p>
                            <div class="mt-1 flex items-center gap-2">
                                <span class="text-[24px] font-extrabold text-[#003BA5]">
                                    Rp {{ number_format((float) $payment->amount, 0, ',', '.') }}
                                </span>
                                <span class="rounded-md bg-[#D1FAE5] px-2 py-0.5 text-[10.5px] font-extrabold text-[#059669]">
                                    Tepat
                                </span>
                            </div>
                            <p class="text-[11px] text-[#64748B] mt-0.5">Biaya Registrasi Jalur Microcredential</p>
                        </div>

                        <div class="space-y-2 text-[12px]">
                            <div class="flex justify-between">
                                <span class="text-[#64748B]">Metode Pembayaran</span>
                                <span class="font-extrabold text-[#161A30]">BNI &bull; {{ $payment->rekening?->bank_name ?? 'Rekening BNI' }}</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-[#64748B]">No. Rekening</span>
                                <span class="font-extrabold text-[#161A30]">{{ $payment->rekening?->account_number ?? '1003301245' }}</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-[#64748B]">Waktu Transaksi</span>
                                <span class="font-extrabold text-[#161A30]">{{ $payment->payment_date?->format('d M Y, H:i') ?? '-' }} WIB</span>
                            </div>
                        </div>
                    </div>

                    <!-- Bukti Transfer / Struk Card -->
                    <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)] space-y-3">
                        <div class="flex items-center justify-between">
                            <h3 class="text-[14.5px] font-extrabold text-[#161A30]">🧾 Bukti Transfer / Struk</h3>
                            <span class="rounded-full bg-[#D1FAE5] px-2.5 py-0.5 text-[10.5px] font-extrabold text-[#059669]">
                                &#10003; Format Valid
                            </span>
                        </div>

                        <div class="rounded-xl bg-[#F4F2FF] px-3.5 py-2 flex items-center justify-between text-[12px]">
                            <span class="font-bold text-[#161A30] truncate">🖼️ {{ basename($payment->proof_file_path) }}</span>
                            <span class="text-[#64748B] shrink-0 ml-2">Resi BNI</span>
                        </div>

                        <div class="rounded-2xl border-2 border-dashed border-[#DCE6F7] bg-[#F8FAFF] p-5 text-center">
                            @if (file_exists(public_path($payment->proof_file_path)))
                                <img
                                    src="{{ asset($payment->proof_file_path) }}"
                                    alt="Bukti Transfer"
                                    class="max-h-56 mx-auto rounded-xl object-contain mb-3 shadow-xs"
                                >
                                <a
                                    href="{{ asset($payment->proof_file_path) }}"
                                    target="_blank"
                                    class="inline-block rounded-xl bg-[#EBF1FF] px-4 py-2 text-[12px] font-extrabold text-[#003BA5]"
                                >
                                    🔍 Buka Ukuran Penuh
                                </a>
                            @else
                                <div class="w-12 h-12 rounded-full bg-[#DCE9FF] text-[#003BA5] flex items-center justify-center mx-auto mb-2 text-lg">
                                    🖼️
                                </div>
                                <p class="text-[13px] font-extrabold text-[#161A30]">Pratinjau Foto Struk Pembayaran</p>
                                <p class="text-[11.5px] text-[#64748B] mt-0.5">{{ basename($payment->proof_file_path) }} &bull; Arsip Database</p>
                            @endif
                        </div>
                    </div>

                    <!-- Catatan Keuangan Card -->
                    <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)] space-y-2.5">
                        <h3 class="text-[14px] font-extrabold text-[#161A30]">
                            📝 Catatan Keuangan <span class="font-normal text-[#64748B] text-[12px]">(Opsional)</span>
                        </h3>
                        <p class="text-[11.5px] text-[#64748B]">
                            Catatan ini akan langsung dikirimkan ke aplikasi calon mahasiswa jika butuh revisi.
                        </p>

                        <!-- Quick-Fill Chips -->
                        <div class="flex flex-wrap gap-1.5">
                            <button
                                type="button"
                                onclick="appendFinanceNote('Nominal transfer kurang dari tarif registrasi Rp 200.000.')"
                                class="rounded-full bg-[#ECECFF] hover:bg-[#DCE2FF] px-2.5 py-1 text-[11px] font-bold text-[#161A30] cursor-pointer"
                            >
                                + Nominal Kurang
                            </button>
                            <button
                                type="button"
                                onclick="appendFinanceNote('Foto struk transfer buram dan nomor referensi tidak terbaca.')"
                                class="rounded-full bg-[#ECECFF] hover:bg-[#DCE2FF] px-2.5 py-1 text-[11px] font-bold text-[#161A30] cursor-pointer"
                            >
                                + Struk Buram
                            </button>
                            <button
                                type="button"
                                onclick="appendFinanceNote('Nomor referensi transfer tidak valid pada mutasi rekening BNI.')"
                                class="rounded-full bg-[#ECECFF] hover:bg-[#DCE2FF] px-2.5 py-1 text-[11px] font-bold text-[#161A30] cursor-pointer"
                            >
                                + Ref Tidak Valid
                            </button>
                        </div>

                        <textarea
                            id="financeNotesInput"
                            name="finance_notes"
                            rows="3"
                            placeholder="Contoh: Nominal kurang / Struk tidak terbaca / Nama pengirim berbeda..."
                            class="w-full rounded-xl bg-[#F4F2FF] border border-transparent focus:border-[#003BA5] focus:bg-white p-3 text-[12.5px] text-[#161A30] placeholder:text-[#94A3B8] focus:outline-none transition"
                        >{{ old('finance_notes', $payment->finance_notes) }}</textarea>
                    </div>
                </main>

                <!-- Sticky Bottom 2 Action Buttons (Frame 405:14) -->
                <div class="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-[430px] bg-white border-t border-[#E6E8F2] px-4 py-3 z-40 grid grid-cols-2 gap-2.5">
                    <button
                        type="submit"
                        onclick="document.getElementById('paymentActionType').value = 'reject_payment';"
                        class="rounded-xl bg-[#FFE4E6] hover:bg-[#FECDD3] py-3.5 text-[13.5px] font-extrabold text-[#BE123C] flex items-center justify-center gap-1.5 transition cursor-pointer"
                    >
                        <span>&#10005; Tolak / Revisi</span>
                    </button>

                    <button
                        type="submit"
                        onclick="document.getElementById('paymentActionType').value = 'confirm_lunas';"
                        class="rounded-xl bg-[#059669] hover:bg-[#047857] py-3.5 text-[13.5px] font-extrabold text-white flex items-center justify-center gap-1.5 shadow-sm transition cursor-pointer"
                    >
                        <span>&#10003; Konfirmasi Lunas</span>
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function appendFinanceNote(text) {
            const area = document.getElementById('financeNotesInput');
            if (area) {
                area.value = text;
                area.focus();
            }
        }
    </script>
</x-layouts.app>
