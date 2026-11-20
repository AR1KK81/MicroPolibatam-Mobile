<?php

namespace Tests\Feature;

use App\Enums\UserRole;
use App\Models\AuditLog;
use App\Models\ContactPerson;
use App\Models\User;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Schema;
use Tests\TestCase;

class AuthLoginTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();

        Schema::dropAllTables();

        Schema::create('users', function (Blueprint $table): void {
            $table->bigIncrements('user_id');
            $table->string('email', 150)->unique();
            $table->string('password_hash', 255);
            $table->string('role', 30)->default('maba');
            $table->boolean('is_verified')->default(false);
            $table->timestamps();
        });

        Schema::create('tracks', function (Blueprint $table): void {
            $table->bigIncrements('track_id');
            $table->string('department_name', 100);
            $table->string('study_program_name', 100);
            $table->string('track_name', 100);
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });

        Schema::create('registrations', function (Blueprint $table): void {
            $table->bigIncrements('registration_id');
            $table->unsignedBigInteger('user_id')->unique();
            $table->unsignedBigInteger('track_id');
            $table->binary('nik_encrypted');
            $table->string('full_name', 150);
            $table->string('birth_place', 100);
            $table->date('birth_date');
            $table->text('address');
            $table->string('origin_school', 150);
            $table->string('status', 50)->default('menunggu_verifikasi');
            $table->text('admin_verification_notes')->nullable();
            $table->timestamps();
        });

        Schema::create('documents', function (Blueprint $table): void {
            $table->bigIncrements('document_id');
            $table->unsignedBigInteger('registration_id');
            $table->string('doc_type', 20);
            $table->string('file_path', 255);
            $table->string('status_verifikasi_admin', 20)->default('menunggu');
            $table->text('admin_revision_notes')->nullable();
            $table->unsignedBigInteger('verified_by')->nullable();
            $table->timestamp('uploaded_at')->nullable();
            $table->timestamp('verified_at')->nullable();
        });

        Schema::create('rekening', function (Blueprint $table): void {
            $table->bigIncrements('rekening_id');
            $table->string('bank_name', 50)->default('Bank BNI');
            $table->string('account_number', 50);
            $table->string('account_name', 100);
            $table->decimal('nominal_biaya', 12, 2)->default(200000);
            $table->boolean('is_active')->default(true);
            $table->timestamp('created_at')->nullable();
        });

        Schema::create('payments', function (Blueprint $table): void {
            $table->bigIncrements('payment_id');
            $table->unsignedBigInteger('registration_id')->unique();
            $table->unsignedBigInteger('rekening_id');
            $table->decimal('amount', 12, 2)->default(200000);
            $table->string('proof_file_path', 255);
            $table->string('status_pembayaran', 20)->default('menunggu');
            $table->text('finance_notes')->nullable();
            $table->unsignedBigInteger('verified_by')->nullable();
            $table->timestamp('payment_date')->nullable();
            $table->timestamp('verified_at')->nullable();
        });

        Schema::create('contact_persons', function (Blueprint $table): void {
            $table->bigIncrements('cp_id');
            $table->string('name', 100);
            $table->string('role_label', 50);
            $table->string('phone', 30);
            $table->string('email', 150);
            $table->boolean('is_active')->default(true);
            $table->unsignedBigInteger('managed_by')->nullable();
        });

        Schema::create('audit_logs', function (Blueprint $table): void {
            $table->bigIncrements('audit_id');
            $table->string('actor', 100);
            $table->string('action', 50);
            $table->string('object', 100);
            $table->timestamp('timestamp')->nullable();
            $table->string('result', 255);
        });
    }

    public function test_login_page_renders_all_design_elements_and_active_contacts(): void
    {
        ContactPerson::query()->create([
            'name' => 'Admin Akademik PMB',
            'role_label' => 'admin_pendaftaran',
            'phone' => '081270001111',
            'email' => 'adm.micro@polibatam.ac.id',
            'is_active' => true,
        ]);

        $response = $this->get('/login');

        $response->assertOk();
        $response->assertSee('PORTAL ADMISI RESMI');
        $response->assertSee('Sistem PMB Microcredential');
        $response->assertSee('Pusat Bantuan & Info', false);
        $response->assertSee('JWT Secure Token');
        $response->assertSee('Admin Akademik PMB');
    }

    public function test_all_four_user_roles_authenticate_and_redirect_to_their_dashboards(): void
    {
        $rolesAndPaths = [
            [UserRole::Maba, 'maba@test.id', '/maba/dashboard'],
            [UserRole::Admin, 'admin@test.id', '/admin/dashboard'],
            [UserRole::Keuangan, 'keuangan@test.id', '/keuangan/dashboard'],
            [UserRole::SuperAdmin, 'super@test.id', '/super-admin/dashboard'],
        ];

        foreach ($rolesAndPaths as [$role, $email, $expectedPath]) {
            User::query()->create([
                'email' => $email,
                'password_hash' => Hash::make('Rahasia123!'),
                'role' => $role,
                'is_verified' => true,
            ]);

            $response = $this->post('/login', [
                'email' => $email,
                'password' => 'Rahasia123!',
                'remember' => '1',
            ]);

            $response->assertRedirect($expectedPath);
            $this->followingRedirects()->get($expectedPath)->assertOk();

            $this->post('/logout')->assertRedirect('/login');
        }

        $this->assertSame(8, AuditLog::query()->count());
    }

    public function test_role_middleware_redirects_unauthorized_role_to_own_dashboard(): void
    {
        $maba = User::query()->create([
            'email' => 'budi@gmail.com',
            'password_hash' => Hash::make('Rahasia123!'),
            'role' => UserRole::Maba,
            'is_verified' => true,
        ]);

        $this->actingAs($maba)
            ->get('/super-admin/dashboard')
            ->assertRedirect('/maba/dashboard');
    }

    public function test_invalid_credentials_return_error_and_record_failed_audit_log(): void
    {
        User::query()->create([
            'email' => 'budi@gmail.com',
            'password_hash' => Hash::make('Benar123!'),
            'role' => UserRole::Maba,
            'is_verified' => true,
        ]);

        $response = $this->from('/login')->post('/login', [
            'email' => 'budi@gmail.com',
            'password' => 'SalahPassword',
        ]);

        $response->assertRedirect('/login');
        $response->assertSessionHasErrors('email');
        $this->assertGuest();
        $this->assertDatabaseHas('audit_logs', [
            'actor' => 'budi@gmail.com',
            'action' => 'LOGIN_FAILED',
        ]);
    }

    public function test_maba_can_register_via_two_step_otp_and_is_logged_in(): void
    {
        $this->get('/register')
            ->assertOk()
            ->assertSee('Daftar Akun Maba')
            ->assertSee('LANGKAH 1 DARI 2')
            ->assertSee('LANGKAH 2 DARI 2');

        $sendResponse = $this->post('/register/send-otp', [
            'email' => 's4ndhiar@gmail.com',
            'password' => 'MabaBaru123!',
        ]);

        $sendResponse->assertRedirect('/register');

        $cachePayload = \Illuminate\Support\Facades\Cache::get('pmb_maba_reg_otp:' . sha1('s4ndhiar@gmail.com'));
        $this->assertIsArray($cachePayload);
        $this->assertNotEmpty($cachePayload['dev_otp']);

        $verifyResponse = $this->post('/register/verify', [
            'otp' => $cachePayload['dev_otp'],
        ]);

        $verifyResponse->assertRedirect('/maba/dashboard');
        $this->assertAuthenticated();
        $this->assertDatabaseHas('users', [
            'email' => 's4ndhiar@gmail.com',
            'role' => 'maba',
            'is_verified' => 1,
        ]);
    }

    public function test_user_can_reset_password_via_otp_flow(): void
    {
        User::query()->create([
            'email' => 'budi.maba01@gmail.com',
            'password_hash' => Hash::make('Lama12345!'),
            'role' => UserRole::Maba,
            'is_verified' => true,
        ]);

        $this->post('/forgot-password/send-otp', [
            'email' => 'budi.maba01@gmail.com',
        ])->assertRedirect('/forgot-password/verify');

        $cachePayload = \Illuminate\Support\Facades\Cache::get('pmb_pwd_otp:' . sha1('budi.maba01@gmail.com'));
        $this->assertIsArray($cachePayload);

        $this->post('/forgot-password/verify', [
            'otp' => $cachePayload['dev_otp'],
        ])->assertRedirect('/forgot-password/reset');

        $this->post('/forgot-password/reset', [
            'password' => 'Baru99999!',
            'password_confirmation' => 'Baru99999!',
        ])->assertRedirect('/login');

        $this->post('/login', [
            'email' => 'budi.maba01@gmail.com',
            'password' => 'Baru99999!',
        ])->assertRedirect('/maba/dashboard');
    }

    public function test_all_four_portals_render_and_process_functional_workflows(): void
    {
        $track = \App\Models\Track::query()->create([
            'department_name' => 'Teknik Informatika',
            'study_program_name' => 'TRPL',
            'track_name' => 'Microcredential Web Dev',
            'is_active' => true,
        ]);

        $rekening = \App\Models\Rekening::query()->create([
            'bank_name' => 'Bank BNI',
            'account_number' => '1003301245',
            'account_name' => 'Politeknik Negeri Batam',
            'nominal_biaya' => 200000,
            'is_active' => true,
        ]);

        $maba = User::query()->create([
            'email' => 'maba@polibatam.ac.id',
            'password_hash' => Hash::make('Secret123!'),
            'role' => UserRole::Maba,
            'is_verified' => true,
        ]);

        $admin = User::query()->create([
            'email' => 'admin@polibatam.ac.id',
            'password_hash' => Hash::make('Secret123!'),
            'role' => UserRole::Admin,
            'is_verified' => true,
        ]);

        $keuangan = User::query()->create([
            'email' => 'keuangan@polibatam.ac.id',
            'password_hash' => Hash::make('Secret123!'),
            'role' => UserRole::Keuangan,
            'is_verified' => true,
        ]);

        $superAdmin = User::query()->create([
            'email' => 'super@polibatam.ac.id',
            'password_hash' => Hash::make('Secret123!'),
            'role' => UserRole::SuperAdmin,
            'is_verified' => true,
        ]);

        // 1. Maba workflow
        $this->actingAs($maba)->get('/maba/dashboard')->assertOk();
        $this->actingAs($maba)->get('/maba/formulir?tab=biodata')->assertOk();
        $this->actingAs($maba)->post('/maba/formulir/biodata', [
            'full_name' => 'Budi Santoso',
            'nik' => '2171041205060001',
            'birth_place' => 'Batam',
            'birth_date' => '2006-05-12',
            'origin_school' => 'SMKN 1 Batam',
            'address' => 'Batam Centre',
            'track_id' => $track->track_id,
        ])->assertRedirect('/maba/formulir?tab=dokumen');

        $this->actingAs($maba)->get('/maba/formulir?tab=dokumen')->assertOk();
        $this->actingAs($maba)->get('/maba/formulir?tab=bayar')->assertOk();
        $this->actingAs($maba)->get('/maba/status')->assertOk();
        $this->actingAs($maba)->get('/maba/profil')->assertOk();

        $registration = \App\Models\Registration::query()->firstOrFail();

        \App\Models\Document::query()->create([
            'registration_id' => $registration->registration_id,
            'doc_type' => 'ktp',
            'file_path' => 'uploads/dokumen/ktp_test.jpg',
            'status_verifikasi_admin' => 'menunggu',
        ]);

        $payment = \App\Models\Payment::query()->create([
            'registration_id' => $registration->registration_id,
            'rekening_id' => $rekening->rekening_id,
            'amount' => 200000,
            'proof_file_path' => 'uploads/bukti_bayar/bni_test.jpg',
            'status_pembayaran' => 'menunggu',
        ]);

        // 2. Admin workflow
        $this->actingAs($admin)->get('/admin/dashboard')->assertOk();
        $this->actingAs($admin)->get('/admin/registrations/' . $registration->registration_id)->assertOk();
        $this->actingAs($admin)->post('/admin/registrations/' . $registration->registration_id . '/verify', [
            'action_type' => 'approve_all',
        ])->assertRedirect('/admin/dashboard?tab=disetujui');
        $this->actingAs($admin)->get('/admin/riwayat')->assertOk();
        $this->actingAs($admin)->get('/admin/profil')->assertOk();

        // 3. Keuangan workflow
        $this->actingAs($keuangan)->get('/keuangan/dashboard')->assertOk();
        $this->actingAs($keuangan)->get('/keuangan/payments/' . $payment->payment_id)->assertOk();
        $this->actingAs($keuangan)->post('/keuangan/payments/' . $payment->payment_id . '/verify', [
            'action_type' => 'confirm_lunas',
        ])->assertRedirect('/keuangan/dashboard?tab=lunas');
        $this->actingAs($keuangan)->get('/keuangan/riwayat')->assertOk();
        $this->actingAs($keuangan)->get('/keuangan/profil')->assertOk();

        // 4. Super Admin workflow
        $this->actingAs($superAdmin)->get('/super-admin/dashboard')->assertOk();
        $this->actingAs($superAdmin)->get('/super-admin/master')->assertOk();
        $this->actingAs($superAdmin)->get('/super-admin/audit')->assertOk();
        $this->actingAs($superAdmin)->get('/super-admin/profil')->assertOk();
    }
}

