@props(['active' => 'beranda'])

<nav class="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-[430px] bg-white border-t border-[#E6E8F2] px-2 py-2 flex items-center justify-around z-40">
    <a
        href="{{ route('super-admin.dashboard') }}"
        class="flex flex-col items-center gap-0.5 text-[10.5px] {{ $active === 'beranda' ? 'text-[#0052CC] font-extrabold' : 'text-[#64748B] font-semibold hover:text-[#0052CC]' }}"
    >
        <span class="w-8 h-6 rounded-full flex items-center justify-center {{ $active === 'beranda' ? 'bg-[#E8F0FE]' : '' }}">
            <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
                <polyline points="9 22 9 12 15 12 15 22" />
            </svg>
        </span>
        <span>Beranda</span>
    </a>

    <a
        href="{{ route('super-admin.helpdesk') }}"
        class="flex flex-col items-center gap-0.5 text-[10.5px] {{ $active === 'helpdesk' ? 'text-[#0052CC] font-extrabold' : 'text-[#64748B] font-semibold hover:text-[#0052CC]' }}"
    >
        <span class="w-8 h-6 rounded-full flex items-center justify-center {{ $active === 'helpdesk' ? 'bg-[#E8F0FE]' : '' }}">
            <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                <path d="M3 18v-6a9 9 0 0 1 18 0v6" />
                <path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3zM3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z" />
            </svg>
        </span>
        <span>Helpdesk</span>
    </a>

    <a
        href="{{ route('super-admin.rekening') }}"
        class="flex flex-col items-center gap-0.5 text-[10.5px] {{ $active === 'rekening' ? 'text-[#0052CC] font-extrabold' : 'text-[#64748B] font-semibold hover:text-[#0052CC]' }}"
    >
        <span class="w-8 h-6 rounded-full flex items-center justify-center {{ $active === 'rekening' ? 'bg-[#E8F0FE]' : '' }}">
            <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                <rect x="2" y="5" width="20" height="14" rx="2" />
                <line x1="2" y1="10" x2="22" y2="10" />
            </svg>
        </span>
        <span>Rekening</span>
    </a>

    <a
        href="{{ route('super-admin.jurusan') }}"
        class="flex flex-col items-center gap-0.5 text-[10.5px] {{ $active === 'jurusan' ? 'text-[#0052CC] font-extrabold' : 'text-[#64748B] font-semibold hover:text-[#0052CC]' }}"
    >
        <span class="w-8 h-6 rounded-full flex items-center justify-center {{ $active === 'jurusan' ? 'bg-[#E8F0FE]' : '' }}">
            <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                <rect x="4" y="4" width="16" height="16" rx="2" />
                <line x1="9" y1="9" x2="15" y2="9" />
                <line x1="9" y1="13" x2="15" y2="13" />
            </svg>
        </span>
        <span>Jurusan</span>
    </a>

    <a
        href="{{ route('super-admin.users') }}"
        class="flex flex-col items-center gap-0.5 text-[10.5px] {{ $active === 'user' ? 'text-[#0052CC] font-extrabold' : 'text-[#64748B] font-semibold hover:text-[#0052CC]' }}"
    >
        <span class="w-8 h-6 rounded-full flex items-center justify-center {{ $active === 'user' ? 'bg-[#E8F0FE]' : '' }}">
            <svg class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.1" stroke-linecap="round" stroke-linejoin="round">
                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                <circle cx="9" cy="7" r="4" />
                <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
                <path d="M16 3.13a4 4 0 0 1 0 7.75" />
            </svg>
        </span>
        <span>User</span>
    </a>
</nav>
