<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\DashboardController;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/', function (Request $request): RedirectResponse {
    if ($request->user() !== null) {
        return redirect()->route($request->user()->dashboardRoute());
    }

    return redirect()->route('login');
});

Route::middleware('guest')->group(function (): void {
    Route::get('/login', [AuthController::class, 'showLogin'])->name('login');
    Route::post('/login', [AuthController::class, 'login'])->name('login.attempt');
});

Route::post('/logout', [AuthController::class, 'logout'])
    ->middleware('auth')
    ->name('logout');

Route::middleware(['auth', 'role:maba'])->prefix('maba')->name('maba.')->group(function (): void {
    Route::get('/dashboard', [DashboardController::class, 'maba'])->name('dashboard');
});

Route::middleware(['auth', 'role:admin'])->prefix('admin')->name('admin.')->group(function (): void {
    Route::get('/dashboard', [DashboardController::class, 'admin'])->name('dashboard');
});

Route::middleware(['auth', 'role:keuangan'])->prefix('keuangan')->name('keuangan.')->group(function (): void {
    Route::get('/dashboard', [DashboardController::class, 'keuangan'])->name('dashboard');
});

Route::middleware(['auth', 'role:super_admin'])->prefix('super-admin')->name('super-admin.')->group(function (): void {
    Route::get('/dashboard', [DashboardController::class, 'superAdmin'])->name('dashboard');
});
