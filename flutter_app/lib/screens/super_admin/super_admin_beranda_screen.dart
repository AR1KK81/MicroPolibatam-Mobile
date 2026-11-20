import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';

class SuperAdminBerandaScreen extends StatelessWidget {
  final PmbDataStore store;
  final void Function(int tabIndex) onNavigateTab;

  const SuperAdminBerandaScreen({
    super.key,
    required this.store,
    required this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    final totalUsers = store.users.length;
    final totalHelpdesk = store.helpdesks.length;
    final activeHelpdesk = store.helpdesks.where((h) => h.isActive).length;
    final totalRekening = store.rekenings.length;
    final depts = store.tracks.map((t) => t.departmentName).toSet().length;
    final totalTracks = store.tracks.length;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header (Image 7 Frame 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFDCE9FF), borderRadius: BorderRadius.circular(99)),
                        child: const Text('🛡️ PORTAL SUPER ADMIN • POLIBATAM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF003BA5))),
                      ),
                      const SizedBox(height: 8),
                      const Text('Halo, Super Admin', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
                      const Text('Kelola data sistem PMB Microcredential', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                  IconButton(
                    onPressed: store.logout,
                    tooltip: 'Keluar Akun (Logout)',
                    icon: const CircleAvatar(
                      backgroundColor: Color(0xFFDCE9FF),
                      child: Text('SA', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF003BA5))),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 4 Stat Cards (2x2 Grid)
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.45,
                children: [
                  _buildStatCard('TOTAL USER', '$totalUsers', '+2 minggu ini', const Color(0xFFD1FAE5), const Color(0xFF059669)),
                  _buildStatCard('HELPDESK', '$totalHelpdesk', '$activeHelpdesk aktif', const Color(0xFFD1FAE5), const Color(0xFF059669)),
                  _buildStatCard('REKENING', '$totalRekening', '1 utama', const Color(0xFFDCE9FF), const Color(0xFF003BA5)),
                  _buildStatCard('JURUSAN', '$depts', '$totalTracks peminatan', const Color(0xFFF1F5F9), const Color(0xFF475569)),
                ],
              ),
              const SizedBox(height: 18),

              // Menu Kelola (2x2 Grid)
              const Text('Menu Kelola', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.35,
                children: [
                  _buildMenuCard(Icons.headset_mic_outlined, 'Helpdesk', '$totalHelpdesk layanan', () => onNavigateTab(1)),
                  _buildMenuCard(Icons.account_balance_outlined, 'Nomor Rekening', '$totalRekening rekening VA', () => onNavigateTab(2)),
                  _buildMenuCard(Icons.school_outlined, 'Jurusan & Peminatan', '$depts jurusan, $totalTracks peminatan', () => onNavigateTab(3)),
                  _buildMenuCard(Icons.people_outline_rounded, 'User', '$totalUsers akun', () => onNavigateTab(4)),
                ],
              ),
              const SizedBox(height: 18),

              // Aktivitas Terakhir
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Aktivitas Terakhir', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
                  TextButton.icon(
                    onPressed: store.logout,
                    icon: const Icon(Icons.logout_rounded, size: 15, color: Color(0xFFDC2626)),
                    label: const Text('Logout', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFDC2626))),
                  ),
                ],
              ),
              ...store.auditLogs.take(5).map(
                (log) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(log.result, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                            Text('${log.actor} • ${log.action}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          ],
                        ),
                      ),
                      Text(log.timestamp, style: const TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String pillText, Color pillBg, Color pillTextColor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF64748B))),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF161A30))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: pillBg, borderRadius: BorderRadius.circular(6)),
            child: Text(pillText, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: pillTextColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: const Color(0xFFE8F0FE), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: const Color(0xFF003BA5), size: 20),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Color(0xFF161A30))),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
