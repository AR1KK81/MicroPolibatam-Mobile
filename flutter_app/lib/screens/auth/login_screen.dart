import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import '../../widgets/pmb_widgets.dart';
import 'register_maba_screen.dart';
import 'forgot_password_otp_screen.dart';

/// ============================================================================
/// HALAMAN LOGIN UTAMA (1 PINTU UNTUK SEMUA 4 ROLE)
/// Sama persis dengan `resources/views/auth/login.blade.php`
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
      backgroundColor: const Color(0xFFFBF8FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Right Help Pill Button (`? Bantuan`)
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => showPmbHelpdeskModal(context, widget.store),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1EFFF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.help_outline, size: 15, color: Color(0xFF0052CC)),
                        SizedBox(width: 6),
                        Text(
                          'Bantuan',
                          style: TextStyle(
                            fontSize: 12,
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

              // MP Logo Card (`MpLogoBox`)
              const MpLogoBox(size: 60, radius: 16),
              const SizedBox(height: 16),

              // Pill Badge: PENERIMAAN MAHASISWA BARU
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCE9FF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'PENERIMAAN MAHASISWA BARU',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.7,
                    color: Color(0xFF0052CC),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Main Heading
              const Text(
                'Sistem PMB\nMicrocredential',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  height: 1.2,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF161A30),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Politeknik Negeri Batam',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF525866),
                ),
              ),
              const SizedBox(height: 20),

              if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
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

              // Main White Login Card
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Masuk ke Akun Anda',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF161A30),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Gunakan email terdaftar untuk melanjutkan pendaftaran.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF5A6072)),
                    ),
                    const SizedBox(height: 18),

                    // Email Field
                    const Text(
                      'Email Akun',
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
                        hintText: 's4ndhiar@gmail.com',
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                        prefixIcon: const Icon(
                          Icons.mail_outline,
                          size: 18,
                          color: Color(0xFF5A6072),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF4F2FF),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
                    const SizedBox(height: 16),

                    // Password Field
                    const Text(
                      'Kata Sandi',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF232738),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      onSubmitted: (_) => _handleLogin(),
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF161A30),
                      ),
                      decoration: InputDecoration(
                        hintText: '••••••••••',
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          size: 18,
                          color: Color(0xFF5A6072),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            size: 18,
                            color: const Color(0xFF5A6072),
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF4F2FF),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
                    const SizedBox(height: 14),

                    // Remember Me (Custom 20x20 rounded-[6px] checkbox) & Lupa Kata Sandi?
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
                                  color: _rememberMe ? const Color(0xFF0052CC) : Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: _rememberMe
                                        ? const Color(0xFF0052CC)
                                        : const Color(0xFFCBD5E1),
                                    width: 1.5,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: _rememberMe
                                    ? const Icon(Icons.check, size: 13, color: Colors.white)
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Ingat saya',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF3E4456),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ForgotPasswordOtpScreen(store: widget.store),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Lupa Kata Sandi?',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0052CC),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Submit Button (`Masuk →`)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0052CC),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Masuk',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 17),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Divider: BELUM MEMILIKI AKUN?
              Row(
                children: [
                  const Expanded(child: Divider(color: Color(0xFFE5E7F0))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'BELUM MEMILIKI AKUN?',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        color: Colors.blueGrey.shade400,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: Color(0xFFE5E7F0))),
                ],
              ),
              const SizedBox(height: 14),

              // Secondary CTA: Daftar Akun Calon Mahasiswa Baru
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RegisterMabaScreen(store: widget.store),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0052CC),
                    side: const BorderSide(color: Color(0xFFBFD4FF), width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add_alt_1_outlined, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Daftar Akun Calon Mahasiswa Baru',
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Footer Links
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => showPmbHelpdeskModal(context, widget.store),
                    child: const Row(
                      children: [
                        Icon(Icons.description_outlined, size: 14, color: Color(0xFF525866)),
                        SizedBox(width: 5),
                        Text(
                          'Panduan PMB',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF525866),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('•', style: TextStyle(color: Color(0xFFCBD5E1))),
                  ),
                  InkWell(
                    onTap: () => showPmbHelpdeskModal(context, widget.store),
                    child: const Row(
                      children: [
                        Icon(Icons.headset_mic_outlined, size: 14, color: Color(0xFF525866)),
                        SizedBox(width: 5),
                        Text(
                          'Hubungi Helpdesk',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF525866),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Copyright Footer
              const Text(
                '© 2026 Politeknik Negeri Batam • v1.0',
                style: TextStyle(fontSize: 11, color: Color(0xFF8C92A4)),
              ),
              const SizedBox(height: 2),
              const Text(
                'Unit Akademik & Admisi Microcredential',
                style: TextStyle(fontSize: 10.5, color: Color(0xFFA0A6B8)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
