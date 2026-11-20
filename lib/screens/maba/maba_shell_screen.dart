import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import '../../widgets/pmb_widgets.dart';
import 'maba_beranda_screen.dart';
import 'maba_status_screen.dart';
import 'maba_profil_screen.dart';

/// ============================================================================
/// BAGIAN 1: SHELL UTAMA USER MABA (CALON MAHASISWA BARU)
/// Mengelompokkan 3 halaman utama Maba: Beranda, Status, dan Profil
/// ============================================================================
class MabaShellScreen extends StatefulWidget {
  final PmbDataStore store;

  const MabaShellScreen({super.key, required this.store});

  @override
  State<MabaShellScreen> createState() => _MabaShellScreenState();
}

class _MabaShellScreenState extends State<MabaShellScreen> {
  int _selectedIndex = 0;

  void _switchTab(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      MabaBerandaScreen(store: widget.store, onSwitchTab: _switchTab),
      MabaStatusScreen(store: widget.store, onSwitchTab: _switchTab),
      MabaProfilScreen(store: widget.store, onSwitchTab: _switchTab),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: PmbBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _switchTab,
        items: const [
          PmbNavItem(
            label: 'Beranda',
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
          ),
          PmbNavItem(
            label: 'Status',
            icon: Icons.fact_check_outlined,
            activeIcon: Icons.fact_check,
          ),
          PmbNavItem(
            label: 'Profil',
            icon: Icons.person_outline,
            activeIcon: Icons.person,
          ),
        ],
      ),
    );
  }
}
