import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

/// ============================================================================
/// BAGIAN 4G: PROFIL & OTORITAS SUPER ADMIN (USER SUPER ADMIN)
/// Sama persis dengan `resources/views/super-admin/profil.blade.php`
/// ============================================================================
class SuperAdminProfilScreen extends StatelessWidget {
  final PmbDataStore store;

  const SuperAdminProfilScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final user = store.currentUser;
    final totalUsers = store.users.length;
    final totalAudit = store.auditLogs.length;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      body: SafeArea(
        child: Column(
          children: [
            // Header (`SUPER ADMIN PORTAL / Profil & Otoritas`)
            Container(
              height: 62,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Color(0xFFFBF8FF),
                border: Border(bottom: BorderSide(color: Color(0xFFEAE8F5))),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(999),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.arrow_back, size: 20, color: Color(0xFF161A30)),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SUPER ADMIN PORTAL',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                          color: Color(0xFF003BA5),
                        ),
                      ),
                      Text(
                        'Profil & Otoritas',
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF161A30),
                        ),
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
                  children: [
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
                            child: const Text(
                              'SA',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Super Administrator',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF161A30),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.email ?? 'superadmin.mc@polibatam.ac.id',
                            style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFCCFBF1),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              '⚡ Hak Akses Penuh 8 Tabel Database',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF059669),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFECEEF8)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total Akun Terdaftar',
                                  style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$totalUsers',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF161A30),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFECEEF8)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Rekam Audit Log',
                                  style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$totalAudit',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF0052CC),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          store.logout();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFDAD6),
                          foregroundColor: const Color(0xFF93000A),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text(
                          '→ Keluar dari Sesi Super Admin',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
