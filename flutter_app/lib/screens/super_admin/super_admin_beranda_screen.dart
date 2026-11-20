import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import 'super_admin_audit_screen.dart';
import 'super_admin_profil_screen.dart';

/// ============================================================================
/// BAGIAN 4A: BERANDA SUPER ADMIN (USER SUPER ADMIN)
/// Sama persis dengan `resources/views/super-admin/dashboard.blade.php`
/// ============================================================================
class SuperAdminBerandaScreen extends StatelessWidget {
  final PmbDataStore store;
  final void Function(int) onNavigateTab;

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
    final mainRekeningCount = store.rekenings.where((r) => r.isMain).length;
    final totalJurusan = store.tracks.map((t) => t.departmentName).toSet().length;
    final totalTracks = store.tracks.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header (`🛡️ PORTAL SUPER ADMIN • POLIBATAM` + Bell Audit + `SA` Profil)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCE9FF),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      '🛡️ PORTAL SUPER ADMIN • POLIBATAM',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: Color(0xFF003BA5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Halo, Super Admin',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF161A30),
                    ),
                  ),
                  const Text(
                    'Kelola data sistem PMB Microcredential',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
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
                          builder: (_) => SuperAdminAuditScreen(store: store),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE8ECF8)),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.notifications_none,
                        size: 18,
                        color: Color(0xFF434655),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SuperAdminProfilScreen(store: store),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDCE9FF),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'SA',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF003BA5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 4 Stat Cards (2x2 Grid)
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  label: 'TOTAL USER',
                  value: '$totalUsers',
                  badgeText: '+$totalUsers minggu ini',
                  badgeBg: const Color(0xFFD1FAE5),
                  badgeTextColor: const Color(0xFF059669),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  label: 'HELPDESK',
                  value: '$totalHelpdesk',
                  badgeText: '$activeHelpdesk aktif',
                  badgeBg: const Color(0xFFD1FAE5),
                  badgeTextColor: const Color(0xFF059669),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  label: 'REKENING',
                  value: '$totalRekening',
                  badgeText: '$mainRekeningCount utama',
                  badgeBg: const Color(0xFFDCE9FF),
                  badgeTextColor: const Color(0xFF003BA5),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  label: 'JURUSAN',
                  value: '$totalJurusan',
                  badgeText: '$totalTracks peminatan',
                  badgeBg: const Color(0xFFF1F5F9),
                  badgeTextColor: const Color(0xFF475569),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Menu Kelola (2x2 Grid)
          const Text(
            'Menu Kelola',
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF161A30),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMenuKelolaCard(
                  icon: Icons.headset_mic_outlined,
                  title: 'Helpdesk',
                  subtitle: '$totalHelpdesk layanan',
                  onTap: () => onNavigateTab(1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMenuKelolaCard(
                  icon: Icons.credit_card_outlined,
                  title: 'Nomor Rekening',
                  subtitle: '$totalRekening rekening VA',
                  onTap: () => onNavigateTab(2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMenuKelolaCard(
                  icon: Icons.account_tree_outlined,
                  title: 'Jurusan & Peminatan',
                  subtitle: '$totalJurusan jurusan, $totalTracks peminatan',
                  onTap: () => onNavigateTab(3),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMenuKelolaCard(
                  icon: Icons.people_outline,
                  title: 'User',
                  subtitle: '$totalUsers akun',
                  onTap: () => onNavigateTab(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Aktivitas Terakhir
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Aktivitas Terakhir',
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF161A30),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SuperAdminAuditScreen(store: store),
                    ),
                  );
                },
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0052CC),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...store.auditLogs.take(4).map((log) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFECEEF8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          log.result,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF161A30),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${log.actor} • ${log.action}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    log.timestamp,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required String badgeText,
    required Color badgeBg,
    required Color badgeTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECEEF8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              height: 1.0,
              fontWeight: FontWeight.w900,
              color: Color(0xFF161A30),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: badgeTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuKelolaCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFECEEF8)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.025),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FE),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: const Color(0xFF003BA5), size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF161A30),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }
}
