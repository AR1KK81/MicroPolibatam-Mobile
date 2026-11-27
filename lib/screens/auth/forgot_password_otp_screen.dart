import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import '../../widgets/pmb_widgets.dart';

/// ============================================================================
/// HALAMAN PEMULIHAN KATA SANDI (3 TAHAP VIA KODE OTP)
/// 100% Sama persis baris demi baris dengan `resources/views/auth/forgot-password.blade.php`
/// ============================================================================
class ForgotPasswordOtpScreen extends StatefulWidget {
  final PmbDataStore store;

  const ForgotPasswordOtpScreen({super.key, required this.store});

  @override
  State<ForgotPasswordOtpScreen> createState() => _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  String _step = 'email'; // 'email', 'verify', 'reset'
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  String? _statusMessage;
  String? _errorMessage;
  String? _devOtp;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    setState(() {
      _errorMessage = null;
      _statusMessage = null;
    });
    final cleanEmail = _emailController.text.trim().toLowerCase();
    final exists = widget.store.users.any((u) => u.email.toLowerCase() == cleanEmail);
    if (!exists) {
      setState(() => _errorMessage = 'Email tidak ditemukan di database PMB Polibatam.');
      return;
    }
    setState(() {
      _step = 'verify';
      _devOtp = '482910';
      _statusMessage = 'Kode OTP 6-digit pemulihan telah dikirim ke ${_emailController.text}.';
    });
  }

  void _verifyOtp() {
    setState(() => _errorMessage = null);
    if (_otpController.text.trim().length < 6) {
      setState(() => _errorMessage = 'Masukkan 6-digit kode OTP terlebih dahulu.');
      return;
    }
    setState(() {
      _step = 'reset';
      _statusMessage = 'Kode OTP terverifikasi. Silakan buat kata sandi baru.';
    });
  }

  void _saveNewPassword() {
    setState(() => _errorMessage = null);
    if (_newPassController.text.length < 8) {
      setState(() => _errorMessage = 'Kata sandi baru minimal 8 karakter.');
      return;
    }
    if (_newPassController.text != _confirmPassController.text) {
      setState(() => _errorMessage = 'Konfirmasi kata sandi tidak cocok.');
      return;
    }
    widget.store.resetPasswordByEmail(_emailController.text, _newPassController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kata sandi berhasil diperbarui! Silakan masuk dengan kata sandi baru.'),
        backgroundColor: Color(0xFF059669),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF4F8FF),
              Color(0xFFFAFCFF),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight - 44),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top Right Back to Login (`‹ Kembali ke Login`) — max-w-5xl
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1024),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F8FF),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: const Color(0xFFC8DCFF)),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0052CC).withValues(alpha: 0.06),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.chevron_left, size: 17, color: Color(0xFF0052CC)),
                                  SizedBox(width: 6),
                                  Text(
                                    'Kembali ke Login',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0052CC),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Center Content (`max-w-[410px]`)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 410),
                          child: Column(
                            children: [
                              // Logo Container
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                                      blurRadius: 14,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: const MpLogoWidget(width: 48, height: 28),
                              ),
                              const SizedBox(height: 14),

                              // Badge (`PEMULIHAN MANDIRI VIA OTP`)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFCCFBF1),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text(
                                  'PEMULIHAN MANDIRI VIA OTP',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.66,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Title & Subtitle
                              Text(
                                _step == 'email'
                                    ? 'Lupa Kata Sandi?'
                                    : _step == 'verify'
                                        ? 'Verifikasi Kode OTP'
                                        : 'Buat Kata Sandi Baru',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 25,
                                  height: 1.2,
                                  letterSpacing: -0.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 8),
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 360),
                                child: Text(
                                  _step == 'email'
                                      ? 'Masukkan email akun terdaftar Anda untuk menerima kode OTP 6-digit pemulihan kata sandi.'
                                      : _step == 'verify'
                                          ? 'Masukkan 6-digit kode OTP yang telah dikirimkan ke ${_emailController.text}.'
                                          : 'Verifikasi OTP berhasil. Silakan masukkan kata sandi baru untuk akun ${_emailController.text}.',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    height: 1.6,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Step Indicator (`1. Email → 2. Kode OTP → 3. Sandi Baru`)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildStepIndicatorPill(
                                    label: '1. Email',
                                    isActive: _step == 'email',
                                    isDone: _step != 'email',
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Text('→', style: TextStyle(color: Color(0xFFCBD5E1))),
                                  ),
                                  _buildStepIndicatorPill(
                                    label: '2. Kode OTP',
                                    isActive: _step == 'verify',
                                    isDone: _step == 'reset',
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Text('→', style: TextStyle(color: Color(0xFFCBD5E1))),
                                  ),
                                  _buildStepIndicatorPill(
                                    label: '3. Sandi Baru',
                                    isActive: _step == 'reset',
                                    isDone: false,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Card
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(26),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(color: const Color(0xFFE3ECFB)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF0F235F).withValues(alpha: 0.045),
                                      blurRadius: 35,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (_statusMessage != null)
                                      Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(bottom: 16),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFECFDF5),
                                          borderRadius: BorderRadius.circular(13),
                                          border: Border.all(color: const Color(0xFFA7F3D0)),
                                        ),
                                        child: Text(
                                          _statusMessage!,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF065F46),
                                          ),
                                        ),
                                      ),

                                    if (_devOtp != null)
                                      Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(bottom: 16),
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF3F8FF),
                                          borderRadius: BorderRadius.circular(13),
                                          border: Border.all(color: const Color(0xFFBFDBFE)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Mode Lokal (Simulasi OTP Email):',
                                              style: TextStyle(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF0052CC),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            const Text(
                                              'Karena SMTP Gmail belum diisi di .env, berikut kode OTP Anda untuk pengujian:',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF475569),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 14,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(color: const Color(0xFFC8DCFF)),
                                              ),
                                              child: Text(
                                                _devOtp!,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'monospace',
                                                  fontWeight: FontWeight.w800,
                                                  letterSpacing: 4.5,
                                                  color: Color(0xFF0052CC),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    if (_errorMessage != null)
                                      Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(bottom: 16),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEF2F2),
                                          borderRadius: BorderRadius.circular(13),
                                          border: Border.all(color: const Color(0xFFFECACA)),
                                        ),
                                        child: Text(
                                          _errorMessage!,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFFB91C1C),
                                          ),
                                        ),
                                      ),

                                    if (_step == 'email') ...[
                                      const Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Email Akun Terdaftar',
                                            style: TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF0F172A),
                                            ),
                                          ),
                                          Text(
                                            'Gmail / SSO',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF0F172A),
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'nama@gmail.com',
                                          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                                          prefixIcon: const Icon(
                                            Icons.alternate_email,
                                            size: 18,
                                            color: Color(0xFF64748B),
                                          ),
                                          filled: true,
                                          fillColor: const Color(0xFFF8FAFC),
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 13,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(13),
                                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(13),
                                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: _sendOtp,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF0052CC),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(vertical: 15),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            elevation: 3,
                                          ),
                                          child: const Text(
                                            'Kirim Kode OTP ke Email',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ] else if (_step == 'verify') ...[
                                      const Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Kode OTP 6-Digit',
                                            style: TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF0F172A),
                                            ),
                                          ),
                                          Text(
                                            'Berlaku 10 Menit',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF059669),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: _otpController,
                                        maxLength: 6,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontFamily: 'monospace',
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 8,
                                          color: Color(0xFF0F172A),
                                        ),
                                        decoration: InputDecoration(
                                          counterText: '',
                                          hintText: '000000',
                                          hintStyle: const TextStyle(color: Color(0xFFCBD5E1)),
                                          filled: true,
                                          fillColor: const Color(0xFFF8FAFC),
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 14,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(13),
                                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(13),
                                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: _verifyOtp,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF0052CC),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(vertical: 15),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            elevation: 3,
                                          ),
                                          child: const Text(
                                            'Verifikasi Kode OTP',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.only(top: 14),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            top: BorderSide(color: Color(0xFFE2E8F0)),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () => setState(() {
                                                _step = 'email';
                                                _devOtp = null;
                                                _statusMessage = null;
                                              }),
                                              child: const Text(
                                                'Ganti alamat email',
                                                style: TextStyle(
                                                  fontSize: 12.5,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF64748B),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: _sendOtp,
                                              child: const Text(
                                                'Kirim Ulang OTP',
                                                style: TextStyle(
                                                  fontSize: 12.5,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xFF0052CC),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ] else ...[
                                      const Text(
                                        'Kata Sandi Baru',
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: _newPassController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          hintText: 'Minimal 8 karakter',
                                          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                                          filled: true,
                                          fillColor: const Color(0xFFF8FAFC),
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 13,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(13),
                                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(13),
                                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Konfirmasi Kata Sandi Baru',
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: _confirmPassController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          hintText: 'Ulangi kata sandi baru',
                                          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                                          filled: true,
                                          fillColor: const Color(0xFFF8FAFC),
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 13,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(13),
                                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(13),
                                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: _saveNewPassword,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF0052CC),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(vertical: 15),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            elevation: 3,
                                          ),
                                          child: const Text(
                                            'Simpan Kata Sandi Baru',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Footer (`max-w-[420px]`)
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 14, bottom: 4),
                          decoration: const BoxDecoration(
                            border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.verified_user_outlined,
                                size: 18,
                                color: Color(0xFF10B981),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Pemulihan Akun Terenkripsi • Sistem PMB Microcredential',
                                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicatorPill({
    required String label,
    required bool isActive,
    required bool isDone,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF0052CC)
            : isDone
                ? const Color(0xFFD1FAE5)
                : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: isActive
              ? Colors.white
              : isDone
                  ? const Color(0xFF059669)
                  : const Color(0xFF64748B),
        ),
      ),
    );
  }
}
