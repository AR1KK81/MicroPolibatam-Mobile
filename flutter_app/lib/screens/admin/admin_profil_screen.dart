import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

class AdminProfilScreen extends StatelessWidget {
  final PmbDataStore store;

  const AdminProfilScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final user = store.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF8FF),
        elevation: 0,
        title: const Text('Profil Akun Admin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: Color(0xFF0052CC),
                    child: Text('AR', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.name ?? 'Admin Registrasi 01', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                        Text(user?.email ?? 'admin.akademik@polibatam.ac.id', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        const SizedBox(height: 4),
                        const Text('🛡️ Staf Admisi & Registrasi Polibatam', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF003BA5))),
                      ],
                    ),
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
