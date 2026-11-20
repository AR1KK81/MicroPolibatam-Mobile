<x-layouts.app title="Nomor Rekening — Super Admin PMB Polibatam">
    <div class="min-h-screen bg-[#EEF2FA] flex justify-center">
        <div class="w-full max-w-[430px] min-h-screen bg-[#FBF8FF] flex flex-col justify-between pb-24 relative shadow-[0_0_40px_rgba(15,23,42,0.06)]">
            <main class="px-4 pt-5 space-y-4 flex-1">
                @if (session('status'))
                    <div class="rounded-2xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-[12.5px] font-semibold text-emerald-800">
                        {{ session('status') }}
                    </div>
                @endif

                @if ($errors->any())
                    <div class="rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-[12.5px] font-semibold text-red-700">
                        {{ $errors->first() }}
                    </div>
                @endif

                @if ($showForm)
                    <!-- Tambah / Edit Rekening Screen (Image 7 Frame 5) -->
                    <div class="flex items-center justify-between">
                        <div>
                            <h1 class="text-[20px] font-extrabold text-[#161A30]">
                                {{ $editingRekening ? 'Edit Rekening' : 'Tambah Rekening' }}
                            </h1>
                            <p class="text-[12px] text-[#64748B]">Rekening penerima pembayaran</p>
                        </div>
                        <a
                            href="{{ route('super-admin.rekening') }}"
                            class="w-9 h-9 rounded-full bg-white border border-[#E2E8F0] flex items-center justify-center text-[#434655] font-bold"
                        >
                            &#10005;
                        </a>
                    </div>

                    <form method="POST" action="{{ route('super-admin.rekening.save') }}" class="space-y-3.5">
                        @csrf
                        @if ($editingRekening)
                            <input type="hidden" name="rekening_id" value="{{ $editingRekening->rekening_id }}">
                        @endif

                        <div>
                            <label class="block text-[12px] font-bold text-[#64748B] mb-1.5">Nama Bank</label>
                            <select
                                name="bank_name"
                                class="w-full rounded-2xl border border-[#E2E8F0] bg-white px-4 py-3 text-[13.5px] font-bold text-[#161A30] focus:border-[#0052CC] focus:outline-none"
                            >
                                @foreach (['Bank BNI', 'Bank BRI', 'Bank Mandiri', 'Bank BCA', 'Bank BSI'] as $bank)
                                    <option value="{{ $bank }}" {{ old('bank_name', $editingRekening?->bank_name) === $bank ? 'selected' : '' }}>
                                        {{ $bank }}
                                    </option>
                                @endforeach
                            </select>
                        </div>

                        <div>
                            <label class="block text-[12px] font-bold text-[#64748B] mb-1.5">Nomor Rekening</label>
                            <input
                                type="text"
                                name="account_number"
                                required
                                value="{{ old('account_number', $editingRekening?->account_number) }}"
                                placeholder="💳 0238 5419 82"
                                class="w-full rounded-2xl border border-[#E2E8F0] bg-white px-4 py-3 text-[13.5px] font-semibold text-[#161A30] focus:border-[#0052CC] focus:outline-none"
                            >
                        </div>

                        <div>
                            <label class="block text-[12px] font-bold text-[#64748B] mb-1.5">Atas Nama</label>
                            <input
                                type="text"
                                name="account_name"
                                required
                                value="{{ old('account_name', $editingRekening?->account_name ?? 'Politeknik Negeri Batam') }}"
                                placeholder="Politeknik Negeri Batam"
                                class="w-full rounded-2xl border border-[#E2E8F0] bg-white px-4 py-3 text-[13.5px] font-semibold text-[#161A30] focus:border-[#0052CC] focus:outline-none"
                            >
                        </div>

                        <div>
                            <label class="block text-[12px] font-bold text-[#64748B] mb-1.5">Nominal Biaya Pendaftaran (Rp)</label>
                            <input
                                type="number"
                                name="nominal_biaya"
                                required
                                value="{{ old('nominal_biaya', (int) ($editingRekening?->nominal_biaya ?? 200000)) }}"
                                class="w-full rounded-2xl border border-[#E2E8F0] bg-white px-4 py-3 text-[13.5px] font-semibold text-[#161A30] focus:border-[#0052CC] focus:outline-none"
                            >
                        </div>

                        <div class="rounded-2xl border border-[#E2E8F0] bg-white px-4 py-3.5 flex items-center justify-between">
                            <span class="text-[13.5px] font-bold text-[#161A30]">Jadikan rekening utama</span>
                            <input
                                type="checkbox"
                                name="is_active"
                                value="1"
                                {{ old('is_active', $editingRekening?->is_active ?? true) ? 'checked' : '' }}
                                class="w-5 h-5 accent-[#0052CC] rounded"
                            >
                        </div>

                        <div class="rounded-2xl bg-[#F4F6FC] p-3.5 text-[11.5px] text-[#64748B] leading-relaxed">
                            <p class="font-extrabold text-[#0052CC]">Sinkronisasi VA otomatis</p>
                            <p class="mt-0.5">Rekening yang aktif dipakai untuk menampilkan instruksi pembayaran pada formulir pendaftaran Maba.</p>
                        </div>

                        <div class="pt-2 grid {{ $editingRekening ? 'grid-cols-2' : 'grid-cols-1' }} gap-2.5">
                            <button
                                type="submit"
                                class="rounded-full bg-[#0052CC] hover:bg-[#003E9C] py-3.5 text-[13.5px] font-extrabold text-white flex items-center justify-center gap-1.5 shadow-sm cursor-pointer"
                            >
                                <span>&#10003; Simpan</span>
                            </button>

                            @if ($editingRekening)
                                <button
                                    type="button"
                                    onclick="if (confirm('Hapus rekening ini?')) document.getElementById('deleteRekeningForm').submit();"
                                    class="rounded-full border border-red-300 bg-white hover:bg-red-50 py-3.5 text-[13px] font-extrabold text-[#DC2626] flex items-center justify-center gap-1.5 cursor-pointer"
                                >
                                    <span>🗑️ Hapus Rekening</span>
                                </button>
                            @endif
                        </div>
                    </form>

                    @if ($editingRekening)
                        <form id="deleteRekeningForm" method="POST" action="{{ route('super-admin.rekening.delete', $editingRekening->rekening_id) }}" class="hidden">
                            @csrf
                            @method('DELETE')
                        </form>
                    @endif
                @else
                    <!-- Rekening List Screen (Image 7 Frame 4) -->
                    <div class="flex items-start justify-between">
                        <div>
                            <span class="inline-block rounded-full bg-[#DCE9FF] px-2.5 py-0.5 text-[10px] font-extrabold text-[#003BA5] uppercase">
                                🏛️ MASTER DATA
                            </span>
                            <h1 class="mt-1.5 text-[22px] font-extrabold text-[#161A30] leading-tight">Nomor Rekening</h1>
                            <p class="text-[12px] text-[#64748B]">{{ $rekenings->count() }} rekening terdaftar</p>
                        </div>
                        <a
                            href="{{ route('super-admin.rekening', ['create' => 1]) }}"
                            class="w-9 h-9 rounded-full bg-white border border-[#E2E8F0] flex items-center justify-center text-[#161A30] font-bold text-lg shadow-2xs"
                        >
                            +
                        </a>
                    </div>

                    <div>
                        <a
                            href="{{ route('super-admin.rekening', ['create' => 1]) }}"
                            class="inline-flex items-center gap-1.5 rounded-full bg-[#0052CC] hover:bg-[#003E9C] px-4 py-2 text-[12px] font-extrabold text-white shadow-xs transition"
                        >
                            <span>+ Tambah Rekening</span>
                        </a>
                    </div>

                    <!-- Search -->
                    <form method="GET" action="{{ route('super-admin.rekening') }}">
                        <input
                            type="text"
                            name="q"
                            value="{{ $search }}"
                            placeholder="🔍 Cari bank, nomor, atas nama..."
                            class="w-full rounded-2xl border border-[#E2E8F0] bg-white py-3 px-4 text-[13px] text-[#161A30] placeholder:text-[#94A3B8] focus:border-[#0052CC] focus:outline-none shadow-2xs"
                        >
                    </form>

                    <!-- Rekening Cards -->
                    <div class="space-y-3">
                        @foreach ($rekenings as $index => $rek)
                            <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)] space-y-3">
                                <div class="flex items-start gap-3">
                                    <div class="w-10 h-10 rounded-xl bg-[#E8F0FE] text-[#003BA5] flex items-center justify-center shrink-0">
                                        🏛️
                                    </div>
                                    <div>
                                        <p class="text-[14px] font-extrabold text-[#161A30]">{{ $rek->bank_name }}</p>
                                        <p class="text-[13px] font-extrabold text-[#161A30] tracking-wide">{{ $rek->account_number }}</p>
                                        <span class="mt-1 inline-block rounded-md px-2 py-0.5 text-[10px] font-extrabold {{ $rek->is_active ? 'bg-[#D1FAE5] text-[#059669]' : 'bg-[#F1F5F9] text-[#64748B]' }}">
                                            {{ $index === 0 && $rek->is_active ? 'Utama' : ($rek->is_active ? 'Aktif' : 'Nonaktif') }}
                                        </span>
                                    </div>
                                </div>

                                <div class="space-y-0.5 text-[12px] text-[#64748B]">
                                    <p>Atas nama: {{ $rek->account_name }}</p>
                                    <p>Tarif Registrasi: Rp {{ number_format((float) $rek->nominal_biaya, 0, ',', '.') }}</p>
                                </div>

                                <div class="grid grid-cols-2 gap-2.5 pt-1">
                                    <a
                                        href="{{ route('super-admin.rekening', ['edit' => $rek->rekening_id]) }}"
                                        class="rounded-full border border-[#E2E8F0] bg-white hover:bg-[#F8FAFC] py-2 text-[12.5px] font-bold text-[#161A30] flex items-center justify-center gap-1.5"
                                    >
                                        <span>✎ Edit</span>
                                    </a>
                                    <form method="POST" action="{{ route('super-admin.rekening.delete', $rek->rekening_id) }}" onsubmit="return confirm('Hapus rekening {{ $rek->bank_name }}?')">
                                        @csrf
                                        @method('DELETE')
                                        <button
                                            type="submit"
                                            class="w-full rounded-full border border-red-200 bg-white hover:bg-red-50 py-2 text-[12.5px] font-bold text-[#DC2626] flex items-center justify-center gap-1.5 cursor-pointer"
                                        >
                                            <span>🗑️ Hapus</span>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        @endforeach
                    </div>
                @endif
            </main>

            <x-super-admin-nav active="rekening" />
        </div>
    </div>
</x-layouts.app>
