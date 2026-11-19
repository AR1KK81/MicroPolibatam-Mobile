<?php

namespace App\Http\Controllers;

use App\Models\AuditLog;
use App\Models\ContactPerson;
use App\Models\User;
use Illuminate\Contracts\View\View;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Throwable;

class AuthController extends Controller
{
    /**
     * Display the unified PMB Microcredential login page.
     */
    public function showLogin(Request $request): View|RedirectResponse
    {
        if ($request->user() !== null) {
            return redirect()->route($request->user()->dashboardRoute());
        }

        try {
            $contactPersons = ContactPerson::query()
                ->where('is_active', true)
                ->orderBy('cp_id')
                ->get();
        } catch (Throwable) {
            $contactPersons = collect();
        }

        return view('auth.login', [
            'contactPersons' => $contactPersons,
        ]);
    }

    /**
     * Authenticate user across all roles (maba, admin, keuangan, super_admin).
     */
    public function login(Request $request): RedirectResponse
    {
        $validated = $request->validate(
            [
                'email' => ['required', 'string', 'email'],
                'password' => ['required', 'string'],
            ],
            [
                'email.required' => 'Email akun wajib diisi.',
                'email.email' => 'Format email akun tidak valid.',
                'password.required' => 'Kata sandi wajib diisi.',
            ]
        );

        $email = trim(strtolower((string) $validated['email']));
        $password = (string) $validated['password'];

        /** @var User|null $user */
        $user = User::query()->where('email', $email)->first();

        if ($user === null || ! Hash::check($password, (string) $user->getAuthPassword())) {
            AuditLog::record(
                actor: $email,
                action: 'LOGIN_FAILED',
                object: 'Portal Auth',
                result: 'Gagal masuk: email atau kata sandi tidak sesuai'
            );

            return back()
                ->withInput($request->only('email', 'remember'))
                ->withErrors([
                    'email' => 'Email akun atau kata sandi yang Anda masukkan salah.',
                ]);
        }

        if (! $user->is_verified) {
            AuditLog::record(
                actor: $user->email,
                action: 'LOGIN_BLOCKED',
                object: 'Portal Auth',
                result: 'Akun belum terverifikasi'
            );

            return back()
                ->withInput($request->only('email', 'remember'))
                ->withErrors([
                    'email' => 'Akun Anda belum terverifikasi. Silakan hubungi Pusat Bantuan PMB.',
                ]);
        }

        if ($request->boolean('remember')) {
            config(['session.lifetime' => 60 * 24 * 14]);
        }

        Auth::login($user);
        $request->session()->regenerate();

        AuditLog::record(
            actor: $user->email,
            action: 'LOGIN',
            object: 'Portal Auth',
            result: 'Berhasil masuk sebagai ' . $user->role->value
        );

        return redirect()->intended(route($user->dashboardRoute()));
    }

    /**
     * Log the user out and invalidate the active session.
     */
    public function logout(Request $request): RedirectResponse
    {
        $user = $request->user();

        if ($user instanceof User) {
            AuditLog::record(
                actor: $user->email,
                action: 'LOGOUT',
                object: 'Portal Auth',
                result: 'Keluar dari sesi sistem'
            );
        }

        Auth::logout();

        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect()->route('login');
    }
}

