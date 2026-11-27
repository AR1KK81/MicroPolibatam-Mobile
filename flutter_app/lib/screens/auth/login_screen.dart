import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import '../../widgets/pmb_widgets.dart';
import 'register_maba_screen.dart';
import 'forgot_password_otp_screen.dart';

/// ============================================================================
/// HALAMAN LOGIN UTAMA (1 PINTU UNTUK SEMUA 4 ROLE)
/// 100% Sama persis baris demi baris dengan `resources/views/auth/login.blade.php`
/// ============================================================================
class LoginScreen extends StatefulWidget {
  final PmbDataStore store;

  const LoginScreen({super.key, required this.store});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    setState(() => _errorMessage = null);
    final err = widget.store.login(_emailController.text, _passwordController.text);
    if (err != null) {
      setState(() => _errorMessage = err);
    }
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
                      // Top Right Help Button (`? Pusat Bantuan & Info`) — max-w-5xl
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1024),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () => showPmbHelpdeskModal(context, widget.store),
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
                                  Icon(Icons.help_outline, size: 16, color: Color(0xFF0052CC)),
                                  SizedBox(width: 8),
                                  Text(
                                    'Pusat Bantuan & Info',
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

                      // Center Login Content (`max-w-[410px]`)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 410),
                          child: Column(
                            children: [
                              // Logo Container (`w-16 h-16 rounded-2xl bg-white shadow-[0_2px_14px_rgba(15,23,42,0.04)]`)
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

                              // Official Portal Badge (`PORTAL ADMISI RESMI` — mint green `#CCFBF1`, text `#059669`)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFCCFBF1),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text(
                                  'PORTAL ADMISI RESMI',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.66,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Main Heading & Subtitle
                              const Text(
                                'Sistem PMB Microcredential',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 27,
                                  height: 1.2,
                                  letterSpacing: -0.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 8),
                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 360),
                                child: const Text(
                                  'Gerbang pendaftaran, verifikasi seleksi, dan validasi berkas akademik terintegrasi',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    height: 1.6,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Login Card (`rounded-[22px] border border-[#E3ECFB] bg-white p-6 sm:p-7`)
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
                                    if (_errorMessage != null)
                                      Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(bottom: 18),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEF2F2),
                                          borderRadius: BorderRadius.circular(13),
                                          border: Border.all(color: const Color(0xFFFECACA)),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.error_outline,
                                              size: 16,
                                              color: Color(0xFFDC2626),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                _errorMessage!,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xFFB91C1C),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    // Email Akun + SSO / Terdaftar
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Email Akun',
                                          style: TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                        Text(
                                          'SSO / Terdaftar',
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
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(13),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF0052CC),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Kata Sandi + Lupa kata sandi?
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Kata Sandi',
                                          style: TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    ForgotPasswordOtpScreen(store: widget.store),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Lupa kata sandi?',
                                            style: TextStyle(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF0052CC),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: _passwordController,
                                      obscureText: _obscurePassword,
                                      onSubmitted: (_) => _handleLogin(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF0F172A),
                                      ),
                                      decoration: InputDecoration(
                                        hintText: '••••••••••••',
                                        hintStyle: const TextStyle(
                                          color: Color(0xFF94A3B8),
                                          letterSpacing: 2.0,
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.lock_outline,
                                          size: 18,
                                          color: Color(0xFF64748B),
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () =>
                                              setState(() => _obscurePassword = !_obscurePassword),
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            size: 18,
                                            color: const Color(0xFF64748B),
                                          ),
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
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(13),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF0052CC),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Remember Session & JWT Secure Token Badge
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () => setState(() => _rememberMe = !_rememberMe),
                                          borderRadius: BorderRadius.circular(6),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color: _rememberMe
                                                      ? const Color(0xFF0052CC)
                                                      : Colors.white,
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: _rememberMe
                                                        ? const Color(0xFF0052CC)
                                                        : const Color(0xFFCBD5E1),
                                                    width: 2,
                                                  ),
                                                ),
                                                alignment: Alignment.center,
                                                child: _rememberMe
                                                    ? const Icon(
                                                        Icons.check,
                                                        size: 13,
                                                        color: Colors.white,
                                                      )
                                                    : null,
                                              ),
                                              const SizedBox(width: 10),
                                              const Text(
                                                'Ingat sesi saya',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF334155),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFD1FAE5).withValues(alpha: 0.85),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.verified_user_outlined,
                                                size: 14,
                                                color: Color(0xFF059669),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                'JWT Secure Token',
                                                style: TextStyle(
                                                  fontSize: 11.5,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xFF059669),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 18),

                                    // Submit Button (`Masuk`)
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: _handleLogin,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF0052CC),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 15),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          elevation: 3,
                                          shadowColor:
                                              const Color(0xFF0052CC).withValues(alpha: 0.3),
                                        ),
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.login_rounded, size: 19),
                                            SizedBox(width: 9),
                                            Text(
                                              'Masuk',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
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

                      // Footer Info (`max-w-[420px]`)
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Belum punya akun? ',
                                  style: TextStyle(fontSize: 13.5, color: Color(0xFF64748B)),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => RegisterMabaScreen(store: widget.store),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Daftar disini.',
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0052CC),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(top: 14, bottom: 4),
                              decoration: const BoxDecoration(
                                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.headset_mic_outlined,
                                    size: 18,
                                    color: Color(0xFF10B981),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Jam operasional: Senin – Jumat (08.00 – 17.00 WIB) •',
                                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
}
