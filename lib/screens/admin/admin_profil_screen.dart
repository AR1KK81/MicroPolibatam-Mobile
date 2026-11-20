import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

/// ============================================================================
/// BAGIAN 2D: PROFIL AKUN & KEAMANAN (USER ADMIN AKADEMIK)
/// Sama persis dengan `resources/views/admin/profil.blade.php`
/// ============================================================================
class AdminProfilScreen extends StatefulWidget {
  final PmbDataStore store;

  const AdminProfilScreen({super.key, required this.store});

  @override
  State<AdminProfilScreen> createState() => _AdminProfilScreenState();
}

class _AdminProfilScreenState extends State<AdminProfilScreen> {
  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  String? _statusMsg;
  String? _errorMsg;

  @override
  void dispose() {
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _handleChangePassword() {
    setState(() {
      _statusMsg = null;
      _errorMsg = null;
    });
    final err = widget.store.changeCurrentUserPassword(
      currentPassword: _currentPassController.text,
      newPassword: _newPassController.text,
      confirmPassword: _confirmPassController.text,
    );
    if (err != null) {
      setState(() => _errorMsg = err);
    } else {
      _currentPassController.clear();
      _newPassController.clear();
      _confirmPassController.clear();
      setState(() => _statusMsg = 'Kata sandi akun berhasil diperbarui.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.store.currentUser!;
    final totalAcc = widget.store.registrations
        .where((r) => r.status == 'selesai_terverifikasi')
        .length;
    final totalRevisi = widget.store.registrations
        .where((r) => r.status == 'perlu_revisi')
        .length;

    return Column(
      children: [
        // Top Header (`PMB MICROCREDENTIAL / Profil Akun` + User Circle)
        Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Color(0xFFFBF8FF),
            border: Border(bottom: BorderSide(color: Color(0xFFEAE8F5))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PMB MICROCREDENTIAL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: Color(0xFF0052CC),
                    ),
                  ),
                  Text(
                    'Profil Akun',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF161A30),
                    ),
                  ),
                  Text(
                    'Manajemen profil dan keamanan kata sandi verifikator',
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: Color(0xFF003BA5),
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
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (_statusMsg != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF6EE7B7)),
                    ),
                    child: Text(
                      _statusMsg!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF065F46),
                      ),
                    ),
                  ),

                if (_errorMsg != null)
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
                      _errorMsg!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF93000A),
                      ),
                    ),
                  ),

                // Admin Identity Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFECEEF8)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0052CC),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'AR',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF161A30),
                                  ),
                                ),
                                Text(
                                  user.email,
                                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDCE9FF),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: const Text(
                                    '🛡️ Staf Admisi & Registrasi',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF003BA5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F2FF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          '🏢 Politeknik Negeri Batam • Unit Admisi & Akademik',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF434655),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Ringkasan Kinerja Bulan Ini Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFECEEF8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '📊 Ringkasan Kinerja Bulan Ini',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF161A30),
                            ),
                          ),
                          Text(
                            'PMB 2026',
                            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F2FF),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Dokumen Disetujui',
                                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '$totalAcc Maba',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF059669),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F2FF),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Permintaan Revisi',
                                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '$totalRevisi Maba',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFFBA1A1A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Ganti Kata Sandi Card (`profil.blade.php` lines 88-137)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFECEEF8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🔒 Ganti Kata Sandi',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF161A30),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Kosongkan jika tidak ingin mengubah kata sandi akun verifikator',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Kata Sandi Saat Ini',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF232738),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _currentPassController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Masukkan kata sandi lama',
                          filled: true,
                          fillColor: const Color(0xFFF4F2FF),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Kata Sandi Baru',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF232738),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _newPassController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Minimal 8 karakter unik',
                          filled: true,
                          fillColor: const Color(0xFFF4F2FF),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Konfirmasi Kata Sandi Baru',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF232738),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _confirmPassController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Ulangi kata sandi baru',
                          filled: true,
                          fillColor: const Color(0xFFF4F2FF),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleChangePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0052CC),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 1,
                          ),
                          child: const Text(
                            '✓ Simpan Perubahan',
                            style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.store.logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFDAD6),
                      foregroundColor: const Color(0xFF93000A),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(
                      '→ Keluar Akun (Logout)',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
