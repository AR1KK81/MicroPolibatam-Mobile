<?php

namespace App\Http\Controllers\Api;

use App\Enums\UserRole;
use App\Http\Controllers\Controller;
use App\Models\AuditLog;
use App\Models\ContactPerson;
use App\Models\Document;
use App\Models\Payment;
use App\Models\Registration;
use App\Models\Rekening;
use App\Models\Track;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class PmbApiController extends Controller
{
    /**
     * GET /api/pmb/bootstrap — Return all 8 MySQL tables data for the Flutter mobile frontend.
     */
    public function bootstrap(): JsonResponse
    {
        return response()->json([
            'status' => 'ok',
            'users' => User::query()->with(['registration'])->orderBy('user_id')->get()->map(fn (User $u): array => [
                'user_id' => $u->user_id,
                'email' => $u->email,
                'name' => $u->registration?->full_name ?? ucfirst(strtok($u->email, '@') ?: 'User'),
                'role' => $u->role instanceof UserRole ? $u->role->value : (string) $u->role,
                'is_verified' => (bool) $u->is_verified,
            ]),
            'tracks' => Track::query()->orderBy('track_id')->get(),
            'rekenings' => Rekening::query()->orderBy('rekening_id')->get(),
            'contact_persons' => ContactPerson::query()->orderBy('cp_id')->get(),
            'registrations' => Registration::query()
                ->with(['user', 'track', 'documents', 'payment.rekening'])
                ->orderByDesc('registration_id')
                ->get()
                ->map(fn (Registration $r): array => [
                    'registration_id' => $r->registration_id,
                    'reg_code' => $r->registrationCode(),
                    'user_id' => $r->user_id,
                    'email' => $r->user?->email,
                    'track_id' => $r->track_id,
                    'department_name' => $r->track?->department_name ?? 'Teknik Informatika',
                    'study_program_name' => $r->track?->study_program_name ?? 'TRPL',
                    'track_name' => $r->track?->track_name ?? 'Microcredential',
                    'nik' => $r->readableNik(),
                    'full_name' => $r->full_name,
                    'birth_place' => $r->birth_place,
                    'birth_date' => $r->birth_date?->format('Y-m-d'),
                    'origin_school' => $r->origin_school,
                    'address' => $r->address,
                    'status' => $r->status,
                    'admin_verification_notes' => $r->admin_verification_notes,
                    'documents' => $r->documents,
                    'payment' => $r->payment,
                ]),
            'payments' => Payment::query()->with(['registration.track', 'rekening'])->orderByDesc('payment_id')->get(),
            'audit_logs' => AuditLog::query()->orderByDesc('audit_id')->limit(50)->get(),
        ]);
    }

    /**
     * POST /api/pmb/login — Unified 1-door login for all 4 roles from Flutter app.
     */
    public function login(Request $request): JsonResponse
    {
        $email = trim(strtolower((string) $request->input('email', '')));
        $password = (string) $request->input('password', '');

        /** @var User|null $user */
        $user = User::query()->with(['registration'])->where('email', $email)->first();

        if ($user === null || ! Hash::check($password, (string) $user->getAuthPassword())) {
            return response()->json([
                'status' => 'error',
                'message' => 'Email akun atau kata sandi yang Anda masukkan salah.',
            ], 401);
        }

        $roleValue = $user->role instanceof UserRole ? $user->role->value : (string) $user->role;

        AuditLog::record($user->email, 'LOGIN_MOBILE', 'Flutter App', 'Berhasil login sebagai ' . $roleValue);

        return response()->json([
            'status' => 'ok',
            'user' => [
                'user_id' => $user->user_id,
                'email' => $user->email,
                'name' => $user->registration?->full_name ?? ucfirst(strtok($user->email, '@') ?: 'User'),
                'role' => $roleValue,
                'is_verified' => (bool) $user->is_verified,
            ],
        ]);
    }
}
