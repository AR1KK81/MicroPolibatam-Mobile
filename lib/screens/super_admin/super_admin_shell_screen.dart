import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import '../../widgets/pmb_widgets.dart';
import 'super_admin_beranda_screen.dart';
import 'super_admin_helpdesk_screen.dart';
import 'super_admin_rekening_screen.dart';
import 'super_admin_jurusan_screen.dart';
import 'super_admin_users_screen.dart';

/// ============================================================================
/// BAGIAN 4: SHELL UTAMA USER SUPER ADMIN
/// Mengelompokkan 5 halaman utama Super Admin sesuai `components/super-admin-nav.blade.php`:
/// 1. Beranda  2. Helpdesk  3. Rekening  4. Jurusan  5. User
/// ============================================================================
class SuperAdminShellScreen extends StatefulWidget {
  final PmbDataStore store;

  const SuperAdminShellScreen({super.key, required this.store});

  @override
  State<SuperAdminShellScreen> createState() => _SuperAdminShellScreenState();
}

class _SuperAdminShellScreenState extends State<SuperAdminShellScreen> {
  int _selectedIndex = 0;

  void _switchTab(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      SuperAdminBerandaScreen(store: widget.store, onNavigateTab: _switchTab),
      SuperAdminHelpdeskScreen(store: widget.store),
      SuperAdminRekeningScreen(store: widget.store),
      SuperAdminJurusanScreen(store: widget.store),
      SuperAdminUsersScreen(store: widget.store),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: PmbBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _switchTab,
        showActivePill: true,
        items: const [
          PmbNavItem(
            label: 'Beranda',
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
          ),
          PmbNavItem(
            label: 'Helpdesk',
            icon: Icons.headset_mic_outlined,
            activeIcon: Icons.headset_mic,
          ),
          PmbNavItem(
            label: 'Rekening',
            icon: Icons.credit_card_outlined,
            activeIcon: Icons.credit_card,
          ),
          PmbNavItem(
            label: 'Jurusan',
            icon: Icons.account_tree_outlined,
            activeIcon: Icons.account_tree,
          ),
          PmbNavItem(
            label: 'User',
            icon: Icons.people_outline,
            activeIcon: Icons.people,
          ),
        ],
      ),
    );
  }
}
