import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import '../../widgets/pmb_widgets.dart';

/// ============================================================================
/// HALAMAN DAFTAR AKUN CALON MAHASISWA BARU (2 LANGKAH + 6 KOTAK OTP)
/// Sama persis dengan `resources/views/auth/register.blade.php`
/// ============================================================================
class RegisterMabaScreen extends StatefulWidget {
  final PmbDataStore store;

  const RegisterMabaScreen({super.key, required this.store});

  @override
  State<RegisterMabaScreen> createState() => _RegisterMabaScreenState();
}

class _RegisterMabaScreenState extends State<RegisterMabaScreen> {
  final _emailController = TextEditingController(text: 's4ndhiar@gmail.com');
  final _passwordController = TextEditingController(text: 'password123');
  final _emailFocusNode = FocusNode();
  bool _obscurePassword = true;
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(text: ['4', '8', '2', '9', '1', '0'][index]),
  );
  bool _codeSentBanner = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _sendOtpCode() {
    if (_emailController.text.trim().isEmpty) return;
    setState(() => _codeSentBanner = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kode OTP 6 digit (482910) telah dikirim ke ${_emailController.text}'),
        backgroundColor: const Color(0xFF0052CC),
      ),
    );
  }

  void _verifyAndRegister() {
    final otp = _otpControllers.map((c) => c.text.trim()).join();
    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan 6 digit kode OTP terlebih dahulu.'),
          backgroundColor: Color(0xFFBA1A1A),
        ),
      );
      return;
    }
    widget.store.registerMaba(_emailController.text, _passwordController.text);
    if (mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstHelpdesk = widget.store.helpdesks.isNotEmpty
        ? widget.store.helpdesks.first
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      body: SafeArea(
        child: Column(
          children: [
            // Top App Header (`PMB Micro / Polibatam` + Dark Blue User Circle)
            Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Color(0xFFFBF8FF),
                border: Border(bottom: BorderSide(color: Color(0xFFEAE8F5))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(999),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.arrow_back, size: 20, color: Color(0xFF161A30)),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'PMB Micro\nPolibatam',
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF003BA5),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0A3D91),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.person_outline, size: 18, color: Colors.white),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stepper Pill Badge (`• LANGKAH 1 DARI 2`)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCE9FF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(radius: 3, backgroundColor: Color(0xFF0052CC)),
                          SizedBox(width: 6),
                          Text(
                            'LANGKAH 1 DARI 2',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                              color: Color(0xFF003BA5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Page Title & Subtitle
                    const Text(
                      'Daftar Akun Calon\nMahasiswa Baru',
                      style: TextStyle(
                        fontSize: 23,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF161A30),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Gunakan akun Gmail aktif untuk menerima kode OTP verifikasi pendaftaran program Microcredential Polibatam.',
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.45,
                        color: Color(0xFF525866),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // CARD 1: Email Verification Request + Buat Kata Sandi Akun
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFECEEF8)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Alamat Gmail / Email Aktif',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E2235),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F0FE),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text(
                                  'Wajib Aktif',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0052CC),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF161A30),
                            ),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.mail_outline,
                                size: 18,
                                color: Color(0xFF5A6072),
                              ),
                              suffixIcon: const Icon(
                                Icons.check_circle,
                                color: Color(0xFF10B981),
                                size: 20,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF4F2FF),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Color(0xFFBFD4FF), width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Color(0xFFBFD4FF), width: 1.5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Buat Kata Sandi Akun
                          const Text(
                            'Buat Kata Sandi Akun',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E2235),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF161A30),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Minimal 6 karakter',
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                size: 17,
                                color: Color(0xFF5A6072),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 17,
                                  color: const Color(0xFF5A6072),
                                ),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF4F2FF),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Color(0xFFE0E4F5)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Color(0xFFE0E4F5)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _sendOtpCode,
                              icon: const Icon(Icons.send_outlined, size: 16),
                              label: const Text(
                                'Kirim Kode Verifikasi',
                                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0052CC),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // CARD 2: Masukkan Kode OTP (6 Digit)
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFECEEF8)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_codeSentBanner)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBF2FF),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 2),
                                    child: Icon(
                                      Icons.mark_email_read_outlined,
                                      size: 18,
                                      color: Color(0xFF0052CC),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Kode terkirim ke Gmail',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF003BA5),
                                          ),
                                        ),
                                        Text(
                                          'Periksa kotak masuk ${_emailController.text}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF3E4C66),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => _emailFocusNode.requestFocus(),
                                    child: const Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Icon(
                                        Icons.edit_outlined,
                                        size: 16,
                                        color: Color(0xFF0052CC),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Masukkan Kode OTP',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E2235),
                                ),
                              ),
                              Text(
                                '6 Digit Angka',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueGrey.shade500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // 6 Kotak Input OTP
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
                                          borderSide: const BorderSide(
                                            color: Color(0xFF0052CC),
                                            width: 1.5,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF0052CC),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 12),

                          // Belum terima kode? + Kirim ulang (0:00)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Belum terima kode?',
                                style: TextStyle(fontSize: 11.5, color: Color(0xFF6B7280)),
                              ),
                              InkWell(
                                onTap: _sendOtpCode,
                                child: const Row(
                                  children: [
                                    Icon(Icons.access_time, size: 14, color: Color(0xFF0052CC)),
                                    SizedBox(width: 4),
                                    Text(
                                      'Kirim ulang (0:00)',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0052CC),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Primary Verify & Login CTA (`Verifikasi & Masuk →`)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _verifyAndRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0052CC),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Verifikasi & Masuk',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 17),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Terms Text
                    const Center(
                      child: Text.rich(
                        TextSpan(
                          text: 'Dengan mendaftar, Anda menyetujui ',
                          style: TextStyle(fontSize: 11, color: Color(0xFF6B7280), height: 1.4),
                          children: [
                            TextSpan(
                              text: 'Ketentuan Layanan',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0052CC),
                              ),
                            ),
                            TextSpan(text: ' & '),
                            TextSpan(
                              text: 'Kebijakan Privasi PMB Polibatam',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0052CC),
                              ),
                            ),
                            TextSpan(text: '.'),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Divider: ATAU DAFTAR LANGSUNG
                    Row(
                      children: [
                        const Expanded(child: Divider(color: Color(0xFFE5E7F0))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'ATAU DAFTAR LANGSUNG',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                              color: Colors.blueGrey.shade400,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: Color(0xFFE5E7F0))),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Google Direct Button (`Lanjutkan dengan Google`)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _verifyAndRegister,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1E2235),
                          side: const BorderSide(color: Color(0xFFE2E6F3)),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: const Text(
                                'G',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF4285F4),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Lanjutkan dengan Google',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E2235),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Already have account link
                    Center(
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Text.rich(
                          TextSpan(
                            text: 'Sudah punya akun? ',
                            style: TextStyle(fontSize: 12.5, color: Color(0xFF525866)),
                            children: [
                              TextSpan(
                                text: 'Masuk di sini',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0052CC),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Operational Hours Pill Box (`#F2F0FF`)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F0FF),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info, size: 17, color: Color(0xFF0052CC)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Layanan pendaftaran online aktif 24 jam. Bantuan operator tersedia pukul 08.00–16.00 WIB.',
                              style: TextStyle(
                                fontSize: 11,
                                height: 1.35,
                                color: Color(0xFF43485B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Bottom Gray Support Footer
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F0FA),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE6E4F2)),
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => showPmbHelpdeskModal(context, widget.store),
                            child: Text(
                              'Layanan Bantuan & Helpdesk PMB${firstHelpdesk != null ? ' (${firstHelpdesk.phone})' : ''}',
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0052CC),
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            '© 2026 Microcredential Politeknik Negeri Batam',
                            style: TextStyle(fontSize: 10.5, color: Color(0xFF7B8196)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
