<?php

namespace App\Http\Controllers;

use App\Enums\UserRole;
use App\Mail\PasswordResetOtpMail;
use App\Models\AuditLog;
use App\Models\User;
use Illuminate\Contracts\View\View;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Throwable;

class RegisterMabaController extends Controller
{
    /**
     * Display the Maba registration and OTP verification page.
     */
    public function showRegisterForm(Request $request): View
    {
        $pendingEmail = (string) $request->session()->get('register_maba_email', '');
        $payload = $pendingEmail !== '' ? Cache::get($this->cacheKey($pendingEmail)) : null;

        if (! is_array($payload)) {
            $pendingEmail = '';
        }

        return view('auth.register', [
            'pendingEmail' => $pendingEmail,
            'otpSent' => $pendingEmail !== '',
            'devOtp' => is_array($payload) ? ($payload['dev_otp'] ?? null) : null,
        ]);
    }

    /**
     * Step 1: Validate Maba email & password and send 6-digit verification OTP.
     */
    public function sendOtp(Request $request): RedirectResponse
    {
        $validated = $request->validate(
            [
                'email' => ['required', 'string', 'email', 'max:150', 'unique:users,email'],
                'password' => ['required', 'string', 'min:6'],
            ],
            [
                'email.required' => 'Alamat Gmail / Email aktif wajib diisi.',
                'email.email' => 'Format alamat email tidak valid.',
                'email.unique' => 'Email ini sudah terdaftar. Silakan langsung masuk di halaman Login.',
                'password.required' => 'Kata sandi akun wajib dibuat.',
                'password.min' => 'Kata sandi minimal 6 karakter.',
            ]
        );

        $email = trim(strtolower((string) $validated['email']));
        $password = (string) $validated['password'];

        $otpCode = str_pad((string) random_int(0, 999999), 6, '0', STR_PAD_LEFT);
        $isLogMailer = in_array((string) config('mail.default'), ['log', 'array'], true);

        $cacheData = [
            'email' => $email,
            'password_hash' => Hash::make($password),
            'otp_hash' => Hash::make($otpCode),
            'attempts' => 0,
            'dev_otp' => $isLogMailer ? $otpCode : null,
        ];

        Cache::put($this->cacheKey($email), $cacheData, now()->addMinutes(10));

        try {
            Mail::to($email)->send(new PasswordResetOtpMail(
                otpCode: $otpCode,
                recipientEmail: $email,
                expiresInMinutes: 10,
            ));
        } catch (Throwable) {
            $cacheData['dev_otp'] = $otpCode;
            Cache::put($this->cacheKey($email), $cacheData, now()->addMinutes(10));
        }

        $request->session()->put('register_maba_email', $email);

        AuditLog::record(
            actor: $email,
            action: 'REGISTER_OTP_SENT',
            object: 'Daftar Akun Maba',
            result: 'Kode verifikasi OTP pendaftaran Maba dikirim ke email'
        );

        return redirect()
            ->route('register')
            ->with('status', 'Kode verifikasi 6-digit telah dikirim ke ' . $email . '.');
    }

    /**
     * Resend a fresh 6-digit OTP to the pending registration email.
     */
    public function resendOtp(Request $request): RedirectResponse
    {
        $email = (string) $request->session()->get('register_maba_email', '');
        $payload = $email !== '' ? Cache::get($this->cacheKey($email)) : null;

        if ($email === '' || ! is_array($payload)) {
            return redirect()
                ->route('register')
                ->withErrors(['email' => 'Sesi pendaftaran berakhir. Silakan isi kembali email dan kata sandi Anda.']);
        }

        $otpCode = str_pad((string) random_int(0, 999999), 6, '0', STR_PAD_LEFT);
        $isLogMailer = in_array((string) config('mail.default'), ['log', 'array'], true);

        $payload['otp_hash'] = Hash::make($otpCode);
        $payload['attempts'] = 0;
        $payload['dev_otp'] = $isLogMailer ? $otpCode : null;

        Cache::put($this->cacheKey($email), $payload, now()->addMinutes(10));

        try {
            Mail::to($email)->send(new PasswordResetOtpMail(
                otpCode: $otpCode,
                recipientEmail: $email,
                expiresInMinutes: 10,
            ));
        } catch (Throwable) {
            $payload['dev_otp'] = $otpCode;
            Cache::put($this->cacheKey($email), $payload, now()->addMinutes(10));
        }

        return redirect()
            ->route('register')
            ->with('status', 'Kode OTP baru telah dikirim ulang ke ' . $email . '.');
    }

    /**
     * Step 2: Verify the 6-digit OTP, create the verified Maba user, and log in.
     */
    public function verifyAndLogin(Request $request): RedirectResponse
    {
        $email = (string) $request->session()->get('register_maba_email', '');
        $payload = $email !== '' ? Cache::get($this->cacheKey($email)) : null;

        if ($email === '' || ! is_array($payload)) {
            return redirect()
                ->route('register')
                ->withErrors(['email' => 'Silakan masukkan email dan klik Kirim Kode Verifikasi terlebih dahulu (Langkah 1).']);
        }

        $otpInput = (string) $request->input('otp', '');
        if ($otpInput === '' && is_array($request->input('otp_digits'))) {
            $otpInput = implode('', array_map('strval', $request->input('otp_digits')));
        }
        $otpInput = preg_replace('/\D+/', '', $otpInput) ?? '';

        if (strlen($otpInput) !== 6) {
            return back()->withErrors([
                'otp' => 'Masukkan lengkap 6 angka kode verifikasi OTP Anda.',
            ]);
        }

        if (! Hash::check($otpInput, (string) $payload['otp_hash'])) {
            $payload['attempts'] = ((int) ($payload['attempts'] ?? 0)) + 1;

            if ($payload['attempts'] >= 5) {
                Cache::forget($this->cacheKey($email));
                $request->session()->forget('register_maba_email');

                return redirect()
                    ->route('register')
                    ->withErrors(['email' => 'Terlalu banyak percobaan OTP yang salah. Silakan kirim ulang kode verifikasi.']);
            }

            Cache::put($this->cacheKey($email), $payload, now()->addMinutes(10));

            return back()->withErrors([
                'otp' => 'Kode OTP tidak sesuai. Sisa percobaan: ' . (5 - $payload['attempts']) . ' kali.',
            ]);
        }

        if (User::query()->where('email', $email)->exists()) {
            Cache::forget($this->cacheKey($email));
            $request->session()->forget('register_maba_email');

            return redirect()
                ->route('login')
                ->with('status', 'Akun sudah terdaftar. Silakan masuk.');
        }

        /** @var User $user */
        $user = User::query()->create([
            'email' => $email,
            'password_hash' => $payload['password_hash'],
            'role' => UserRole::Maba,
            'is_verified' => true,
        ]);

        Cache::forget($this->cacheKey($email));
        $request->session()->forget('register_maba_email');

        AuditLog::record(
            actor: $user->email,
            action: 'REGISTER_MABA',
            object: 'Daftar Akun Maba',
            result: 'Berhasil membuat dan memverifikasi akun Maba baru via OTP'
        );

        Auth::login($user);
        $request->session()->regenerate();

        return redirect()->route('maba.dashboard');
    }

    /**
     * Build the cache key for pending Maba registration OTP.
     */
    private function cacheKey(string $email): string
    {
        return 'pmb_maba_reg_otp:' . sha1($email);
    }
}
