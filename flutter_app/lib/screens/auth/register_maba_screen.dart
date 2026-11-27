import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

/// ============================================================================
/// HALAMAN DAFTAR AKUN MABA (2 LANGKAH + 6 KOTAK OTP)
/// 100% Sama persis baris demi baris dengan `resources/views/auth/register.blade.php`
/// ============================================================================
class RegisterMabaScreen extends StatefulWidget {
  final PmbDataStore store;

  const RegisterMabaScreen({super.key, required this.store});

  @override
  State<RegisterMabaScreen> createState() => _RegisterMabaScreenState();
}

class _RegisterMabaScreenState extends State<RegisterMabaScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  bool _obscurePassword = true;
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  String? _statusMessage;
  String? _errorMessage;
  String _devOtp = '482910';

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
    setState(() {
      _errorMessage = null;
      _statusMessage = null;
    });
    if (_emailController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Masukkan alamat email Gmail aktif terlebih dahulu.');
      return;
    }
    if (_passwordController.text.length < 6) {
      setState(() => _errorMessage = 'Kata sandi akun minimal 6 karakter.');
      return;
    }
    setState(() {
      _devOtp = '482910';
      _statusMessage =
          'Kode verifikasi 6 digit telah dikirimkan ke ${_emailController.text.trim()}.';
    });
  }

  void _fillOtpAutomatically() {
    for (int i = 0; i < 6; i++) {
      _otpControllers[i].text = _devOtp[i];
    }
    setState(() {});
  }

  void _verifyAndRegister() {
    setState(() => _errorMessage = null);
    final otp = _otpControllers.map((c) => c.text.trim()).join();
    if (otp.length < 6) {
      setState(() => _errorMessage = 'Masukkan 6 digit kode OTP terlebih dahulu.');
      return;
    }
    final email = _emailController.text.trim().isNotEmpty
        ? _emailController.text.trim()
        : 'nama.maba@gmail.com';
    final password =
        _passwordController.text.isNotEmpty ? _passwordController.text : 'password123';
    widget.store.registerMaba(email, password);
    if (mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingEmail = _emailController.text.trim().isNotEmpty
        ? _emailController.text.trim()
        : 'nama.maba@gmail.com';

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top App Bar (`max-w-[460px]`)
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              borderRadius: BorderRadius.circular(999),
                              child: Container(
                                width: 36,
                                height: 36,
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.arrow_back,
                                  size: 20,
                                  color: Color(0xFF0045AD),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PMB Micro',
                                  style: TextStyle(
                                    fontSize: 15,
                                    height: 1.0,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0A4DA6),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Polibatam',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    height: 1.0,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF334155),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A3D91),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0A3D91).withValues(alpha: 0.22),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.person_outline, size: 20, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Main Content Container (`max-w-[420px]`)
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    child: Column(
                      children: [
                        // Hero Header
                        Container(
                          width: 14,
                          height: 14,
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const Text(
                          'Daftar Akun Maba',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 29,
                            height: 1.2,
                            letterSpacing: -0.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 330),
                          child: const Text(
                            'Masukkan email Gmail kamu untuk menerima kode verifikasi OTP langsung ke inbox',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.5,
                              height: 1.6,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        if (_statusMessage != null)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: const Color(0xFFA7F3D0)),
                            ),
                            child: Text(
                              _statusMessage!,
                              style: const TextStyle(fontSize: 13, color: Color(0xFF065F46)),
                            ),
                          ),

                        if (_errorMessage != null)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: const Color(0xFFFECACA)),
                            ),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(fontSize: 13, color: Color(0xFFB91C1C)),
                            ),
                          ),

                        // CARD 1: LANGKAH 1 DARI 2 (Input Akun)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: const Color(0xFFE6EEFA)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0F235F).withValues(alpha: 0.04),
                                blurRadius: 28,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDCE9FF),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: const Text(
                                      'LANGKAH 1 DARI 2',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.4,
                                        color: Color(0xFF0052CC),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF0052CC),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'Input Akun',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF334155),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Alamat Gmail / Email Aktif
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Alamat Gmail / Email Aktif',
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F0FE),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: const Text(
                                      'Wajib Aktif',
                                      style: TextStyle(
                                        fontSize: 10.5,
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
                                style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
                                decoration: InputDecoration(
                                  hintText: 'nama.maba@gmail.com',
                                  hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                                  prefixIcon: const Icon(
                                    Icons.mail_outline,
                                    size: 18,
                                    color: Color(0xFF64748B),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFFAFBFD),
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
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(13),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF0052CC),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Buat Kata Sandi Akun
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Buat Kata Sandi Akun',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    'Min. 6 karakter',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: const TextStyle(fontSize: 13.5, color: Color(0xFF0F172A)),
                                decoration: InputDecoration(
                                  hintText: 'Buat kata sandi untuk login',
                                  hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    size: 17,
                                    color: Color(0xFF64748B),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () =>
                                        setState(() => _obscurePassword = !_obscurePassword),
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      size: 17,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFFAFBFD),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 11,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(13),
                                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(13),
                                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(13),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF0052CC),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Helper Info
                              const Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 1),
                                    child: Icon(
                                      Icons.info_outline,
                                      size: 16,
                                      color: Color(0xFF0052CC),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Gunakan alamat email pribadi yang aktif di smartphone kamu',
                                      style: TextStyle(
                                        fontSize: 12,
                                        height: 1.35,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),

                              // Button: Kirim Kode Verifikasi
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _sendOtpCode,
                                  icon: const Icon(Icons.send_outlined, size: 16),
                                  label: const Text(
                                    'Kirim Kode Verifikasi',
                                    style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0052CC),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // CARD 2: LANGKAH 2 DARI 2 (KEAMANAN OTP)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: const Color(0xFFE6EEFA)),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0F235F).withValues(alpha: 0.04),
                                blurRadius: 28,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEBEEF5),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: const Text(
                                      'LANGKAH 2 DARI 2',
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.4,
                                        color: Color(0xFF475569),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5FB),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: const Text(
                                      'KEAMANAN OTP',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.5,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Sent Destination Banner
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEBF3FF),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF0045AD),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.check,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text.rich(
                                        TextSpan(
                                          text: 'Kode 6 digit telah dikirim ke ',
                                          style: const TextStyle(
                                            fontSize: 12.5,
                                            height: 1.35,
                                            color: Color(0xFF475569),
                                          ),
                                          children: [
                                            TextSpan(
                                              text: pendingEmail,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: Color(0xFF0045AD),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => _emailFocusNode.requestFocus(),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Icon(
                                          Icons.edit_outlined,
                                          size: 16,
                                          color: Color(0xFF0045AD),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Kode OTP Lokal + Isi Otomatis
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F9FF),
                                  borderRadius: BorderRadius.circular(13),
                                  border: Border.all(color: const Color(0xFFBFDBFE)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Kode OTP Lokal: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF0052CC),
                                          ),
                                        ),
                                        Text(
                                          _devOtp,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'monospace',
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 2.0,
                                            color: Color(0xFF0A3D91),
                                          ),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: _fillOtpAutomatically,
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0052CC),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'Isi Otomatis',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),

                              // 6-Digit OTP Boxes
                              const Text(
                                'Masukkan Kode 6-Digit',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: List.generate(6, (index) {
                                  return Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: index < 5 ? 8 : 0),
                                      child: SizedBox(
                                        height: 52,
                                        child: TextField(
                                          controller: _otpControllers[index],
                                          textAlign: TextAlign.center,
                                          maxLength: 1,
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF0A3D91),
                                          ),
                                          decoration: InputDecoration(
                                            counterText: '',
                                            hintText: '-',
                                            hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                                            filled: true,
                                            fillColor: const Color(0xFFF1F5FC),
                                            contentPadding: EdgeInsets.zero,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(13),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(13),
                                              borderSide: const BorderSide(
                                                color: Color(0xFF0052CC),
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 14),

                              // Resend Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Belum terima kode?',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: _sendOtpCode,
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 14,
                                          color: Color(0xFF0052CC),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Kirim ulang (0:00)',
                                          style: TextStyle(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w800,
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

                        // Big Primary Action Button: Verifikasi & Masuk
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _verifyAndRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF003E9C),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 3,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Verifikasi & Masuk',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, size: 20),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 330),
                          child: const Text(
                            'Dengan menekan tombol di atas, Anda menyetujui Ketentuan Layanan & Privasi PMB Polibatam',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11.5,
                              height: 1.5,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Divider: ATAU DAFTAR LANGSUNG
                        const Row(
                          children: [
                            Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'ATAU DAFTAR LANGSUNG',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Google Button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => _emailFocusNode.requestFocus(),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF1E293B),
                              side: const BorderSide(color: Color(0xFFE8EEF8)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'G',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF4285F4),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Lanjutkan dengan Google',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Login Redirect
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Sudah punya akun? ',
                              style: TextStyle(fontSize: 13.5, color: Color(0xFF64748B)),
                            ),
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: const Text(
                                'Masuk di sini',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0052CC),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Operational Hours Pill Card
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F6FC),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.headset_mic_outlined, size: 20, color: Color(0xFF475569)),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Jam operasional: Senin – Jumat (08.00 – 17.00 WIB) • Layanan Bantuan Terpadu',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    height: 1.45,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Footer Block
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F6FC),
                  border: Border(top: BorderSide(color: Color(0xFFE6ECF7))),
                ),
                child: const Column(
                  children: [
                    Text(
                      'Layanan Bantuan & Helpdesk PMB',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.access_time, size: 14, color: Color(0xFF64748B)),
                        SizedBox(width: 6),
                        Text(
                          'Senin - Jumat: 08:00 - 16:00 WIB',
                          style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      '© 2026 Microcredential Politeknik Negeri Batam. All Rights Reserved.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
