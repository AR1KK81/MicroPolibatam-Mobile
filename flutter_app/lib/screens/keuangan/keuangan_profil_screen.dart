import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

class KeuanganProfilScreen extends StatelessWidget {
  final PmbDataStore store;

  const KeuanganProfilScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final user = store.currentUser;
    final rek = store.mainRekening;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF8FF),
        elevation: 0,
        title: const Text('Profil Staf Keuangan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 34,
                    backgroundColor: Color(0xFF003BA5),
                    child: Text('SK', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                  const SizedBox(height: 12),
                  Text(user?.name ?? 'Staf Keuangan 01', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  Text(user?.email ?? 'staf.keuangan@polibatam.ac.id', style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B))),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(color: const Color(0xFFDCE9FF), borderRadius: BorderRadius.circular(99)),
                    child: Text('🏛️ Rekening Utama: ${rek.bankName} ${rek.accountNumber}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF003BA5))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: store.logout,
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Keluar Akun (Logout)', style: TextStyle(fontWeight: FontWeight.w800)),
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
}
