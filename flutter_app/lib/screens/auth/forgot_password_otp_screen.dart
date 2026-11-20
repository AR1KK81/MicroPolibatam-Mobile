import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import '../../widgets/pmb_widgets.dart';

/// ============================================================================
/// HALAMAN LUPA KATA SANDI (PEMULIHAN MANDIRI 3 TAHAP VIA KODE OTP GMAIL)
/// Sama persis dengan `resources/views/auth/forgot-password.blade.php`
/// ============================================================================
class ForgotPasswordOtpScreen extends StatefulWidget {
  final PmbDataStore store;

  const ForgotPasswordOtpScreen({super.key, required this.store});

  @override
  State<ForgotPasswordOtpScreen> createState() => _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  int _step = 1; // 1 = Email, 2 = Kode OTP, 3 = Sandi Baru
  final _emailController = TextEditingController(text: 'budi.maba01@gmail.com');
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(text: ['4', '8', '2', '9', '1', '0'][index]),
  );
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  String? _statusMessage;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
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
      _step = 2;
      _statusMessage = 'Kode OTP pemulihan (482910) telah dikirim ke ${_emailController.text}.';
    });
  }

  void _verifyOtp() {
    setState(() => _errorMessage = null);
    final code = _otpControllers.map((c) => c.text.trim()).join();
    if (code.length < 6) {
      setState(() => _errorMessage = 'Masukkan 6 digit kode OTP terlebih dahulu.');
      return;
    }
    setState(() {
      _step = 3;
      _statusMessage = 'Kode OTP terverifikasi! Silakan buat kata sandi baru Anda.';
    });
  }

  void _saveNewPassword() {
    setState(() => _errorMessage = null);
    if (_newPassController.text.length < 6) {
      setState(() => _errorMessage = 'Kata sandi baru minimal 6 karakter.');
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
      backgroundColor: const Color(0xFFFBF8FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Right Action: `← Kembali ke Login`
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1EFFF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      '← Kembali ke Login',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0052CC),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // MP Logo Card (`MpLogoBox`)
              const MpLogoBox(size: 56, radius: 16),
              const SizedBox(height: 14),

              // Mint Badge: PEMULIHAN MANDIRI VIA OTP
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFCCFBF1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'PEMULIHAN MANDIRI VIA OTP',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.7,
                    color: Color(0xFF059669),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Title & Subtitle per Step
              const Text(
                'Pemulihan Kata Sandi',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF161A30),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _step == 1
                    ? 'Langkah 1 dari 3: Masukkan email akun terdaftar untuk menerima kode OTP.'
                    : _step == 2
                        ? 'Langkah 2 dari 3: Masukkan 6 digit kode OTP yang dikirim ke email Anda.'
                        : 'Langkah 3 dari 3: Buat kata sandi baru untuk akun Anda.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12.5, color: Color(0xFF525866)),
              ),
              const SizedBox(height: 14),

              // Step Indicator Pills (`1. Email → 2. Kode OTP → 3. Sandi Baru`)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStepPill(1, '1. Email'),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Text('→', style: TextStyle(fontSize: 11, color: Color(0xFFCBD5E1))),
                  ),
                  _buildStepPill(2, '2. Kode OTP'),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Text('→', style: TextStyle(fontSize: 11, color: Color(0xFFCBD5E1))),
                  ),
                  _buildStepPill(3, '3. Sandi Baru'),
                ],
              ),
              const SizedBox(height: 18),

              // Alerts
              if (_statusMessage != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1FAE5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF6EE7B7)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _statusMessage!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF065F46),
                        ),
                      ),
                      if (_step == 2) ...[
                        const SizedBox(height: 6),
                        const Text(
                          'Simulasi OTP Lokal: Kode OTP Anda adalah 482910',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF047857),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

              if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFDAD6),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFFCA5A5)),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF93000A),
                    ),
                  ),
                ),

              // Main White Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFECEEF8)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                      blurRadius: 24,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _step == 1
                    ? _buildStep1Email()
                    : _step == 2
                        ? _buildStep2Otp()
                        : _buildStep3NewPassword(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepPill(int stepNumber, String label) {
    final isCurrent = _step == stepNumber;
    final isPassed = _step > stepNumber;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCurrent
            ? const Color(0xFF0052CC)
            : isPassed
                ? const Color(0xFFD1FAE5)
                : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isCurrent
              ? Colors.white
              : isPassed
                  ? const Color(0xFF065F46)
                  : const Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget _buildStep1Email() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email Akun Terdaftar',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF232738),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: Color(0xFF161A30),
          ),
          decoration: InputDecoration(
            hintText: 'Masukkan email akun Anda',
            filled: true,
            fillColor: const Color(0xFFF4F2FF),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF0052CC), width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Sistem akan mengirimkan 6 digit kode OTP ke alamat email Anda.',
          style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _sendOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0052CC),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text(
              'Kirim Kode OTP →',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2Otp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEBF2FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Email Tujuan OTP:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF003BA5),
                ),
              ),
              Text(
                _emailController.text,
                style: const TextStyle(fontSize: 11.5, color: Color(0xFF3E4C66)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Masukkan 6 Digit Kode OTP',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF232738),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(6, (index) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: index < 5 ? 8 : 0),
                child: SizedBox(
                  height: 48,
                  child: TextField(
                    controller: _otpControllers[index],
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF003BA5),
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: const Color(0xFFF4F2FF),
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF0052CC), width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF0052CC), width: 1.5),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _verifyOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0052CC),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text(
              'Verifikasi Kode OTP →',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => setState(() {
                _step = 1;
                _statusMessage = null;
              }),
              child: const Text(
                'Ganti alamat email',
                style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
              ),
            ),
            InkWell(
              onTap: _sendOtp,
              child: const Text(
                'Kirim Ulang OTP',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0052CC),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep3NewPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFD1FAE5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            '✓ OTP Terverifikasi untuk ${_emailController.text}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF065F46),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Kata Sandi Baru',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF232738),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _newPassController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Minimal 6 karakter',
            filled: true,
            fillColor: const Color(0xFFF4F2FF),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Konfirmasi Kata Sandi Baru',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF232738),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _confirmPassController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Ketik ulang kata sandi baru',
            filled: true,
            fillColor: const Color(0xFFF4F2FF),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveNewPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0052CC),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text(
              'Simpan Kata Sandi Baru & Masuk',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}
