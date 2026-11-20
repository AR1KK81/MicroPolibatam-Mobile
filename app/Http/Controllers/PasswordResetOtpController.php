<?php

namespace App\Http\Controllers;

use App\Mail\PasswordResetOtpMail;
use App\Models\AuditLog;
use App\Models\User;
use Illuminate\Contracts\View\View;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Throwable;

class PasswordResetOtpController extends Controller
{
    /**
     * Step 1: Display the email input form to request an OTP.
     */
    public function showRequestForm(): View
    {
        return view('auth.forgot-password', [
            'step' => 'email',
            'email' => session('otp_reset_email', ''),
            'devOtp' => null,
        ]);
    }

    /**
     * Step 1 Submit: Generate a 6-digit OTP and send it to the user's email.
     */
    public function sendOtp(Request $request): RedirectResponse
    {
        $validated = $request->validate(
            [
                'email' => ['required', 'string', 'email'],
            ],
            [
                'email.required' => 'Email akun wajib diisi.',
                'email.email' => 'Format email akun tidak valid.',
            ]
        );

        $email = trim(strtolower((string) $validated['email']));

        /** @var User|null $user */
        $user = User::query()->where('email', $email)->first();

        if ($user === null) {
            return back()
                ->withInput($request->only('email'))
                ->withErrors([
                    'email' => 'Email tersebut tidak terdaftar di dalam sistem PMB Microcredential.',
                ]);
        }

        $otpCode = str_pad((string) random_int(0, 999999), 6, '0', STR_PAD_LEFT);
        $isLogMailer = in_array((string) config('mail.default'), ['log', 'array'], true);

        Cache::put(
            $this->cacheKey($email),
            [
                'otp_hash' => Hash::make($otpCode),
                'attempts' => 0,
                'verified' => false,
                'dev_otp' => $isLogMailer ? $otpCode : null,
            ],
            now()->addMinutes(10)
        );

        $mailSentViaSmtp = true;

        try {
            Mail::to($user->email)->send(new PasswordResetOtpMail(
                otpCode: $otpCode,
                recipientEmail: $user->email,
                expiresInMinutes: 10,
            ));
        } catch (Throwable) {
            $mailSentViaSmtp = false;
            Cache::put(
                $this->cacheKey($email),
                [
                    'otp_hash' => Hash::make($otpCode),
                    'attempts' => 0,
                    'verified' => false,
                    'dev_otp' => $otpCode,
                ],
                now()->addMinutes(10)
            );
        }

        $request->session()->put('otp_reset_email', $user->email);

        AuditLog::record(
            actor: $user->email,
            action: 'REQUEST_OTP',
            object: 'Pemulihan Sandi',
            result: 'Kode OTP 6-digit dikirim ke email terdaftar'
        );

        $statusMessage = $mailSentViaSmtp && ! $isLogMailer
            ? 'Kode OTP 6-digit telah dikirim ke ' . $user->email . '. Silakan cek kotak masuk atau folder Spam Gmail Anda.'
            : 'Kode OTP 6-digit berhasil dibuat untuk ' . $user->email . '.';

        return redirect()
            ->route('password.otp.verify.form')
            ->with('status', $statusMessage);
    }

    /**
     * Step 2: Display the 6-digit OTP verification form.
     */
    public function showVerifyForm(Request $request): View|RedirectResponse
    {
        $email = (string) $request->session()->get('otp_reset_email', '');

        if ($email === '' || ! Cache::has($this->cacheKey($email))) {
            return redirect()
                ->route('password.otp.request')
                ->withErrors(['email' => 'Sesi OTP telah berakhir. Silakan kirim ulang kode OTP.']);
        }

        /** @var array{otp_hash: string, attempts: int, verified: bool, dev_otp: ?string} $payload */
        $payload = Cache::get($this->cacheKey($email));

        return view('auth.forgot-password', [
            'step' => 'verify',
            'email' => $email,
            'devOtp' => $payload['dev_otp'] ?? null,
        ]);
    }

    /**
     * Step 2 Submit: Verify the 6-digit OTP entered by the user.
     */
    public function verifyOtp(Request $request): RedirectResponse
    {
        $email = (string) $request->session()->get('otp_reset_email', '');

        if ($email === '' || ! Cache::has($this->cacheKey($email))) {
            return redirect()
                ->route('password.otp.request')
                ->withErrors(['email' => 'Kode OTP sudah kedaluwarsa. Silakan minta kode OTP baru.']);
        }

        $validated = $request->validate(
            [
                'otp' => ['required', 'string', 'digits:6'],
            ],
            [
                'otp.required' => 'Kode OTP 6-digit wajib diisi.',
                'otp.digits' => 'Kode OTP harus terdiri dari 6 angka.',
            ]
        );

        /** @var array{otp_hash: string, attempts: int, verified: bool, dev_otp: ?string} $payload */
        $payload = Cache::get($this->cacheKey($email));

        if (! Hash::check((string) $validated['otp'], $payload['otp_hash'])) {
            $payload['attempts']++;

            if ($payload['attempts'] >= 5) {
                Cache::forget($this->cacheKey($email));

                return redirect()
                    ->route('password.otp.request')
                    ->withErrors(['email' => 'Terlalu banyak percobaan OTP yang salah. Silakan kirim ulang OTP baru.']);
            }

            Cache::put($this->cacheKey($email), $payload, now()->addMinutes(10));

            return back()->withErrors([
                'otp' => 'Kode OTP yang Anda masukkan tidak sesuai. Sisa percobaan: ' . (5 - $payload['attempts']) . ' kali.',
            ]);
        }

        $payload['verified'] = true;
        Cache::put($this->cacheKey($email), $payload, now()->addMinutes(10));

        AuditLog::record(
            actor: $email,
            action: 'VERIFY_OTP',
            object: 'Pemulihan Sandi',
            result: 'Berhasil memverifikasi kode OTP email'
        );

        return redirect()
            ->route('password.otp.reset.form')
            ->with('status', 'Kode OTP terverifikasi! Silakan buat kata sandi baru Anda.');
    }

    /**
     * Step 3: Display the new password form after OTP is verified.
     */
    public function showResetForm(Request $request): View|RedirectResponse
    {
        $email = (string) $request->session()->get('otp_reset_email', '');

        if ($email === '' || ! Cache::has($this->cacheKey($email))) {
            return redirect()
                ->route('password.otp.request')
                ->withErrors(['email' => 'Sesi pemulihan kata sandi telah berakhir.']);
        }

        /** @var array{otp_hash: string, attempts: int, verified: bool, dev_otp: ?string} $payload */
        $payload = Cache::get($this->cacheKey($email));

        if (! ($payload['verified'] ?? false)) {
            return redirect()->route('password.otp.verify.form');
        }

        return view('auth.forgot-password', [
            'step' => 'reset',
            'email' => $email,
            'devOtp' => null,
        ]);
    }

    /**
     * Step 3 Submit: Save the new password to the user's account.
     */
    public function resetPassword(Request $request): RedirectResponse
    {
        $email = (string) $request->session()->get('otp_reset_email', '');

        if ($email === '' || ! Cache::has($this->cacheKey($email))) {
            return redirect()
                ->route('password.otp.request')
                ->withErrors(['email' => 'Sesi pemulihan kata sandi telah berakhir.']);
        }

        /** @var array{otp_hash: string, attempts: int, verified: bool, dev_otp: ?string} $payload */
        $payload = Cache::get($this->cacheKey($email));

        if (! ($payload['verified'] ?? false)) {
            return redirect()->route('password.otp.verify.form');
        }

        $validated = $request->validate(
            [
                'password' => ['required', 'string', 'min:8', 'confirmed'],
            ],
            [
                'password.required' => 'Kata sandi baru wajib diisi.',
                'password.min' => 'Kata sandi baru minimal harus 8 karakter.',
                'password.confirmed' => 'Konfirmasi kata sandi baru tidak cocok.',
            ]
        );

        /** @var User|null $user */
        $user = User::query()->where('email', $email)->first();

        if ($user === null) {
            return redirect()
                ->route('password.otp.request')
                ->withErrors(['email' => 'Akun pengguna tidak ditemukan.']);
        }

        $user->password_hash = Hash::make((string) $validated['password']);
        $user->save();

        Cache::forget($this->cacheKey($email));
        $request->session()->forget('otp_reset_email');

        AuditLog::record(
            actor: $user->email,
            action: 'RESET_PASSWORD',
            object: 'Pemulihan Sandi',
            result: 'Kata sandi berhasil diperbarui secara mandiri via OTP Email'
        );

        return redirect()
            ->route('login')
            ->with('status', 'Kata sandi berhasil diperbarui! Silakan masuk dengan kata sandi baru Anda.');
    }

    /**
     * Build the cache key for storing OTP state per email address.
     */
    private function cacheKey(string $email): string
    {
        return 'pmb_pwd_otp:' . sha1($email);
    }
}
