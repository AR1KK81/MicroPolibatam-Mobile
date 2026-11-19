@props(['class' => 'w-11 h-7'])

<svg {{ $attributes->merge(['class' => $class]) }} viewBox="0 0 68 36" fill="none" xmlns="http://www.w3.org/2000/svg" aria-label="Logo MP MicroPolibatam">
    <!-- Speed stripes on left side of M -->
    <path d="M3 14.5L9.5 10.5V13.4L3 17.4V14.5Z" fill="#0B5ED7" />
    <path d="M3 19.2L9.5 15.2V18.1L3 22.1V19.2Z" fill="#0B5ED7" />
    <path d="M3 23.9L9.5 19.9V22.8L3 26.8V23.9Z" fill="#0B5ED7" />

    <!-- Bold M -->
    <path d="M11.5 27V9H17.4L23.2 19.2L29 9H34.9V27H29.6V17.1L24.8 25.3H21.6L16.8 17.1V27H11.5Z" fill="#0A4DA6" />

    <!-- Bold P -->
    <path fill-rule="evenodd" clip-rule="evenodd" d="M37.5 9H49.2C54.1 9 57.3 11.8 57.3 15.9C57.3 20 54.1 22.8 49.2 22.8H43.1V27H37.5V9ZM43.1 13.4V18.4H48.5C50.4 18.4 51.6 17.4 51.6 15.9C51.6 14.4 50.4 13.4 48.5 13.4H43.1Z" fill="#172554" />
</svg>

