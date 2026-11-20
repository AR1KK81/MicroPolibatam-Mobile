import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import 'maba_formulir_screen.dart';

/// ============================================================================
/// BAGIAN 1D: PROFIL SAYA - CALON MAHASISWA (USER MABA)
/// Sama persis dengan `resources/views/maba/profil.blade.php`
/// ============================================================================
class MabaProfilScreen extends StatelessWidget {
  final PmbDataStore store;
  final ValueChanged<int>? onSwitchTab;

  const MabaProfilScreen({
    super.key,
    required this.store,
    this.onSwitchTab,
  });

  @override
  Widget build(BuildContext context) {
    final reg = store.getOrCreateCurrentMabaRegistration();
    final track = store.getTrackById(reg.trackId);
    final user = store.currentUser!;

    return Column(
      children: [
        // Top Header (`PMB MICROCREDENTIAL / Pengumuman` + `Edit Biodata` + Avatar)
        Container(
          height: 62,
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
                    'Pengumuman',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF003BA5),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MabaFormulirScreen(
                            store: store,
                            initialStep: 1,
                            onOpenStatusTab: () => onSwitchTab?.call(1),
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCE9FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Edit Biodata',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF003BA5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profil Saya',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF161A30),
                  ),
                ),
                const Text(
                  'Informasi akun dan pengaturan calon mahasiswa Polibatam',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),

                // Main Avatar Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFECEEF8)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Color(0xFF003BA5),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          reg.initials,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        reg.fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF161A30),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCE9FF),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'No. Reg: ${reg.regCode}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF003BA5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1EFFF),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '• ${(track?.departmentName ?? 'INFORMATIKA').toUpperCase()}',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF003BA5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // INFORMASI AKUN
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'INFORMASI AKUN',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      '✓ Tervalidasi Dukcapil',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0052CC),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFECEEF8)),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow('🪪', 'NIK', reg.nik),
                      const Divider(color: Color(0xFFF4F2FF), height: 1),
                      _buildInfoRow('✉️', 'Email Terdaftar', user.email),
                      const Divider(color: Color(0xFFF4F2FF), height: 1),
                      _buildInfoRow('🎓', 'Jalur Masuk', 'Microcredential 2026'),
                      const Divider(color: Color(0xFFF4F2FF), height: 1),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Text('🛡️', style: TextStyle(fontSize: 16)),
                                SizedBox(width: 10),
                                Text(
                                  'Status Portal',
                                  style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCE9FF),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                '• Aktif (SSO Terverifikasi)',
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
                ),
                const SizedBox(height: 20),

                // PENGATURAN & BANTUAN -> Kebijakan Privasi Data
                const Text(
                  'PENGATURAN & BANTUAN',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFECEEF8)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEBF2FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Text('🔒', style: TextStyle(fontSize: 16)),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kebijakan Privasi Data',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF161A30),
                                ),
                              ),
                              Text(
                                'Keamanan arsip pendaftar Polibatam',
                                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Text(
                        '›',
                        style: TextStyle(fontSize: 18, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Logout Button (`→ Keluar dari Akun`)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: store.logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFDAD6),
                      foregroundColor: const Color(0xFF93000A),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(
                      '→ Keluar dari Akun',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    'PMB Microcredential Polibatam • v1.2.0\nPusat Informasi Penerimaan Mahasiswa Baru © 2026',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10.5, height: 1.4, color: Color(0xFF94A3B8)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String emoji, String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 10),
              Text(label, style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B))),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF161A30),
            ),
          ),
        ],
      ),
    );
  }
}
