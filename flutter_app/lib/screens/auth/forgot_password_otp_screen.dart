import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  final PmbDataStore store;

  const ForgotPasswordOtpScreen({super.key, required this.store});

  @override
  State<ForgotPasswordOtpScreen> createState() => _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _otpCtrl = TextEditingController();
  final TextEditingController _newPassCtrl = TextEditingController();
  int _step = 1; // 1: Email, 2: OTP, 3: New Password

  @override
  void dispose() {
    _emailCtrl.dispose();
    _otpCtrl.dispose();
    _newPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFF),
        elevation: 0,
        title: const Text(
          'Pemulihan Kata Sandi via OTP',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE3ECFB)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _step == 1
                    ? 'Langkah 1: Masukkan Email Terdaftar'
                    : (_step == 2 ? 'Langkah 2: Masukkan Kode OTP Gmail' : 'Langkah 3: Buat Kata Sandi Baru'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 14),
              if (_step == 1) ...[
                TextField(
                  controller: _emailCtrl,
                  decoration: InputDecoration(
                    hintText: 'Masukkan email akun terdaftar',
                    prefixIcon: const Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      _otpCtrl.text = '849210';
                      setState(() => _step = 2);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0052CC), foregroundColor: Colors.white),
                    child: const Text('Kirim Kode OTP ke Gmail', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ] else if (_step == 2) ...[
                const Text('Kode OTP Simulasi: 849210', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF0052CC))),
                const SizedBox(height: 8),
                TextField(
                  controller: _otpCtrl,
                  decoration: InputDecoration(
                    hintText: '6-digit kode OTP',
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => setState(() => _step = 3),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0052CC), foregroundColor: Colors.white),
                    child: const Text('Verifikasi Kode OTP', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ] else ...[
                TextField(
                  controller: _newPassCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Masukkan kata sandi baru',
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.store.resetPasswordByEmail(_emailCtrl.text, _newPassCtrl.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kata sandi berhasil diperbarui! Silakan masuk.')),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669), foregroundColor: Colors.white),
                    child: const Text('Simpan Kata Sandi Baru', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
