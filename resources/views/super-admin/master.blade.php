<x-layouts.app title="Master Data PMB — Super Admin Polibatam">
    <div class="min-h-screen bg-[#EEF2FA] flex justify-center">
        <div class="w-full max-w-[430px] min-h-screen bg-[#FBF8FF] flex flex-col justify-between pb-24 relative shadow-[0_0_40px_rgba(15,23,42,0.06)]">
            <!-- Header -->
            <header class="sticky top-0 z-30 bg-[#FBF8FF]/95 backdrop-blur-md border-b border-[#EAE8F5] px-4 h-16 flex items-center justify-between">
                <div>
                    <p class="text-[10.5px] font-extrabold tracking-wider text-[#003BA5] uppercase">SUPER ADMIN PORTAL</p>
                    <p class="text-[15.5px] font-extrabold text-[#161A30] leading-tight">Master Data Sistem</p>
                </div>
            </header>

            <main class="px-4 pt-4 space-y-5 flex-1">
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

                <!-- SECTION 1: JALUR MICROCREDENTIAL (tracks) -->
                <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-2xs space-y-3">
                    <h2 class="text-[15px] font-extrabold text-[#161A30]">🎓 Jalur &amp; Program Studi (`tracks`)</h2>

                    <div class="space-y-2">
                        @foreach ($tracks as $t)
                            <div class="rounded-xl bg-[#F4F2FF] p-3 flex items-center justify-between gap-2">
                                <div class="min-w-0">
                                    <p class="text-[13px] font-extrabold text-[#161A30]">{{ $t->track_name }}</p>
                                    <p class="text-[11.5px] text-[#434655]">{{ $t->department_name }} &bull; {{ $t->study_program_name }}</p>
                                </div>
                                <form method="POST" action="{{ route('super-admin.tracks.toggle', $t->track_id) }}">
                                    @csrf
                                    <button
                                        type="submit"
                                        class="rounded-lg px-2.5 py-1 text-[11px] font-extrabold cursor-pointer {{ $t->is_active ? 'bg-[#D1FAE5] text-[#059669]' : 'bg-[#FFDAD6] text-[#93000A]' }}"
                                    >
                                        {{ $t->is_active ? 'Aktif' : 'Nonaktif' }}
                                    </button>
                                </form>
                            </div>
                        @endforeach
                    </div>

                    <form method="POST" action="{{ route('super-admin.tracks.store') }}" class="pt-2 border-t border-[#F1F5F9] space-y-2.5">
                        @csrf
                        <p class="text-[12px] font-bold text-[#003BA5]">+ Tambah Jalur Baru</p>
                        <input
                            type="text"
                            name="department_name"
                            required
                            placeholder="Jurusan (misal: Teknik Informatika)"
                            class="w-full rounded-xl bg-[#F8FAFC] border border-[#E2E8F0] px-3 py-2 text-[12.5px]"
                        >
                        <input
                            type="text"
                            name="study_program_name"
                            required
                            placeholder="Program Studi (misal: D4 TRPL)"
                            class="w-full rounded-xl bg-[#F8FAFC] border border-[#E2E8F0] px-3 py-2 text-[12.5px]"
                        >
                        <input
                            type="text"
                            name="track_name"
                            required
                            placeholder="Nama Track Microcredential"
                            class="w-full rounded-xl bg-[#F8FAFC] border border-[#E2E8F0] px-3 py-2 text-[12.5px]"
                        >
                        <button type="submit" class="w-full rounded-xl bg-[#0052CC] text-white py-2.5 text-[12.5px] font-bold cursor-pointer">
                            Tambah Jalur
                        </button>
                    </form>
                </div>

                <!-- SECTION 2: REKENING PEMBAYARAN BNI (rekening) -->
                <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-2xs space-y-3">
                    <h2 class="text-[15px] font-extrabold text-[#161A30]">🏛️ Rekening Pembayaran (`rekening`)</h2>
                    @foreach ($rekenings as $rek)
                        <form method="POST" action="{{ route('super-admin.rekening.update', $rek->rekening_id) }}" class="space-y-2.5">
                            @csrf
                            <div class="grid grid-cols-2 gap-2">
                                <div>
                                    <label class="block text-[11px] font-bold text-[#64748B] mb-1">Nama Bank</label>
                                    <input type="text" name="bank_name" value="{{ $rek->bank_name }}" required class="w-full rounded-xl bg-[#F4F2FF] px-3 py-2 text-[12.5px] font-bold">
                                </div>
                                <div>
                                    <label class="block text-[11px] font-bold text-[#64748B] mb-1">Nomor Rekening</label>
                                    <input type="text" name="account_number" value="{{ $rek->account_number }}" required class="w-full rounded-xl bg-[#F4F2FF] px-3 py-2 text-[12.5px] font-bold">
                                </div>
                            </div>
                            <div>
                                <label class="block text-[11px] font-bold text-[#64748B] mb-1">Atas Nama Rekening</label>
                                <input type="text" name="account_name" value="{{ $rek->account_name }}" required class="w-full rounded-xl bg-[#F4F2FF] px-3 py-2 text-[12.5px] font-bold">
                            </div>
                            <div>
                                <label class="block text-[11px] font-bold text-[#64748B] mb-1">Nominal Biaya Pendaftaran (Rp)</label>
                                <input type="number" name="nominal_biaya" value="{{ (int) $rek->nominal_biaya }}" required class="w-full rounded-xl bg-[#F4F2FF] px-3 py-2 text-[12.5px] font-bold">
                            </div>
                            <button type="submit" class="w-full rounded-xl bg-[#003BA5] text-white py-2.5 text-[12.5px] font-bold cursor-pointer">
                                Simpan Perubahan Rekening
                            </button>
                        </form>
                    @endforeach
                </div>

                <!-- SECTION 3: KONTAK HELPDESK (contact_persons) -->
                <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-2xs space-y-3">
                    <h2 class="text-[15px] font-extrabold text-[#161A30]">🎧 Kontak Pusat Bantuan (`contact_persons`)</h2>

                    <div class="space-y-2">
                        @foreach ($contactPersons as $cp)
                            <div class="rounded-xl bg-[#F4F2FF] p-3 flex items-center justify-between gap-2">
                                <div>
                                    <p class="text-[13px] font-extrabold text-[#161A30]">{{ $cp->name }}</p>
                                    <p class="text-[11.5px] text-[#434655]">{{ $cp->phone }} &bull; {{ $cp->email }}</p>
                                </div>
                                <form method="POST" action="{{ route('super-admin.contacts.delete', $cp->cp_id) }}">
                                    @csrf
                                    @method('DELETE')
                                    <button type="submit" class="rounded-lg bg-[#FFDAD6] px-2.5 py-1 text-[11px] font-extrabold text-[#93000A] cursor-pointer">
                                        Hapus
                                    </button>
                                </form>
                            </div>
                        @endforeach
                    </div>

                    <form method="POST" action="{{ route('super-admin.contacts.store') }}" class="pt-2 border-t border-[#F1F5F9] space-y-2">
                        @csrf
                        <p class="text-[12px] font-bold text-[#003BA5]">+ Tambah Kontak Helpdesk</p>
                        <input type="text" name="name" required placeholder="Nama Layanan (misal: Admin Akademik)" class="w-full rounded-xl bg-[#F8FAFC] border border-[#E2E8F0] px-3 py-2 text-[12.5px]">
                        <div class="grid grid-cols-2 gap-2">
                            <input type="text" name="phone" required placeholder="No. WA (0812xxx)" class="w-full rounded-xl bg-[#F8FAFC] border border-[#E2E8F0] px-3 py-2 text-[12.5px]">
                            <select name="role_label" class="w-full rounded-xl bg-[#F8FAFC] border border-[#E2E8F0] px-2.5 py-2 text-[12px] font-bold">
                                <option value="admin_pendaftaran">Admin Pendaftaran</option>
                                <option value="staf_keuangan">Staf Keuangan</option>
                            </select>
                        </div>
                        <input type="email" name="email" required placeholder="Email Helpdesk" class="w-full rounded-xl bg-[#F8FAFC] border border-[#E2E8F0] px-3 py-2 text-[12.5px]">
                        <button type="submit" class="w-full rounded-xl bg-[#0052CC] text-white py-2.5 text-[12.5px] font-bold cursor-pointer">
                            Tambah Kontak
                        </button>
                    </form>
                </div>
            </main>

            <!-- Bottom Navigation Bar (Super Admin) -->
            <nav class="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-[430px] bg-white border-t border-[#E6E8F2] px-4 py-2.5 flex items-center justify-around z-40">
                <a href="{{ route('super-admin.dashboard') }}" class="flex flex-col items-center gap-1 text-[#64748B] hover:text-[#0052CC] font-semibold text-[11px]">
                    <span>👥 Pengguna</span>
                </a>
                <a href="{{ route('super-admin.master') }}" class="flex flex-col items-center gap-1 text-[#0052CC] font-extrabold text-[11px]">
                    <span>🗂️ Master Data</span>
                </a>
                <a href="{{ route('super-admin.audit') }}" class="flex flex-col items-center gap-1 text-[#64748B] hover:text-[#0052CC] font-semibold text-[11px]">
                    <span>🛡️ Audit Log</span>
                </a>
                <a href="{{ route('super-admin.profil') }}" class="flex flex-col items-center gap-1 text-[#64748B] hover:text-[#0052CC] font-semibold text-[11px]">
                    <span>👤 Profil</span>
                </a>
            </nav>
        </div>
    </div>
</x-layouts.app>
