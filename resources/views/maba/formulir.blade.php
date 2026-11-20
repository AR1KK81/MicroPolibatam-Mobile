<x-layouts.app title="Formulir Pendaftaran Maba — PMB Microcredential Polibatam">
    @php
        $docConfigs = [
            'ktp' => [
                'title' => 'Kartu Tanda Penduduk',
                'subtitle' => 'Wajib e-KTP Asli Fisik',
            ],
            'kk' => [
                'title' => 'Kartu Keluarga (KK)',
                'subtitle' => 'Lembar Asli / Barcode Resmi',
            ],
            'ijazah' => [
                'title' => 'Ijazah / SKL',
                'subtitle' => 'SMA / SMK Sederajat',
            ],
        ];
        $payment = $registration?->payment;
        $bankAccount = $rekening?->account_number ?? '1003301245';
        $bankOwner = $rekening?->account_name ?? 'Politeknik Negeri Batam';
        $nominalBiaya = (float) ($rekening?->nominal_biaya ?? 200000);
    @endphp

    <div class="min-h-screen bg-[#EEF2FA] flex justify-center">
        <div class="w-full max-w-[430px] min-h-screen bg-[#FBF8FF] flex flex-col justify-between pb-28 relative shadow-[0_0_40px_rgba(15,23,42,0.06)]">
            <!-- Header (Frame 504:289) -->
            <header class="sticky top-0 z-30 bg-[#FBF8FF]/90 backdrop-blur-md border-b border-[#EAE8F5] px-4 h-16 flex items-center justify-between">
                <div class="flex items-center gap-2">
                    <a
                        href="{{ route('maba.dashboard') }}"
                        aria-label="Kembali ke Beranda"
                        class="w-10 h-10 rounded-full flex items-center justify-center text-[#003BA5] hover:bg-[#ECECFF] transition"
                    >
                        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="19" y1="12" x2="5" y2="12" />
                            <polyline points="12 19 5 12 12 5" />
                        </svg>
                    </a>
                    <span class="text-[11.5px] font-extrabold tracking-[0.05em] text-[#003BA5] uppercase">
                        PMB POLIBATAM
                    </span>
                </div>

                <div class="flex items-center gap-2">
                    <a href="{{ route('maba.status') }}" class="w-9 h-9 rounded-full flex items-center justify-center text-[#434655] hover:bg-[#ECECFF]">
                        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="12" cy="12" r="9.5" />
                            <path d="M9.4 9.3a2.7 2.7 0 0 1 5.1 1c0 1.8-2.5 2.2-2.5 3.6" />
                            <circle cx="12" cy="17.2" r="0.6" fill="currentColor" />
                        </svg>
                    </a>
                    <a href="{{ route('maba.profil') }}" class="w-8 h-8 rounded-full bg-[#003BA5] text-white flex items-center justify-center">
                        <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                            <circle cx="12" cy="7" r="4" />
                        </svg>
                    </a>
                </div>
            </header>

            <!-- Main Content -->
            <main class="px-4 pt-3 space-y-4 flex-1">
                <!-- Horizontal 3-Tab Segmented Control (Frame 504:156) -->
                <div class="rounded-2xl bg-[#EFF6FF]/80 border border-[#DBEAFE] p-1.5 grid grid-cols-3 gap-1">
                    <a
                        href="{{ route('maba.formulir', ['tab' => 'biodata']) }}"
                        class="rounded-xl py-2 px-2 text-center text-[12px] flex items-center justify-center gap-1.5 transition {{ $activeTab === 'biodata' ? 'bg-[#003BA5] text-white font-bold shadow-xs' : 'text-[#475569] font-semibold hover:bg-white/60' }}"
                    >
                        <span>1. Biodata</span>
                    </a>
                    <a
                        href="{{ route('maba.formulir', ['tab' => 'dokumen']) }}"
                        class="rounded-xl py-2 px-2 text-center text-[12px] flex items-center justify-center gap-1.5 transition {{ $activeTab === 'dokumen' ? 'bg-[#003BA5] text-white font-bold shadow-xs' : 'text-[#475569] font-semibold hover:bg-white/60' }}"
                    >
                        <span>2. Dokumen</span>
                    </a>
                    <a
                        href="{{ route('maba.formulir', ['tab' => 'bayar']) }}"
                        class="rounded-xl py-2 px-2 text-center text-[12px] flex items-center justify-center gap-1.5 transition {{ $activeTab === 'bayar' ? 'bg-[#003BA5] text-white font-bold shadow-xs' : 'text-[#475569] font-semibold hover:bg-white/60' }}"
                    >
                        <span>3. Bayar BNI</span>
                    </a>
                </div>

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

                {{-- ================= TAB 1: 1. BIODATA (Frame 504:2) ================= --}}
                @if ($activeTab === 'biodata')
                    <form method="POST" action="{{ route('maba.formulir.biodata') }}" id="biodataForm" class="space-y-4">
                        @csrf

                        <!-- Card 1: Data Pribadi Peserta -->
                        <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_12px_rgba(15,23,42,0.03)] space-y-3.5">
                            <div class="flex items-center justify-between">
                                <h2 class="text-[15.5px] font-extrabold text-[#161A30]">👤 Data Pribadi Peserta</h2>
                                <span class="rounded-full bg-[#FFDAD6] px-2.5 py-0.5 text-[10px] font-extrabold text-[#93000A] uppercase">
                                    WAJIB DIISI
                                </span>
                            </div>

                            <!-- Nama Lengkap -->
                            <div>
                                <div class="flex items-center justify-between mb-1.5">
                                    <label for="full_name" class="text-[12.5px] font-bold text-[#161A30]">Nama Lengkap Calon Mahasiswa</label>
                                    <span class="text-[11px] font-bold text-[#003BA5]">Sesuai KTP</span>
                                </div>
                                <input
                                    id="full_name"
                                    name="full_name"
                                    type="text"
                                    required
                                    value="{{ old('full_name', $registration?->full_name) }}"
                                    placeholder="Contoh: Budi Santoso"
                                    class="w-full rounded-xl bg-[#F4F2FF] border border-transparent focus:border-[#003BA5] focus:bg-white px-3.5 py-2.5 text-[13.5px] font-semibold text-[#161A30] focus:outline-none transition"
                                >
                                <p class="mt-1 text-[11px] text-[#64748B]">
                                    ⓘ Sesuai ejaan nama persis dengan yang tercantum di Ijazah / KTP.
                                </p>
                            </div>

                            <!-- NIK -->
                            <div>
                                <label for="nik" class="block text-[12.5px] font-bold text-[#161A30] mb-1.5">
                                    Nomor Induk Kependudukan (NIK)
                                </label>
                                <div class="relative">
                                    <input
                                        id="nik"
                                        name="nik"
                                        type="text"
                                        inputmode="numeric"
                                        maxlength="16"
                                        required
                                        value="{{ old('nik', $registration?->readableNik()) }}"
                                        placeholder="16 digit NIK e-KTP"
                                        class="w-full rounded-xl bg-[#F4F2FF] border border-transparent focus:border-[#003BA5] focus:bg-white pl-3.5 pr-28 py-2.5 text-[13.5px] font-semibold text-[#161A30] focus:outline-none transition"
                                    >
                                    <span class="absolute right-2.5 top-1/2 -translate-y-1/2 rounded-lg bg-[#DCE9FF] px-2 py-1 text-[10px] font-extrabold text-[#003BA5]">
                                        &#10003; Valid Dukcapil
                                    </span>
                                </div>
                            </div>

                            <!-- Tempat & Tanggal Lahir -->
                            <div class="grid grid-cols-2 gap-2.5">
                                <div>
                                    <label for="birth_place" class="block text-[12.5px] font-bold text-[#161A30] mb-1.5">Tempat Lahir</label>
                                    <input
                                        id="birth_place"
                                        name="birth_place"
                                        type="text"
                                        required
                                        value="{{ old('birth_place', $registration?->birth_place) }}"
                                        placeholder="Batam"
                                        class="w-full rounded-xl bg-[#F4F2FF] border border-transparent focus:border-[#003BA5] focus:bg-white px-3.5 py-2.5 text-[13.5px] font-semibold text-[#161A30] focus:outline-none transition"
                                    >
                                </div>
                                <div>
                                    <label for="birth_date" class="block text-[12.5px] font-bold text-[#161A30] mb-1.5">Tanggal Lahir</label>
                                    <input
                                        id="birth_date"
                                        name="birth_date"
                                        type="date"
                                        required
                                        value="{{ old('birth_date', $registration?->birth_date?->format('Y-m-d')) }}"
                                        class="w-full rounded-xl bg-[#F4F2FF] border border-transparent focus:border-[#003BA5] focus:bg-white px-3 py-2.5 text-[13px] font-semibold text-[#161A30] focus:outline-none transition"
                                    >
                                </div>
                            </div>

                            <!-- Asal Sekolah -->
                            <div>
                                <label for="origin_school" class="block text-[12.5px] font-bold text-[#161A30] mb-1.5">Asal Sekolah</label>
                                <input
                                    id="origin_school"
                                    name="origin_school"
                                    type="text"
                                    required
                                    value="{{ old('origin_school', $registration?->origin_school) }}"
                                    placeholder="Contoh: SMKN 1 Batam"
                                    class="w-full rounded-xl bg-[#F4F2FF] border border-transparent focus:border-[#003BA5] focus:bg-white px-3.5 py-2.5 text-[13.5px] font-semibold text-[#161A30] focus:outline-none transition"
                                >
                            </div>

                            <!-- Alamat Lengkap Domisili -->
                            <div>
                                <label for="address" class="block text-[12.5px] font-bold text-[#161A30] mb-1.5">Alamat Lengkap Domisili</label>
                                <textarea
                                    id="address"
                                    name="address"
                                    rows="2"
                                    required
                                    placeholder="Contoh: Batam Centre, Kota Batam"
                                    class="w-full rounded-xl bg-[#F4F2FF] border border-transparent focus:border-[#003BA5] focus:bg-white px-3.5 py-2.5 text-[13.5px] font-semibold text-[#161A30] focus:outline-none transition"
                                >{{ old('address', $registration?->address) }}</textarea>
                            </div>
                        </div>

                        <!-- Card 2: Track Microcredential -->
                        <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_12px_rgba(15,23,42,0.03)] space-y-3">
                            <div class="flex items-center justify-between">
                                <h2 class="text-[15.5px] font-extrabold text-[#161A30]">🎓 Track Microcredential</h2>
                                <span class="rounded-full bg-[#DCE9FF] px-2.5 py-0.5 text-[10px] font-extrabold text-[#003BA5] uppercase">
                                    POLIBATAM 2026
                                </span>
                            </div>

                            <div>
                                <label for="track_id" class="block text-[12.5px] font-bold text-[#161A30] mb-1.5">
                                    Jurusan &amp; Program Studi Terapan (D4)
                                </label>
                                <select
                                    id="track_id"
                                    name="track_id"
                                    required
                                    class="w-full rounded-xl bg-[#F4F2FF] border border-transparent focus:border-[#003BA5] focus:bg-white px-3.5 py-3 text-[13.5px] font-bold text-[#161A30] focus:outline-none transition"
                                >
                                    @foreach ($tracks as $track)
                                        <option
                                            value="{{ $track->track_id }}"
                                            {{ (int) old('track_id', $registration?->track_id) === $track->track_id ? 'selected' : '' }}
                                        >
                                            {{ $track->department_name }} — {{ $track->study_program_name }} ({{ $track->track_name }})
                                        </option>
                                    @endforeach
                                </select>
                            </div>
                        </div>

                        <p class="text-center text-[11px] font-bold text-[#434655] pt-1">
                            Tahap 1 dari 3 Selesai
                        </p>

                        <!-- Sticky Bottom Bar -->
                        <div class="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-[430px] bg-white border-t border-[#E6E8F2] px-4 py-3 z-40">
                            <button
                                type="submit"
                                class="w-full h-12 rounded-xl bg-[#003BA5] hover:bg-[#002D80] text-white font-bold text-[14px] flex items-center justify-center gap-2 shadow-sm transition cursor-pointer"
                            >
                                <span>Simpan Biodata &amp; Lanjut Unggah Dokumen</span>
                                <span>&rarr;</span>
                            </button>
                        </div>
                    </form>

                {{-- ================= TAB 2: 2. DOKUMEN WAJIB (Frame 504:153) ================= --}}
                @elseif ($activeTab === 'dokumen')
                    <!-- Notice Alert Banner (Frame 504:174) -->
                    <div class="rounded-2xl bg-[#F4F2FF] p-3.5 flex items-start gap-2.5 shadow-2xs">
                        <div class="w-8 h-8 rounded-full bg-[#DBE1FF] text-[#003BA5] flex items-center justify-center shrink-0 font-extrabold text-sm">
                            i
                        </div>
                        <div>
                            <p class="text-[13.5px] font-bold text-[#161A30]">Persyaratan Berkas Digital</p>
                            <p class="text-[12px] text-[#434655] leading-relaxed mt-0.5">
                                Unggah KTP, KK, dan Ijazah / SKL format <strong class="text-[#161A30]">JPG, PNG, atau PDF</strong> (Maksimal 2 MB per berkas). Sistem menjalankan validasi optik &amp; audit registrasi admisi.
                            </p>
                        </div>
                    </div>

                    <!-- 3 Document Cards (KTP, KK, Ijazah/SKL) -->
                    <div class="space-y-3">
                        @foreach ($docConfigs as $docType => $meta)
                            @php
                                /** @var \App\Models\Document|null $doc */
                                $doc = $documentsByType->get($docType);
                                $isRevision = $doc?->status_verifikasi_admin === 'revisi';
                                $isValid = $doc?->status_verifikasi_admin === 'valid';
                            @endphp
                            <div class="rounded-2xl bg-white p-3.5 shadow-[0_1px_4px_rgba(0,0,0,0.05)] space-y-2.5">
                                <!-- Card Header -->
                                <div class="flex items-start justify-between gap-2">
                                    <div class="flex items-center gap-2.5">
                                        <div class="w-10 h-10 rounded-xl {{ $isRevision ? 'bg-[#FFDAD6] text-[#93000A]' : 'bg-[#ECECFF] text-[#003BA5]' }} flex items-center justify-center shrink-0 font-bold">
                                            @if ($docType === 'ktp')
                                                🪪
                                            @elseif ($docType === 'kk')
                                                👪
                                            @else
                                                🎓
                                            @endif
                                        </div>
                                        <div>
                                            <h3 class="text-[15px] font-bold text-[#161A30]">{{ $meta['title'] }}</h3>
                                            <p class="text-[11.5px] text-[#434655]">{{ $meta['subtitle'] }}</p>
                                        </div>
                                    </div>

                                    @if ($isValid)
                                        <span class="rounded-full bg-[#E5E6FF] px-2.5 py-1 text-[11px] font-bold text-[#003BA5] inline-flex items-center gap-1">
                                            <span>&#10003;</span>
                                            <span>Valid</span>
                                        </span>
                                    @elseif ($isRevision)
                                        <span class="rounded-full bg-[#FFDAD6] px-2.5 py-1 text-[11px] font-bold text-[#93000A] inline-flex items-center gap-1">
                                            <span>!</span>
                                            <span>Perlu Revisi</span>
                                        </span>
                                    @elseif ($doc !== null)
                                        <span class="rounded-full bg-[#D6E3FE] px-2.5 py-1 text-[11px] font-bold text-[#0E1C2F] inline-flex items-center gap-1">
                                            <span>⏳</span>
                                            <span>Menunggu</span>
                                        </span>
                                    @else
                                        <span class="rounded-full bg-[#F1F5F9] px-2.5 py-1 text-[11px] font-bold text-[#64748B]">
                                            Belum Unggah
                                        </span>
                                    @endif
                                </div>

                                <!-- Uploaded Preview Tile OR Interactive Dropzone -->
                                <form method="POST" action="{{ route('maba.formulir.dokumen') }}" enctype="multipart/form-data">
                                    @csrf
                                    <input type="hidden" name="doc_type" value="{{ $docType }}">

                                    @if ($doc !== null && ! $isRevision)
                                        <div class="rounded-xl bg-[#F4F2FF] p-2.5 flex items-center justify-between gap-2">
                                            <div class="flex items-center gap-2.5 min-w-0">
                                                <div class="w-12 h-10 rounded-lg bg-[#ECECFF] flex items-center justify-center relative overflow-hidden shrink-0 text-xs font-extrabold text-[#003BA5]">
                                                    <span>DOC</span>
                                                    <div class="absolute bottom-0 inset-x-0 h-1 {{ $isValid ? 'bg-[#003BA5]' : 'bg-[#525F75]' }}"></div>
                                                </div>
                                                <div class="min-w-0">
                                                    <p class="text-[13.5px] font-semibold text-[#161A30] truncate">
                                                        {{ basename($doc->file_path) }}
                                                    </p>
                                                    <p class="text-[11.5px] text-[#434655]">
                                                        Terunggah {{ $doc->uploaded_at?->format('d M Y') ?? 'Baru saja' }}
                                                    </p>
                                                </div>
                                            </div>

                                            <label class="rounded-lg bg-[#ECECFF] hover:bg-[#DCE2FF] px-3 py-1.5 text-[12.5px] font-semibold text-[#003BA5] shrink-0 cursor-pointer transition">
                                                <span>&#8635; Ganti</span>
                                                <input
                                                    type="file"
                                                    name="document_file"
                                                    accept=".jpg,.jpeg,.png,.pdf"
                                                    onchange="this.form.submit()"
                                                    class="hidden"
                                                >
                                            </label>
                                        </div>
                                    @else
                                        <label class="block rounded-xl bg-[#F4F2FF] hover:bg-[#ECECFF]/80 p-4 text-center cursor-pointer transition">
                                            <div class="w-12 h-12 rounded-full bg-[#ECECFF] text-[#003BA5] flex items-center justify-center mx-auto mb-2">
                                                <svg class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                                                    <polyline points="17 8 12 3 7 8" />
                                                    <line x1="12" y1="3" x2="12" y2="15" />
                                                </svg>
                                            </div>
                                            <p class="text-[13.5px] font-semibold text-[#003BA5]">Ketuk untuk unggah berkas baru</p>
                                            <p class="text-[11.5px] text-[#434655] mt-0.5">Format PDF, JPG, atau PNG (Maks 2 MB)</p>
                                            <input
                                                type="file"
                                                name="document_file"
                                                accept=".jpg,.jpeg,.png,.pdf"
                                                onchange="this.form.submit()"
                                                class="hidden"
                                            >
                                        </label>
                                    @endif
                                </form>

                                @if ($isRevision || ($docType === 'ijazah' && $registration?->admin_verification_notes))
                                    <div class="rounded-xl bg-[#FFDAD6]/40 p-2.5 flex items-start gap-2">
                                        <span class="text-[#93000A] font-bold text-sm mt-0.5">⚠️</span>
                                        <div>
                                            <p class="text-[13px] font-semibold text-[#161A30]">Catatan Admin Registrasi:</p>
                                            <p class="text-[11.5px] text-[#434655] leading-relaxed mt-0.5">
                                                {{ $doc?->admin_revision_notes ?: ($registration?->admin_verification_notes ?: 'Mohon unggah ulang dokumen yang utuh dan pencahayaan terang.') }}
                                            </p>
                                        </div>
                                    </div>
                                @endif
                            </div>
                        @endforeach
                    </div>

                    <p class="text-center text-[11px] font-bold text-[#434655] pt-2">
                        Tahap 2 dari 3 Selesai
                    </p>

                    <!-- Bottom Floating / Sticky Action Bar (Frame 504:280) -->
                    <div class="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-[430px] bg-white shadow-[0_-4px_10px_rgba(11,25,44,0.06)] px-4 py-3 z-40 space-y-1.5">
                        <a
                            href="{{ route('maba.formulir', ['tab' => 'bayar']) }}"
                            class="w-full h-12 rounded-xl bg-[#003BA5] hover:bg-[#002D80] text-white font-semibold text-[14px] flex items-center justify-center gap-2 transition"
                        >
                            <span>Simpan Dokumen Wajib</span>
                            <span>&rarr;</span>
                        </a>
                        <a
                            href="{{ route('maba.formulir', ['tab' => 'biodata']) }}"
                            class="block w-full py-1 text-center text-[13.5px] font-semibold text-[#434655] hover:text-[#161A30]"
                        >
                            Kembali ke Biodata
                        </a>
                    </div>

                {{-- ================= TAB 3: 3. BAYAR BNI (Frame 504:306) ================= --}}
                @else
                    <!-- Header Step 3 -->
                    <div class="flex items-center justify-between">
                        <div class="flex items-center gap-2">
                            <span class="w-6 h-6 rounded-full bg-[#DCE9FF] text-[#003BA5] text-xs font-extrabold flex items-center justify-center">3</span>
                            <h2 class="text-[15px] font-extrabold text-[#161A30]">Pelunasan Formulir PMB</h2>
                        </div>
                        <span class="text-[11.5px] text-[#64748B]">Langkah Terakhir</span>
                    </div>

                    <!-- Countdown & Status Card -->
                    <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)] space-y-3">
                        <div class="flex items-center justify-between">
                            <span class="text-[12px] text-[#64748B]">Status Pendaftaran</span>
                            @if ($payment?->status_pembayaran === 'lunas')
                                <span class="rounded-full bg-[#D1FAE5] px-3 py-1 text-[10.5px] font-extrabold text-[#059669] uppercase">
                                    &#10003; PEMBAYARAN LUNAS
                                </span>
                            @else
                                <span class="rounded-full bg-[#E8F0FE] px-3 py-1 text-[10.5px] font-extrabold text-[#003BA5] uppercase">
                                    &bull; MENUNGGU PEMBAYARAN
                                </span>
                            @endif
                        </div>

                        <div class="flex items-center justify-between gap-2">
                            <div>
                                <p class="text-[11px] text-[#64748B]">Sisa Waktu Pembayaran</p>
                                <p class="text-[15px] font-extrabold text-[#161A30]">23 Jam 58 Menit</p>
                            </div>
                            <div class="text-right">
                                <p class="text-[11px] text-[#64748B]">Jatuh Tempo</p>
                                <p class="text-[12.5px] font-extrabold text-[#161A30]">23:59 WIB</p>
                            </div>
                        </div>

                        <div class="rounded-xl bg-[#F4F2FF] p-3 text-[11.5px] text-[#434655] leading-relaxed">
                            ⓘ Lakukan transfer tepat sebelum batas waktu agar akun pendaftaran dan pilihan prodi microcredential Anda divalidasi otomatis.
                        </div>
                    </div>

                    <!-- Transfer Bank BNI Card -->
                    <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)] space-y-3.5">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center gap-2.5">
                                <div class="w-10 h-10 rounded-xl bg-[#E8F0FE] text-[#003BA5] font-extrabold text-xs flex items-center justify-center">
                                    BNI
                                </div>
                                <div>
                                    <p class="text-[14px] font-extrabold text-[#161A30]">{{ $rekening?->bank_name ?? 'Transfer Bank BNI' }}</p>
                                    <p class="text-[11.5px] text-[#64748B]">Rekening Giro Resmi Polibatam</p>
                                </div>
                            </div>
                            <span class="rounded-full bg-[#DCE9FF] px-2.5 py-0.5 text-[10px] font-extrabold text-[#003BA5] uppercase">
                                RESMI
                            </span>
                        </div>

                        <div class="rounded-xl bg-[#F4F2FF] p-3.5 flex items-center justify-between gap-2">
                            <div>
                                <p class="text-[10px] font-bold tracking-wider text-[#64748B] uppercase">NOMOR REKENING BNI</p>
                                <p class="text-[19px] font-extrabold text-[#161A30] tracking-wider mt-0.5" id="bniAccountText">{{ $bankAccount }}</p>
                            </div>
                            <button
                                type="button"
                                onclick="navigator.clipboard.writeText('{{ $bankAccount }}'); this.textContent = '✓ Tersalin';"
                                class="rounded-xl bg-[#003BA5] hover:bg-[#002D80] text-white px-3.5 py-2 text-[12px] font-bold transition cursor-pointer"
                            >
                                📋 Salin
                            </button>
                        </div>

                        <div class="space-y-1.5 text-[12px]">
                            <div class="flex justify-between gap-2">
                                <span class="text-[#64748B]">Nama Penerima</span>
                                <span class="font-extrabold text-[#161A30] text-right">{{ $bankOwner }}</span>
                            </div>
                            <div class="flex justify-between gap-2">
                                <span class="text-[#64748B]">Berita / Keterangan</span>
                                <span class="font-semibold text-[#434655] text-right">{{ $registration?->full_name ?? 'Maba' }} - PMB Micro</span>
                            </div>
                        </div>

                        <div class="pt-2 border-t border-[#F1F5F9] flex items-center justify-between">
                            <div>
                                <p class="text-[12px] font-semibold text-[#434655]">Total Biaya Pendaftaran</p>
                                <p class="text-[10.5px] text-[#64748B]">Biaya Admisi &amp; Uji Kompetensi</p>
                            </div>
                            <p class="text-[20px] font-extrabold text-[#003BA5]">
                                Rp{{ number_format($nominalBiaya, 0, ',', '.') }}
                            </p>
                        </div>
                    </div>

                    <!-- Panduan Pembayaran -->
                    <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)] space-y-2.5">
                        <p class="text-[14px] font-extrabold text-[#161A30]">📖 Panduan Pembayaran</p>
                        <details class="rounded-xl bg-[#F4F2FF] p-3 text-[12px]" open>
                            <summary class="font-extrabold text-[#161A30] cursor-pointer">1. BNI Mobile Banking</summary>
                            <ol class="mt-2 space-y-1 text-[#434655] list-decimal list-inside">
                                <li>Buka aplikasi BNI Mobile Banking dan login.</li>
                                <li>Pilih menu <strong>Transfer</strong> &gt; <strong>Antar Rekening BNI</strong>.</li>
                                <li>Masukkan nomor rekening <strong>{{ $bankAccount }}</strong> dan nominal <strong>Rp {{ number_format($nominalBiaya, 0, ',', '.') }}</strong>.</li>
                            </ol>
                        </details>
                        <details class="rounded-xl bg-[#F4F2FF] p-3 text-[12px]">
                            <summary class="font-extrabold text-[#161A30] cursor-pointer">2. Transfer Antar-Bank / BI-FAST</summary>
                            <ol class="mt-2 space-y-1 text-[#434655] list-decimal list-inside">
                                <li>Buka mobile banking bank apa saja (BCA, Mandiri, BRI, dll).</li>
                                <li>Pilih transfer ke <strong>Bank BNI (Kode 009)</strong> nomor <strong>{{ $bankAccount }}</strong>.</li>
                            </ol>
                        </details>
                    </div>

                    <!-- Unggah Bukti Transfer Manual -->
                    <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)] space-y-3">
                        <div class="flex items-start justify-between gap-2">
                            <div>
                                <h3 class="text-[14.5px] font-extrabold text-[#161A30]">Unggah Bukti Transfer Manual</h3>
                                <p class="text-[11.5px] text-[#64748B] mt-0.5">
                                    Lampirkan foto resi ATM, struk mutasi, atau screenshot m-banking Anda untuk mempercepat validasi staf.
                                </p>
                            </div>
                            <span class="rounded-full bg-[#E8F0FE] px-2.5 py-0.5 text-[10px] font-bold text-[#003BA5] shrink-0">
                                Verifikasi Staf
                            </span>
                        </div>

                        @if ($payment !== null)
                            <div class="rounded-xl bg-[#EBF3FF] p-3 flex items-center justify-between text-[12px]">
                                <span class="font-bold text-[#003BA5] truncate">Bukti Terunggah: {{ basename($payment->proof_file_path) }}</span>
                                <span class="uppercase font-extrabold text-[#161A30] ml-2">{{ $payment->status_pembayaran }}</span>
                            </div>
                        @endif

                        <form method="POST" action="{{ route('maba.formulir.pembayaran') }}" enctype="multipart/form-data">
                            @csrf
                            <label class="block rounded-2xl border-2 border-dashed border-[#C8DCFF] bg-[#F4F6FF] hover:bg-[#ECECFF]/70 p-5 text-center cursor-pointer transition">
                                <div class="w-11 h-11 rounded-full bg-[#DCE9FF] text-[#003BA5] flex items-center justify-center mx-auto mb-2">
                                    <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                                        <polyline points="17 8 12 3 7 8" />
                                        <line x1="12" y1="3" x2="12" y2="15" />
                                    </svg>
                                </div>
                                <p class="text-[13.5px] font-bold text-[#003BA5]">Pilih Foto / Dokumen Resi Transfer</p>
                                <p class="text-[11.5px] text-[#64748B] mt-0.5">Format JPG, PNG, atau PDF (Maksimal 2 MB)</p>
                                <span class="mt-2.5 inline-block rounded-lg bg-white border border-[#DCE6F7] px-3 py-1 text-[11.5px] font-bold text-[#003BA5] shadow-2xs">
                                    Pilih File Dokumen
                                </span>
                                <input
                                    type="file"
                                    name="proof_file"
                                    accept=".jpg,.jpeg,.png,.pdf"
                                    onchange="this.form.submit()"
                                    class="hidden"
                                >
                            </label>
                        </form>
                    </div>

                    <!-- Sticky Bottom Bar Step 3 -->
                    <div class="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-[430px] bg-white shadow-[0_-4px_10px_rgba(11,25,44,0.06)] px-4 py-3 z-40 space-y-1.5">
                        <a
                            href="{{ route('maba.status') }}"
                            class="w-full h-12 rounded-xl bg-[#003BA5] hover:bg-[#002D80] text-white font-semibold text-[14px] flex items-center justify-center gap-2 transition"
                        >
                            <span>Cek Status Pembayaran</span>
                            <span>&rarr;</span>
                        </a>
                        <a
                            href="{{ route('maba.formulir', ['tab' => 'dokumen']) }}"
                            class="block w-full py-1 text-center text-[13.5px] font-semibold text-[#434655] hover:text-[#161A30]"
                        >
                            Kembali ke Dokumen Wajib
                        </a>
                    </div>
                @endif
            </main>
        </div>
    </div>
</x-layouts.app>
