<?php

use App\Http\Controllers\AdminPortalController;
use App\Http\Controllers\Api\PmbApiController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\KeuanganPortalController;
use App\Http\Controllers\MabaPortalController;
use App\Http\Controllers\PasswordResetOtpController;
use App\Http\Controllers\RegisterMabaController;
use App\Http\Controllers\SuperAdminPortalController;
use Illuminate\Contracts\View\View;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/', function (Request $request): RedirectResponse {
    if ($request->user() !== null) {
        return redirect()->route($request->user()->dashboardRoute());
    }

    return redirect()->route('login');
});

Route::get('/landing', fn (): View => view('landing'))->name('landing');

Route::prefix('api/pmb')->group(function (): void {
    Route::get('/bootstrap', [PmbApiController::class, 'bootstrap'])->name('api.pmb.bootstrap');
    Route::post('/login', [PmbApiController::class, 'login'])->name('api.pmb.login');
});

Route::middleware('guest')->group(function (): void {
    Route::get('/login', [AuthController::class, 'showLogin'])->name('login');
    Route::post('/login', [AuthController::class, 'login'])->name('login.attempt');

    Route::get('/register', [RegisterMabaController::class, 'showRegisterForm'])->name('register');
    Route::post('/register/send-otp', [RegisterMabaController::class, 'sendOtp'])->name('register.otp.send');
    Route::post('/register/resend-otp', [RegisterMabaController::class, 'resendOtp'])->name('register.otp.resend');
    Route::post('/register/verify', [RegisterMabaController::class, 'verifyAndLogin'])->name('register.otp.verify');

    Route::get('/forgot-password', [PasswordResetOtpController::class, 'showRequestForm'])->name('password.otp.request');
    Route::post('/forgot-password/send-otp', [PasswordResetOtpController::class, 'sendOtp'])->name('password.otp.send');
    Route::get('/forgot-password/verify', [PasswordResetOtpController::class, 'showVerifyForm'])->name('password.otp.verify.form');
    Route::post('/forgot-password/verify', [PasswordResetOtpController::class, 'verifyOtp'])->name('password.otp.verify');
    Route::get('/forgot-password/reset', [PasswordResetOtpController::class, 'showResetForm'])->name('password.otp.reset.form');
    Route::post('/forgot-password/reset', [PasswordResetOtpController::class, 'resetPassword'])->name('password.otp.reset');
});

Route::middleware('auth')->group(function (): void {
    Route::post('/logout', [AuthController::class, 'logout'])->name('logout');
    Route::post('/account/change-password', [AuthController::class, 'changePassword'])->name('account.password.update');
});

/*
|--------------------------------------------------------------------------
| Bagian 1: Mahasiswa / Calon Maba (role:maba)
|--------------------------------------------------------------------------
*/
Route::middleware(['auth', 'role:maba'])->prefix('maba')->name('maba.')->group(function (): void {
    Route::get('/dashboard', [MabaPortalController::class, 'beranda'])->name('dashboard');
    Route::get('/formulir', [MabaPortalController::class, 'formulir'])->name('formulir');
    Route::post('/formulir/biodata', [MabaPortalController::class, 'saveBiodata'])->name('formulir.biodata');
    Route::post('/formulir/dokumen', [MabaPortalController::class, 'uploadDocument'])->name('formulir.dokumen');
    Route::post('/formulir/pembayaran', [MabaPortalController::class, 'uploadPayment'])->name('formulir.pembayaran');
    Route::get('/status', [MabaPortalController::class, 'status'])->name('status');
    Route::get('/profil', [MabaPortalController::class, 'profil'])->name('profil');
});

/*
|--------------------------------------------------------------------------
| Bagian 2: Admin Akademik / Registrasi (role:admin)
|--------------------------------------------------------------------------
*/
Route::middleware(['auth', 'role:admin'])->prefix('admin')->name('admin.')->group(function (): void {
    Route::get('/dashboard', [AdminPortalController::class, 'dashboard'])->name('dashboard');
    Route::get('/registrations/{registrationId}', [AdminPortalController::class, 'showVerification'])->name('registrations.show');
    Route::post('/registrations/{registrationId}/verify', [AdminPortalController::class, 'processVerification'])->name('registrations.verify');
    Route::get('/riwayat', [AdminPortalController::class, 'riwayat'])->name('riwayat');
    Route::get('/riwayat/csv', [AdminPortalController::class, 'exportCsv'])->name('riwayat.csv');
    Route::get('/profil', [AdminPortalController::class, 'profil'])->name('profil');
});

/*
|--------------------------------------------------------------------------
| Bagian 3: Staf Keuangan (role:keuangan)
|--------------------------------------------------------------------------
*/
Route::middleware(['auth', 'role:keuangan'])->prefix('keuangan')->name('keuangan.')->group(function (): void {
    Route::get('/dashboard', [KeuanganPortalController::class, 'dashboard'])->name('dashboard');
    Route::get('/payments/{paymentId}', [KeuanganPortalController::class, 'showPayment'])->name('payments.show');
    Route::post('/payments/{paymentId}/verify', [KeuanganPortalController::class, 'processPayment'])->name('payments.verify');
    Route::get('/riwayat', [KeuanganPortalController::class, 'riwayat'])->name('riwayat');
    Route::get('/riwayat/csv', [KeuanganPortalController::class, 'exportCsv'])->name('riwayat.csv');
    Route::get('/profil', [KeuanganPortalController::class, 'profil'])->name('profil');
});

/*
|--------------------------------------------------------------------------
| Bagian 4: Super Admin (role:super_admin) — 5 Menu Utama Sesuai Figma
|--------------------------------------------------------------------------
*/
Route::middleware(['auth', 'role:super_admin'])->prefix('super-admin')->name('super-admin.')->group(function (): void {
    // 1. Beranda
    Route::get('/dashboard', [SuperAdminPortalController::class, 'dashboard'])->name('dashboard');

    // 2. Helpdesk (contact_persons)
    Route::get('/helpdesk', [SuperAdminPortalController::class, 'helpdesk'])->name('helpdesk');
    Route::post('/helpdesk', [SuperAdminPortalController::class, 'saveContact'])->name('helpdesk.save');
    Route::post('/contacts', [SuperAdminPortalController::class, 'saveContact'])->name('contacts.store');
    Route::delete('/contacts/{cpId}', [SuperAdminPortalController::class, 'deleteContact'])->name('contacts.delete');

    // 3. Nomor Rekening (rekening)
    Route::get('/rekening', [SuperAdminPortalController::class, 'rekening'])->name('rekening');
    Route::post('/rekening', [SuperAdminPortalController::class, 'saveRekening'])->name('rekening.save');
    Route::post('/rekening/{rekeningId}', [SuperAdminPortalController::class, 'saveRekening'])->name('rekening.update');
    Route::delete('/rekening/{rekeningId}', [SuperAdminPortalController::class, 'deleteRekening'])->name('rekening.delete');

    // 4. Jurusan & Peminatan (tracks)
    Route::get('/jurusan', [SuperAdminPortalController::class, 'jurusan'])->name('jurusan');
    Route::post('/tracks', [SuperAdminPortalController::class, 'saveTrack'])->name('tracks.store');
    Route::post('/tracks/{trackId}/toggle', [SuperAdminPortalController::class, 'toggleTrack'])->name('tracks.toggle');
    Route::delete('/tracks/{trackId}', [SuperAdminPortalController::class, 'deleteTrack'])->name('tracks.delete');

    // 5. Manajemen User (users)
    Route::get('/users', [SuperAdminPortalController::class, 'users'])->name('users');
    Route::post('/users', [SuperAdminPortalController::class, 'storeUser'])->name('users.store');
    Route::delete('/users/{userId}', [SuperAdminPortalController::class, 'deleteUser'])->name('users.delete');

    // Tambahan: Master Alias, Audit Log & Profil
    Route::get('/master', [SuperAdminPortalController::class, 'master'])->name('master');
    Route::get('/audit', [SuperAdminPortalController::class, 'audit'])->name('audit');
    Route::get('/audit/csv', [SuperAdminPortalController::class, 'exportAuditCsv'])->name('audit.csv');
    Route::get('/profil', [SuperAdminPortalController::class, 'profil'])->name('profil');
});
