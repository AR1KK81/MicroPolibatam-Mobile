import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

class MabaProfilScreen extends StatelessWidget {
  final PmbDataStore store;
  final VoidCallback onOpenFormulir;

  const MabaProfilScreen({
    super.key,
    required this.store,
    required this.onOpenFormulir,
  });

  @override
  Widget build(BuildContext context) {
    final reg = store.getOrCreateCurrentMabaRegistration();
    final track = store.getTrackById(reg.trackId);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF8FF),
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PMB MICROCREDENTIAL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF003BA5))),
            Text('Profil Saya', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar Card (Frame 282:1656)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFECEEF8)),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: const Color(0xFF0052CC),
                    child: Text(
                      reg.initials,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(reg.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFDCE9FF), borderRadius: BorderRadius.circular(99)),
                    child: Text('No. Reg: ${reg.regCode}', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF003BA5))),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(color: const Color(0xFFECECFF), borderRadius: BorderRadius.circular(99)),
                    child: Text(
                      '• ${(track?.departmentName ?? "INFORMATIKA").toUpperCase()}',
                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF003BA5)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('INFORMASI AKUN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF64748B))),
                Text('🔒 Tervalidasi Dukcapil', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF0052CC))),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFECEEF8)),
              ),
              child: Column(
                children: [
                  _buildInfoRow('NIK', reg.nik),
                  const Divider(height: 1),
                  _buildInfoRow('Email Akun', store.currentUser?.email ?? '-'),
                  const Divider(height: 1),
                  _buildInfoRow('Jalur Masuk', track?.trackName ?? 'Microcredential 2026'),
                  const Divider(height: 1),
                  _buildInfoRow('Status Portal', '• Aktif (SSO Terverifikasi)'),
                ],
              ),
            ),
            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: store.logout,
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Keluar dari Akun', style: TextStyle(fontWeight: FontWeight.w800)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFDAD6),
                  foregroundColor: const Color(0xFF93000A),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
        ],
      ),
    );
  }
}
