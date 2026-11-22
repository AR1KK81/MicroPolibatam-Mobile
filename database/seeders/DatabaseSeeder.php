<?php

namespace Database\Seeders;

use App\Enums\UserRole;
use App\Models\AuditLog;
use App\Models\ContactPerson;
use App\Models\Document;
use App\Models\Payment;
use App\Models\Registration;
use App\Models\Rekening;
use App\Models\Track;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // 1. Akun Pengguna (Sesuai micropolibatam.sql)
        $superAdmin = User::query()->create([
            'email' => 'superadmin.mc@polibatam.ac.id',
            'password_hash' => Hash::make('password123'),
            'role' => UserRole::SuperAdmin,
            'is_verified' => true,
        ]);

        $admin = User::query()->create([
            'email' => 'admin.akademik@polibatam.ac.id',
            'password_hash' => Hash::make('password123'),
            'role' => UserRole::Admin,
            'is_verified' => true,
        ]);

        $keuangan = User::query()->create([
            'email' => 'staf.keuangan@polibatam.ac.id',
            'password_hash' => Hash::make('password123'),
            'role' => UserRole::Keuangan,
            'is_verified' => true,
        ]);

        $maba1 = User::query()->create([
            'email' => 'budi.maba01@gmail.com',
            'password_hash' => Hash::make('password123'),
            'role' => UserRole::Maba,
            'is_verified' => true,
        ]);

        $maba2 = User::query()->create([
            'email' => 'siti.maba02@gmail.com',
            'password_hash' => Hash::make('password123'),
            'role' => UserRole::Maba,
            'is_verified' => true,
        ]);

        // 2. Track PMB Microcredential
        $track1 = Track::query()->create([
            'department_name' => 'Teknik Informatika',
            'study_program_name' => 'Teknologi Rekayasa Perangkat Lunak (TRPL)',
            'track_name' => 'Microcredential Mobile & Web Dev',
            'is_active' => true,
        ]);

        $track2 = Track::query()->create([
            'department_name' => 'Teknik Informatika',
            'study_program_name' => 'Rekayasa Keamanan Siber (RKS)',
            'track_name' => 'Microcredential Cyber Security',
            'is_active' => true,
        ]);

        // 3. Rekening Resmi BNI Polibatam
        $rekening = Rekening::query()->create([
            'bank_name' => 'Bank BNI',
            'account_number' => '1003301245',
            'account_name' => 'RPL 137 BLU POLTEK BTM UTK OPS',
            'nominal_biaya' => 200000.00,
            'is_active' => true,
            'created_at' => now(),
        ]);

        // 4. Contact Person / Helpdesk
        ContactPerson::query()->create([
            'name' => 'Admin Akademik PMB',
            'role_label' => 'admin_pendaftaran',
            'phone' => '081270001111',
            'email' => 'adm.micro@polibatam.ac.id',
            'is_active' => true,
            'managed_by' => $superAdmin->user_id,
        ]);

        ContactPerson::query()->create([
            'name' => 'Helpdesk Keuangan BNI',
            'role_label' => 'staf_keuangan',
            'phone' => '081270002222',
            'email' => 'keu.micro@polibatam.ac.id',
            'is_active' => true,
            'managed_by' => $superAdmin->user_id,
        ]);

        // 5. Registrasi Contoh: Budi Santoso
        $regBudi = Registration::query()->create([
            'user_id' => $maba1->user_id,
            'track_id' => $track1->track_id,
            'nik_encrypted' => '2171041205060001',
            'full_name' => 'Budi Santoso',
            'birth_place' => 'Batam',
            'birth_date' => '2006-05-12',
            'address' => 'Batam Centre, Kota Batam',
            'origin_school' => 'SMKN 1 Batam',
            'status' => 'menunggu_verifikasi',
        ]);

        // Dokumen Budi
        Document::query()->create([
            'registration_id' => $regBudi->registration_id,
            'doc_type' => 'ktp',
            'file_path' => 'uploads/dokumen/ktp_budi_maba01.jpg',
            'status_verifikasi_admin' => 'valid',
            'verified_by' => $admin->user_id,
            'uploaded_at' => now(),
            'verified_at' => now(),
        ]);

        Document::query()->create([
            'registration_id' => $regBudi->registration_id,
            'doc_type' => 'kk',
            'file_path' => 'uploads/dokumen/kk_budi_maba01.pdf',
            'status_verifikasi_admin' => 'valid',
            'verified_by' => $admin->user_id,
            'uploaded_at' => now(),
            'verified_at' => now(),
        ]);

        Document::query()->create([
            'registration_id' => $regBudi->registration_id,
            'doc_type' => 'ijazah',
            'file_path' => 'uploads/dokumen/ijazah_budi_maba01.pdf',
            'status_verifikasi_admin' => 'menunggu',
            'uploaded_at' => now(),
        ]);

        // Pembayaran Budi
        Payment::query()->create([
            'registration_id' => $regBudi->registration_id,
            'rekening_id' => $rekening->rekening_id,
            'amount' => 200000.00,
            'proof_file_path' => 'uploads/bukti_bayar/ss_bni_maba01.jpg',
            'status_pembayaran' => 'menunggu',
            'payment_date' => now(),
        ]);

        // 6. Registrasi Contoh: Siti Rahmawati
        Registration::query()->create([
            'user_id' => $maba2->user_id,
            'track_id' => $track2->track_id,
            'nik_encrypted' => '2171042008060002',
            'full_name' => 'Siti Rahmawati',
            'birth_place' => 'Tanjungpinang',
            'birth_date' => '2006-08-20',
            'address' => 'Batu Aji, Kota Batam',
            'origin_school' => 'SMAN 3 Batam',
            'status' => 'menunggu_verifikasi',
        ]);

        // Audit Log
        AuditLog::record('system', 'SEED_DATABASE', 'system:seed', 'Initial database seeding completed successfully');
    }
}
