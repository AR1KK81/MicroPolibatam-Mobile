<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
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

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('audit_logs');
        Schema::dropIfExists('contact_persons');
        Schema::dropIfExists('payments');
        Schema::dropIfExists('rekening');
        Schema::dropIfExists('documents');
        Schema::dropIfExists('registrations');
        Schema::dropIfExists('tracks');
    }
};
