<x-layouts.app title="Helpdesk — Super Admin PMB Polibatam">
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
                    <!-- Tambah / Edit Helpdesk Screen (Image 7 Frame 3) -->
                    <div class="flex items-center justify-between">
                        <div>
                            <h1 class="text-[20px] font-extrabold text-[#161A30]">
                                {{ $editingContact ? 'Edit Helpdesk' : 'Tambah Helpdesk' }}
                            </h1>
                            <p class="text-[12px] text-[#64748B]">Isi kontak layanan bantuan</p>
                        </div>
                        <a
                            href="{{ route('super-admin.helpdesk') }}"
                            class="w-9 h-9 rounded-full bg-white border border-[#E2E8F0] flex items-center justify-center text-[#434655] font-bold"
                        >
                            &#10005;
                        </a>
                    </div>

                    <form method="POST" action="{{ route('super-admin.helpdesk.save') }}" class="space-y-3.5">
                        @csrf
                        @if ($editingContact)
                            <input type="hidden" name="cp_id" value="{{ $editingContact->cp_id }}">
                        @endif

                        <div>
                            <label class="block text-[12px] font-bold text-[#64748B] mb-1.5">Nama Layanan</label>
                            <input
                                type="text"
                                name="name"
                                required
                                value="{{ old('name', $editingContact?->name) }}"
                                placeholder="Contoh: Bantuan Pembayaran VA"
                                class="w-full rounded-2xl border border-[#E2E8F0] bg-white px-4 py-3 text-[13.5px] font-semibold text-[#161A30] focus:border-[#0052CC] focus:outline-none"
                            >
                        </div>

                        <div>
                            <label class="block text-[12px] font-bold text-[#64748B] mb-1.5">Kategori</label>
                            <select
                                name="role_label"
                                class="w-full rounded-2xl border border-[#E2E8F0] bg-white px-4 py-3 text-[13.5px] font-semibold text-[#161A30] focus:border-[#0052CC] focus:outline-none"
                            >
                                <option value="admin_pendaftaran" {{ old('role_label', $editingContact?->role_label) === 'admin_pendaftaran' ? 'selected' : '' }}>
                                    Akademik &amp; Pendaftaran
                                </option>
                                <option value="staf_keuangan" {{ old('role_label', $editingContact?->role_label) === 'staf_keuangan' ? 'selected' : '' }}>
                                    Pembayaran &amp; Keuangan
                                </option>
                            </select>
                        </div>

                        <div>
                            <label class="block text-[12px] font-bold text-[#64748B] mb-1.5">No. WhatsApp</label>
                            <input
                                type="text"
                                name="phone"
                                required
                                value="{{ old('phone', $editingContact?->phone) }}"
                                placeholder="🎧 0812-3456-7890"
                                class="w-full rounded-2xl border border-[#E2E8F0] bg-white px-4 py-3 text-[13.5px] font-semibold text-[#161A30] focus:border-[#0052CC] focus:outline-none"
                            >
                        </div>

                        <div>
                            <label class="block text-[12px] font-bold text-[#64748B] mb-1.5">Email</label>
                            <input
                                type="email"
                                name="email"
                                required
                                value="{{ old('email', $editingContact?->email) }}"
                                placeholder="✉️ helpdesk.bayar@polibatam.ac.id"
                                class="w-full rounded-2xl border border-[#E2E8F0] bg-white px-4 py-3 text-[13.5px] font-semibold text-[#161A30] focus:border-[#0052CC] focus:outline-none"
                            >
                        </div>

                        <div>
                            <label class="block text-[12px] font-bold text-[#64748B] mb-1.5">Jam Layanan</label>
                            <input
                                type="text"
                                readonly
                                value="Sen-Jum, 08.00-16.00 WIB"
                                class="w-full rounded-2xl border border-[#E2E8F0] bg-[#F8FAFC] px-4 py-3 text-[13px] font-semibold text-[#475569]"
                            >
                        </div>

                        <div class="rounded-2xl border border-[#E2E8F0] bg-white px-4 py-3.5 flex items-center justify-between">
                            <span class="text-[13.5px] font-bold text-[#161A30]">Status Aktif</span>
                            <label class="inline-flex items-center cursor-pointer">
                                <input
                                    type="checkbox"
                                    name="is_active"
                                    value="1"
                                    {{ old('is_active', $editingContact?->is_active ?? true) ? 'checked' : '' }}
                                    class="w-5 h-5 accent-[#0052CC] rounded"
                                >
                            </label>
                        </div>

                        <div class="pt-3 grid {{ $editingContact ? 'grid-cols-2' : 'grid-cols-1' }} gap-2.5">
                            <button
                                type="submit"
                                class="rounded-full bg-[#0052CC] hover:bg-[#003E9C] py-3.5 text-[13.5px] font-extrabold text-white flex items-center justify-center gap-1.5 shadow-sm cursor-pointer"
                            >
                                <span>&#10003; Simpan</span>
                            </button>

                            @if ($editingContact)
                                <button
                                    type="button"
                                    onclick="if (confirm('Hapus layanan helpdesk ini?')) document.getElementById('deleteHelpdeskForm').submit();"
                                    class="rounded-full border border-red-300 bg-white hover:bg-red-50 py-3.5 text-[13px] font-extrabold text-[#DC2626] flex items-center justify-center gap-1.5 cursor-pointer"
                                >
                                    <span>🗑️ Hapus Helpdesk</span>
                                </button>
                            @endif
                        </div>
                    </form>

                    @if ($editingContact)
                        <form id="deleteHelpdeskForm" method="POST" action="{{ route('super-admin.contacts.delete', $editingContact->cp_id) }}" class="hidden">
                            @csrf
                            @method('DELETE')
                        </form>
                    @endif
                @else
                    <!-- Helpdesk List Screen (Image 7 Frame 2) -->
                    <div class="flex items-center justify-between">
                        <div>
                            <h1 class="text-[22px] font-extrabold text-[#161A30] leading-tight">Helpdesk</h1>
                            <p class="text-[12px] text-[#64748B]">{{ $counts['semua'] }} layanan terdaftar</p>
                        </div>
                        <a
                            href="{{ route('super-admin.helpdesk', ['create' => 1]) }}"
                            class="w-9 h-9 rounded-full bg-white border border-[#E2E8F0] flex items-center justify-center text-[#161A30] font-bold text-lg shadow-2xs"
                        >
                            +
                        </a>
                    </div>

                    <div>
                        <a
                            href="{{ route('super-admin.helpdesk', ['create' => 1]) }}"
                            class="inline-flex items-center gap-1.5 rounded-full bg-[#0052CC] hover:bg-[#003E9C] px-4 py-2 text-[12px] font-extrabold text-white shadow-xs transition"
                        >
                            <span>+ Tambah Helpdesk</span>
                        </a>
                    </div>

                    <!-- Search -->
                    <form method="GET" action="{{ route('super-admin.helpdesk') }}">
                        <input type="hidden" name="status" value="{{ $filter }}">
                        <input
                            type="text"
                            name="q"
                            value="{{ $search }}"
                            placeholder="🔍 Cari judul atau kontak..."
                            class="w-full rounded-2xl border border-[#E2E8F0] bg-white py-3 px-4 text-[13px] text-[#161A30] placeholder:text-[#94A3B8] focus:border-[#0052CC] focus:outline-none shadow-2xs"
                        >
                    </form>

                    <!-- Filter Pills -->
                    <div class="flex items-center gap-2">
                        <a
                            href="{{ route('super-admin.helpdesk', ['status' => 'semua', 'q' => $search]) }}"
                            class="rounded-full px-3.5 py-1.5 text-[12px] font-bold inline-flex items-center gap-1.5 {{ $filter === 'semua' ? 'bg-[#0052CC] text-white' : 'bg-white border border-[#E2E8F0] text-[#475569]' }}"
                        >
                            <span>Semua</span>
                            <span class="rounded-full px-1.5 text-[10.5px] {{ $filter === 'semua' ? 'bg-white/25' : 'bg-[#ECECFF] text-[#003BA5]' }}">{{ $counts['semua'] }}</span>
                        </a>
                        <a
                            href="{{ route('super-admin.helpdesk', ['status' => 'aktif', 'q' => $search]) }}"
                            class="rounded-full px-3.5 py-1.5 text-[12px] font-bold inline-flex items-center gap-1.5 {{ $filter === 'aktif' ? 'bg-[#0052CC] text-white' : 'bg-white border border-[#E2E8F0] text-[#475569]' }}"
                        >
                            <span>Aktif</span>
                            <span class="text-[10.5px]">{{ $counts['aktif'] }}</span>
                        </a>
                        <a
                            href="{{ route('super-admin.helpdesk', ['status' => 'nonaktif', 'q' => $search]) }}"
                            class="rounded-full px-3.5 py-1.5 text-[12px] font-bold inline-flex items-center gap-1.5 {{ $filter === 'nonaktif' ? 'bg-[#0052CC] text-white' : 'bg-white border border-[#E2E8F0] text-[#475569]' }}"
                        >
                            <span>Nonaktif</span>
                            <span class="text-[10.5px]">{{ $counts['nonaktif'] }}</span>
                        </a>
                    </div>

                    <!-- Cards -->
                    <div class="space-y-3">
                        @forelse ($contacts as $cp)
                            <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)] space-y-3">
                                <div class="flex items-start gap-3">
                                    <div class="w-10 h-10 rounded-xl bg-[#E8F0FE] text-[#003BA5] flex items-center justify-center shrink-0">
                                        🎧
                                    </div>
                                    <div>
                                        <h3 class="text-[14.5px] font-extrabold text-[#161A30]">{{ $cp->name }}</h3>
                                        <div class="mt-1 flex items-center gap-1.5">
                                            <span class="rounded-md bg-[#E8F0FE] px-2 py-0.5 text-[10px] font-bold text-[#0052CC]">
                                                {{ $cp->role_label === 'staf_keuangan' ? 'Pembayaran' : 'Akun & Berkas' }}
                                            </span>
                                            <span class="rounded-md px-2 py-0.5 text-[10px] font-extrabold {{ $cp->is_active ? 'bg-[#D1FAE5] text-[#059669]' : 'bg-[#F1F5F9] text-[#64748B]' }}">
                                                {{ $cp->is_active ? 'Aktif' : 'Nonaktif' }}
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <div class="space-y-1 text-[12px] text-[#64748B]">
                                    <p>WA {{ $cp->phone }} &bull; {{ $cp->email }}</p>
                                    <p>Sen-Jum, 08.00-16.00 WIB</p>
                                </div>

                                <div class="grid grid-cols-2 gap-2.5 pt-1">
                                    <a
                                        href="{{ route('super-admin.helpdesk', ['edit' => $cp->cp_id]) }}"
                                        class="rounded-full border border-[#E2E8F0] bg-white hover:bg-[#F8FAFC] py-2 text-[12.5px] font-bold text-[#161A30] flex items-center justify-center gap-1.5"
                                    >
                                        <span>✎ Edit</span>
                                    </a>
                                    <form method="POST" action="{{ route('super-admin.contacts.delete', $cp->cp_id) }}" onsubmit="return confirm('Hapus layanan {{ $cp->name }}?')">
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
                        @empty
                            <div class="rounded-2xl bg-white p-8 text-center text-[13px] text-[#64748B]">
                                Belum ada layanan helpdesk.
                            </div>
                        @endforelse
                    </div>
                @endif
            </main>

            <x-super-admin-nav active="helpdesk" />
        </div>
    </div>
</x-layouts.app>
