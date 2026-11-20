import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

class RegisterMabaScreen extends StatefulWidget {
  final PmbDataStore store;

  const RegisterMabaScreen({super.key, required this.store});

  @override
  State<RegisterMabaScreen> createState() => _RegisterMabaScreenState();
}

class _RegisterMabaScreenState extends State<RegisterMabaScreen> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController(text: 'password123');
  final List<TextEditingController> _otpCtrls = List.generate(6, (_) => TextEditingController());
  bool _otpSent = false;
  String _generatedOtp = '849210';

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    for (final c in _otpCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _sendOtp() {
    if (_emailCtrl.text.trim().isEmpty || !_emailCtrl.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan alamat Gmail / Email aktif yang valid.')),
      );
      return;
    }
    setState(() {
      _otpSent = true;
      for (int i = 0; i < 6; i++) {
        _otpCtrls[i].text = _generatedOtp[i];
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kode OTP $_generatedOtp telah dikirim ke ${_emailCtrl.text.trim()}')),
    );
  }

  void _verifyAndLogin() {
    if (!_otpSent) {
      _sendOtp();
      return;
    }
    widget.store.registerMaba(
      _emailCtrl.text.trim(),
      _passCtrl.text.isNotEmpty ? _passCtrl.text : 'password123',
    );
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FBFF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0045AD)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PMB Micro', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0A4DA6))),
            Text('Polibatam', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF334155))),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Text(
              'Daftar Akun Maba',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 6),
            const Text(
              'Masukkan email Gmail kamu untuk menerima kode verifikasi OTP langsung ke inbox',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 18),

            // CARD 1: LANGKAH 1 DARI 2
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE6EEFA)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFDCE9FF), borderRadius: BorderRadius.circular(99)),
                        child: const Text('LANGKAH 1 DARI 2', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF0052CC))),
                      ),
                      const Text('• Input Akun', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF0052CC))),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Alamat Gmail / Email Aktif', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                      Text('Wajib Aktif', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0052CC))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailCtrl,
                    decoration: InputDecoration(
                      hintText: 'nama.maba@gmail.com',
                      prefixIcon: const Icon(Icons.mail_outline_rounded, size: 19),
                      filled: true,
                      fillColor: const Color(0xFFFAFBFD),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'ⓘ Gunakan alamat email pribadi yang aktif di smartphone kamu',
                    style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton.icon(
                      onPressed: _sendOtp,
                      icon: const Icon(Icons.send_rounded, size: 17),
                      label: const Text('Kirim Kode Verifikasi', style: TextStyle(fontWeight: FontWeight.w700)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0052CC),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // CARD 2: LANGKAH 2 DARI 2
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE6EEFA)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFEBEEF5), borderRadius: BorderRadius.circular(99)),
                        child: const Text('LANGKAH 2 DARI 2', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF475569))),
                      ),
                      const Text('KEAMANAN OTP', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF94A3B8))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFEBF3FF), borderRadius: BorderRadius.circular(13)),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Color(0xFF0045AD), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Kode 6 digit telah dikirim ke ${_emailCtrl.text.isEmpty ? "nama.maba@gmail.com" : _emailCtrl.text}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0045AD)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Masukkan Kode 6-Digit', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                      (index) => SizedBox(
                        width: 46,
                        child: TextField(
                          controller: _otpCtrls[index],
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0A3D91)),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: const Color(0xFFF1F5FC),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Verifikasi & Masuk Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _verifyAndLogin,
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Verifikasi & Masuk', style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003E9C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
