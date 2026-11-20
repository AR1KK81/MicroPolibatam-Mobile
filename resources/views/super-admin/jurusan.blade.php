<x-layouts.app title="Jurusan & Peminatan — Super Admin PMB Polibatam">
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
                    <!-- Tambah / Edit Jurusan & Peminatan Screen (Image 8 Frame 3) -->
                    <div class="flex items-center justify-between">
                        <div>
                            <h1 class="text-[20px] font-extrabold text-[#161A30]">
                                {{ $editingTrack ? 'Edit Jurusan & Peminatan' : 'Tambah Jurusan / Peminatan' }}
                            </h1>
                            <p class="text-[12px] text-[#64748B]">Atur kuota dan peminatan</p>
                        </div>
                        <a
                            href="{{ route('super-admin.jurusan') }}"
                            class="w-9 h-9 rounded-full bg-white border border-[#E2E8F0] flex items-center justify-center text-[#434655] font-bold"
                        >
                            &#10005;
                        </a>
                    </div>

                    <form method="POST" action="{{ route('super-admin.tracks.store') }}" class="space-y-3.5">
                        @csrf
                        @if ($editingTrack)
                            <input type="hidden" name="track_id" value="{{ $editingTrack->track_id }}">
                        @endif

                        <div>
                            <label class="block text-[12px] font-bold text-[#64748B] mb-1.5">Nama Jurusan</label>
                            <input
                                type="text"
                                name="department_name"
                                required
                                value="{{ old('department_name', $editingTrack?->department_name ?: $prefillDept) }}"
                                placeholder="Contoh: Teknik Informatika"
                                class="w-full rounded-2xl border border-[#E2E8F0] bg-white px-4 py-3 text-[13.5px] font-semibold text-[#161A30] focus:border-[#0052CC] focus:outline-none"
                            >
                        </div>

                        <div>
                            <label class="block text-[12px] font-bold text-[#64748B] mb-1.5">Program Studi Terapan</label>
                            <input
                                type="text"
                                name="study_program_name"
                                required
                                value="{{ old('study_program_name', $editingTrack?->study_program_name) }}"
                                placeholder="Contoh: Teknologi Rekayasa Perangkat Lunak (TRPL)"
                                class="w-full rounded-2xl border border-[#E2E8F0] bg-white px-4 py-3 text-[13.5px] font-semibold text-[#161A30] focus:border-[#0052CC] focus:outline-none"
                            >
                        </div>

                        <div>
                            <label class="block text-[12px] font-bold text-[#64748B] mb-1.5">Nama Peminatan / Track Microcredential</label>
                            <input
                                type="text"
                                name="track_name"
                                required
                                value="{{ old('track_name', $editingTrack?->track_name) }}"
                                placeholder="Contoh: Microcredential Mobile & Web Dev"
                                class="w-full rounded-2xl border border-[#E2E8F0] bg-white px-4 py-3 text-[13.5px] font-semibold text-[#161A30] focus:border-[#0052CC] focus:outline-none"
                            >
                        </div>

                        <div class="rounded-2xl border border-[#E2E8F0] bg-white px-4 py-3.5 flex items-center justify-between">
                            <span class="text-[13px] font-bold text-[#161A30]">Jurusan aktif (tampil di pendaftaran)</span>
                            <input
                                type="checkbox"
                                name="is_active"
                                value="1"
                                {{ old('is_active', $editingTrack?->is_active ?? true) ? 'checked' : '' }}
                                class="w-5 h-5 accent-[#0052CC] rounded"
                            >
                        </div>

                        <div class="pt-2 grid {{ $editingTrack ? 'grid-cols-2' : 'grid-cols-1' }} gap-2.5">
                            <button
                                type="submit"
                                class="rounded-full bg-[#0052CC] hover:bg-[#003E9C] py-3.5 text-[13.5px] font-extrabold text-white flex items-center justify-center gap-1.5 shadow-sm cursor-pointer"
                            >
                                <span>&#10003; Simpan</span>
                            </button>

                            @if ($editingTrack)
                                <button
                                    type="button"
                                    onclick="if (confirm('Hapus peminatan ini?')) document.getElementById('deleteTrackForm').submit();"
                                    class="rounded-full border border-red-300 bg-white hover:bg-red-50 py-3.5 text-[13px] font-extrabold text-[#DC2626] flex items-center justify-center gap-1.5 cursor-pointer"
                                >
                                    <span>🗑️ Hapus</span>
                                </button>
                            @endif
                        </div>
                    </form>

                    @if ($editingTrack)
                        <form id="deleteTrackForm" method="POST" action="{{ route('super-admin.tracks.delete', $editingTrack->track_id) }}" class="hidden">
                            @csrf
                            @method('DELETE')
                        </form>
                    @endif
                @else
                    <!-- Jurusan & Peminatan List Screen (Image 8 Frame 2) -->
                    <div class="flex items-start justify-between">
                        <div>
                            <span class="inline-block rounded-full bg-[#DCE9FF] px-2.5 py-0.5 text-[10px] font-extrabold text-[#003BA5] uppercase">
                                🎓 AKADEMIK
                            </span>
                            <h1 class="mt-1.5 text-[22px] font-extrabold text-[#161A30] leading-tight">Jurusan &amp; Peminatan</h1>
                            <p class="text-[12px] text-[#64748B]">{{ $counts['departments'] }} jurusan &bull; {{ $counts['semua'] }} peminatan</p>
                        </div>
                        <a
                            href="{{ route('super-admin.jurusan', ['create' => 1]) }}"
                            class="w-9 h-9 rounded-full bg-white border border-[#E2E8F0] flex items-center justify-center text-[#161A30] font-bold text-lg shadow-2xs"
                        >
                            +
                        </a>
                    </div>

                    <div>
                        <a
                            href="{{ route('super-admin.jurusan', ['create' => 1]) }}"
                            class="inline-flex items-center gap-1.5 rounded-full bg-[#0052CC] hover:bg-[#003E9C] px-4 py-2 text-[12px] font-extrabold text-white shadow-xs transition"
                        >
                            <span>+ Tambah Jurusan</span>
                        </a>
                    </div>

                    <!-- Search -->
                    <form method="GET" action="{{ route('super-admin.jurusan') }}">
                        <input type="hidden" name="status" value="{{ $filter }}">
                        <input
                            type="text"
                            name="q"
                            value="{{ $search }}"
                            placeholder="🔍 Cari jurusan atau peminatan..."
                            class="w-full rounded-2xl border border-[#E2E8F0] bg-white py-3 px-4 text-[13px] text-[#161A30] placeholder:text-[#94A3B8] focus:border-[#0052CC] focus:outline-none shadow-2xs"
                        >
                    </form>

                    <!-- Filter Pills -->
                    <div class="flex items-center gap-2">
                        <a
                            href="{{ route('super-admin.jurusan', ['status' => 'semua', 'q' => $search]) }}"
                            class="rounded-full px-3.5 py-1.5 text-[12px] font-bold inline-flex items-center gap-1.5 {{ $filter === 'semua' ? 'bg-[#0052CC] text-white' : 'bg-white border border-[#E2E8F0] text-[#475569]' }}"
                        >
                            <span>Semua</span>
                            <span class="rounded-full px-1.5 text-[10.5px] {{ $filter === 'semua' ? 'bg-white/25' : 'bg-[#ECECFF] text-[#003BA5]' }}">{{ $counts['semua'] }}</span>
                        </a>
                        <a
                            href="{{ route('super-admin.jurusan', ['status' => 'aktif', 'q' => $search]) }}"
                            class="rounded-full px-3.5 py-1.5 text-[12px] font-bold {{ $filter === 'aktif' ? 'bg-[#0052CC] text-white' : 'bg-white border border-[#E2E8F0] text-[#475569]' }}"
                        >
                            Aktif {{ $counts['aktif'] }}
                        </a>
                        <a
                            href="{{ route('super-admin.jurusan', ['status' => 'nonaktif', 'q' => $search]) }}"
                            class="rounded-full px-3.5 py-1.5 text-[12px] font-bold {{ $filter === 'nonaktif' ? 'bg-[#0052CC] text-white' : 'bg-white border border-[#E2E8F0] text-[#475569]' }}"
                        >
                            Nonaktif {{ $counts['nonaktif'] }}
                        </a>
                    </div>

                    <!-- Grouped Department Cards -->
                    <div class="space-y-3">
                        @forelse ($tracksByDept as $deptName => $deptTracks)
                            @php
                                $anyActive = $deptTracks->contains(fn ($t) => $t->is_active);
                            @endphp
                            <div class="rounded-2xl bg-white border border-[#ECEEF8] p-4 shadow-[0_2px_10px_rgba(15,23,42,0.025)] space-y-3">
                                <div class="flex items-start justify-between gap-2">
                                    <div class="flex items-center gap-3">
                                        <div class="w-10 h-10 rounded-xl bg-[#E8F0FE] text-[#003BA5] flex items-center justify-center shrink-0">
                                            🎓
                                        </div>
                                        <div>
                                            <h3 class="text-[15px] font-extrabold text-[#161A30]">{{ $deptName }}</h3>
                                            <p class="text-[11.5px] text-[#64748B]">Batch 1 2026 &bull; {{ $deptTracks->count() }} peminatan</p>
                                        </div>
                                    </div>
                                    <span class="rounded-md px-2 py-0.5 text-[10px] font-extrabold {{ $anyActive ? 'bg-[#D1FAE5] text-[#059669]' : 'bg-[#F1F5F9] text-[#64748B]' }}">
                                        {{ $anyActive ? 'Aktif' : 'Nonaktif' }}
                                    </span>
                                </div>

                                <!-- Sub-items (Peminatan) -->
                                <div class="space-y-2">
                                    @foreach ($deptTracks as $t)
                                        <div class="rounded-xl bg-[#F8FAFC] border border-[#EEF2FA] p-3 flex items-center justify-between gap-2">
                                            <div class="min-w-0">
                                                <p class="text-[13px] font-extrabold text-[#161A30] truncate">{{ $t->study_program_name }}</p>
                                                <p class="text-[11.5px] text-[#64748B] truncate">{{ $t->track_name }}</p>
                                            </div>
                                            <div class="flex items-center gap-2 shrink-0">
                                                <a
                                                    href="{{ route('super-admin.jurusan', ['edit' => $t->track_id]) }}"
                                                    class="text-[#64748B] hover:text-[#0052CC] p-1"
                                                    title="Edit Peminatan"
                                                >
                                                    ✎
                                                </a>
                                                <form method="POST" action="{{ route('super-admin.tracks.delete', $t->track_id) }}" onsubmit="return confirm('Hapus peminatan {{ $t->track_name }}?')">
                                                    @csrf
                                                    @method('DELETE')
                                                    <button type="submit" class="text-[#DC2626] hover:text-red-800 p-1 cursor-pointer" title="Hapus">
                                                        🗑️
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    @endforeach
                                </div>

                                <a
                                    href="{{ route('super-admin.jurusan', ['create' => 1, 'dept' => $deptName]) }}"
                                    class="block w-full rounded-xl bg-[#EBF1FF] hover:bg-[#DCE7FF] py-2.5 text-center text-[12px] font-extrabold text-[#0052CC] transition"
                                >
                                    + Tambah Peminatan
                                </a>
                            </div>
                        @empty
                            <div class="rounded-2xl bg-white p-8 text-center text-[13px] text-[#64748B]">
                                Belum ada data jurusan atau peminatan.
                            </div>
                        @endforelse
                    </div>
                @endif
            </main>

            <x-super-admin-nav active="jurusan" />
        </div>
    </div>
</x-layouts.app>
