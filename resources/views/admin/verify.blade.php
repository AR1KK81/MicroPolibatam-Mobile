<x-layouts.app title="Validasi Berkas Maba — Admin Registrasi Polibatam">
    @php
        $docNames = [
            'ijazah' => 'Ijazah / SKL Asli',
            'ktp' => 'Kartu Tanda Penduduk (KTP)',
            'kk' => 'Kartu Keluarga (KK)',
        ];
    @endphp

    <div class="min-h-screen bg-[#EEF2FA] flex justify-center">
        <div class="w-full max-w-[430px] min-h-screen bg-[#FBF8FF] flex flex-col justify-between pb-36 relative shadow-[0_0_40px_rgba(15,23,42,0.06)]">
            <!-- Header (Frame 396:16) -->
            <header class="sticky top-0 z-30 bg-[#FBF8FF]/95 backdrop-blur-md border-b border-[#EAE8F5] px-4 h-16 flex items-center justify-between">
                <div class="flex items-center gap-2.5">
                    <a
                        href="{{ route('admin.dashboard') }}"
                        class="w-9 h-9 rounded-full flex items-center justify-center text-[#161A30] hover:bg-[#ECECFF] transition"
                    >
                        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="19" y1="12" x2="5" y2="12" />
                            <polyline points="12 19 5 12 12 5" />
                        </svg>
                    </a>
                    <div>
                        <p class="text-[14.5px] font-extrabold text-[#161A30] leading-tight">Validasi Berkas Maba</p>
                        <p class="text-[11px] text-[#64748B]">Politeknik Negeri Batam</p>
                    </div>
                </div>
                <a href="{{ route('admin.profil') }}" class="w-9 h-9 rounded-full bg-[#003BA5] text-white flex items-center justify-center">
                    <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                        <circle cx="12" cy="7" r="4" />
                    </svg>
                </a>
            </header>

            <form method="POST" action="{{ route('admin.registrations.verify', $registration->registration_id) }}" id="verifyDocsForm">
                @csrf
                <input type="hidden" name="action_type" id="verifyActionType" value="approve_all">

                <main class="px-4 pt-4 space-y-4">
                    @if ($errors->any())
                        <div class="rounded-2xl border border-red-200 bg-red-50 px-4 py-3 text-[12.5px] font-semibold text-red-700">
                            {{ $errors->first() }}
                        </div>
                    @endif

                    <!-- Top Meta Strip -->
                    <div class="space-y-1.5">
                        <div class="flex items-center gap-2">
                            <span class="rounded-full bg-[#DCE9FF] px-3 py-1 text-[11px] font-extrabold text-[#003BA5]">
                                {{ $registration->track?->department_name ?? 'Informatika' }}
                            </span>
                            <span class="rounded-full bg-[#ECECFF] px-3 py-1 text-[11px] font-bold text-[#161A30]">
                                {{ $registration->registrationCode() }}
                            </span>
                        </div>
                        <span class="inline-block rounded-full bg-[#FEF3C7] px-3 py-0.5 text-[10.5px] font-extrabold text-[#B45309]">
                            &bull; Status: {{ str_replace('_', ' ', ucfirst($registration->status)) }}
                        </span>
                    </div>

                    <!-- Applicant Profile Summary Card -->
                    <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)] space-y-3">
                        <div class="flex items-center gap-3">
                            <div class="w-12 h-12 rounded-full bg-[#0052CC] text-white font-extrabold text-[15px] flex items-center justify-center shrink-0">
                                {{ $registration->initials() }}
                            </div>
                            <div>
                                <h2 class="text-[16.5px] font-extrabold text-[#161A30]">{{ $registration->full_name }}</h2>
                                <p class="text-[12px] text-[#64748B]">🪪 NIK: {{ $registration->readableNik() }}</p>
                                <p class="text-[11.5px] text-[#64748B]">🏫 {{ $registration->origin_school }} &bull; {{ $registration->birth_place }}</p>
                            </div>
                        </div>

                        <div class="rounded-xl bg-[#F4F2FF] px-3.5 py-2.5 flex items-center justify-between text-[12px]">
                            <span class="font-bold text-[#161A30]">Jalur: {{ $registration->track?->track_name ?? 'Microcredential' }}</span>
                            <span class="font-extrabold text-[#003BA5]">Polibatam</span>
                        </div>
                    </div>

                    <!-- Dokumen Persyaratan Section -->
                    <div>
                        <div class="flex items-center justify-between mb-1">
                            <h3 class="text-[15.5px] font-extrabold text-[#161A30]">Dokumen Persyaratan</h3>
                            <span class="text-[11.5px] font-bold text-[#434655]">{{ $registration->documents->count() }} Dokumen Wajib</span>
                        </div>
                        <p class="text-[12px] text-[#64748B] mb-3">Periksa keaslian dan kejelasan berkas digital calon mahasiswa</p>

                        <div class="space-y-3">
                            @forelse ($registration->documents as $doc)
                                <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)] space-y-3">
                                    <div class="flex items-start justify-between gap-2">
                                        <div class="flex items-center gap-2.5">
                                            <div class="w-10 h-10 rounded-xl bg-[#ECECFF] text-[#003BA5] flex items-center justify-center font-bold">
                                                📄
                                            </div>
                                            <div>
                                                <p class="text-[14px] font-extrabold text-[#161A30]">
                                                    {{ $docNames[$doc->doc_type] ?? strtoupper($doc->doc_type) }}
                                                </p>
                                                <p class="text-[11.5px] text-[#64748B]">{{ basename($doc->file_path) }}</p>
                                            </div>
                                        </div>

                                        @if ($doc->status_verifikasi_admin === 'valid')
                                            <span class="rounded-full bg-[#D1FAE5] px-2.5 py-0.5 text-[10.5px] font-extrabold text-[#059669]">
                                                &#10003; Valid
                                            </span>
                                        @elseif ($doc->status_verifikasi_admin === 'revisi')
                                            <span class="rounded-full bg-[#FFDAD6] px-2.5 py-0.5 text-[10.5px] font-extrabold text-[#93000A]">
                                                ! Revisi
                                            </span>
                                        @else
                                            <span class="rounded-full bg-[#FFDAD6]/60 px-2.5 py-0.5 text-[10.5px] font-extrabold text-[#93000A]">
                                                ! Perlu Cek
                                            </span>
                                        @endif
                                    </div>

                                    @if (file_exists(public_path($doc->file_path)))
                                        <a
                                            href="{{ asset($doc->file_path) }}"
                                            target="_blank"
                                            class="w-full rounded-xl bg-[#F4F2FF] hover:bg-[#E5E6FF] px-3.5 py-2.5 text-[12.5px] font-bold text-[#003BA5] flex items-center justify-between transition"
                                        >
                                            <span>👁️ Buka Lampiran ({{ basename($doc->file_path) }})</span>
                                            <span>&#8599;</span>
                                        </a>
                                    @else
                                        <div class="rounded-xl bg-[#F4F2FF] px-3.5 py-2.5 text-[12px] text-[#434655] flex items-center justify-between">
                                            <span>📎 Path: {{ $doc->file_path }}</span>
                                            <span class="font-bold text-[#003BA5]">Arsip DB</span>
                                        </div>
                                    @endif

                                    <!-- Per-Document Radio Toggle: Setujui vs Minta Revisi -->
                                    <div>
                                        <p class="text-[11.5px] font-bold text-[#161A30] mb-1.5">Status Validasi Berkas:</p>
                                        <div class="grid grid-cols-2 gap-2">
                                            <label class="cursor-pointer">
                                                <input
                                                    type="radio"
                                                    name="doc_status[{{ $doc->document_id }}]"
                                                    value="valid"
                                                    {{ $doc->status_verifikasi_admin !== 'revisi' ? 'checked' : '' }}
                                                    class="peer sr-only"
                                                >
                                                <span class="w-full rounded-xl border border-[#E2E8F0] bg-[#F8FAFC] peer-checked:bg-[#D1FAE5] peer-checked:border-[#10B981] peer-checked:text-[#065F46] py-2.5 text-[12.5px] font-extrabold text-[#475569] flex items-center justify-center gap-1.5 transition">
                                                    <span>&#10003; Setujui</span>
                                                </span>
                                            </label>

                                            <label class="cursor-pointer">
                                                <input
                                                    type="radio"
                                                    name="doc_status[{{ $doc->document_id }}]"
                                                    value="revisi"
                                                    {{ $doc->status_verifikasi_admin === 'revisi' ? 'checked' : '' }}
                                                    class="peer sr-only"
                                                >
                                                <span class="w-full rounded-xl border border-[#E2E8F0] bg-[#F8FAFC] peer-checked:bg-[#FFDAD6] peer-checked:border-[#EF4444] peer-checked:text-[#93000A] py-2.5 text-[12.5px] font-extrabold text-[#475569] flex items-center justify-center gap-1.5 transition">
                                                    <span>&#10005; Minta Revisi</span>
                                                </span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            @empty
                                <div class="rounded-2xl bg-white p-5 text-center text-[13px] text-[#64748B]">
                                    Calon mahasiswa ini belum mengunggah berkas dokumen.
                                </div>
                            @endforelse
                        </div>
                    </div>

                    <!-- Catatan Revisi untuk Maba Card -->
                    <div class="rounded-2xl bg-[#FFF5F5] border border-[#FED7D7] p-4 space-y-2.5">
                        <div class="flex items-center gap-2">
                            <span class="w-8 h-8 rounded-full bg-[#FFDAD6] text-[#93000A] flex items-center justify-center text-sm font-bold">✎</span>
                            <h3 class="text-[14.5px] font-extrabold text-[#161A30]">Catatan Revisi untuk Maba</h3>
                        </div>
                        <p class="text-[11.5px] text-[#64748B] leading-relaxed">
                            Catatan ini akan langsung tampil di halaman status &amp; formulir calon mahasiswa.
                        </p>
                        <textarea
                            name="admin_verification_notes"
                            rows="3"
                            maxlength="500"
                            placeholder="Contoh: Foto KTP buram dan nomor NIK tidak terbaca dengan jelas. Silakan unggah ulang scan KTP asli..."
                            class="w-full rounded-xl bg-white border border-[#E2E8F0] p-3 text-[13px] text-[#161A30] placeholder:text-[#94A3B8] focus:border-[#0052CC] focus:outline-none"
                        >{{ old('admin_verification_notes', $registration->admin_verification_notes) }}</textarea>
                        <div class="flex justify-between text-[11px] font-bold text-[#64748B]">
                            <span>Maks. 500 karakter</span>
                            <span class="text-[#003BA5]">Notifikasi Terintegrasi</span>
                        </div>
                    </div>
                </main>

                <!-- Sticky Bottom Action Buttons -->
                <div class="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-[430px] bg-white border-t border-[#E6E8F2] px-4 py-3 z-40 space-y-2">
                    <button
                        type="submit"
                        onclick="document.getElementById('verifyActionType').value = 'request_revision';"
                        class="w-full rounded-xl bg-[#FFDAD6] hover:bg-[#FFC4BE] py-3 text-[13.5px] font-extrabold text-[#93000A] flex items-center justify-center gap-2 transition cursor-pointer"
                    >
                        <span>Tolak &amp; Kirim Catatan Revisi</span>
                    </button>

                    <button
                        type="submit"
                        onclick="document.getElementById('verifyActionType').value = 'approve_all';"
                        class="w-full rounded-xl bg-[#0052CC] hover:bg-[#003E9C] py-3.5 text-[14px] font-extrabold text-white flex items-center justify-center gap-2 shadow-sm transition cursor-pointer"
                    >
                        <span>ACC &amp; Disetujui Semuanya</span>
                        <span>&rarr;</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</x-layouts.app>
