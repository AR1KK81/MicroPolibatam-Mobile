<?php

namespace App\Enums;

enum UserRole: string
{
    case Maba = 'maba';
    case Admin = 'admin';
    case Keuangan = 'keuangan';
    case SuperAdmin = 'super_admin';

    /**
     * Get the human-readable role label in Bahasa Indonesia.
     */
    public function label(): string
    {
        return match ($this) {
            self::Maba => 'Calon Mahasiswa Baru',
            self::Admin => 'Admin Akademik',
            self::Keuangan => 'Staf Keuangan',
            self::SuperAdmin => 'Super Admin',
        };
    }

    /**
     * Get the named dashboard route for this role.
     */
    public function dashboardRoute(): string
    {
        return match ($this) {
            self::Maba => 'maba.dashboard',
            self::Admin => 'admin.dashboard',
            self::Keuangan => 'keuangan.dashboard',
            self::SuperAdmin => 'super-admin.dashboard',
        };
    }
}

