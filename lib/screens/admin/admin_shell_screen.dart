import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import '../../widgets/pmb_widgets.dart';
import 'admin_kelola_berkas_screen.dart';
import 'admin_riwayat_screen.dart';
import 'admin_profil_screen.dart';

/// ============================================================================
/// BAGIAN 2: SHELL UTAMA USER ADMIN AKADEMIK (STAF ADMISI & REGISTRASI)
/// Mengelompokkan 3 halaman utama Admin: Kelola Berkas, Riwayat, dan Profil
/// ============================================================================
class AdminShellScreen extends StatefulWidget {
  final PmbDataStore store;

  const AdminShellScreen({super.key, required this.store});

  @override
  State<AdminShellScreen> createState() => _AdminShellScreenState();
}

class _AdminShellScreenState extends State<AdminShellScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      AdminKelolaBerkasScreen(store: widget.store),
      AdminRiwayatScreen(store: widget.store),
      AdminProfilScreen(store: widget.store),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: PmbBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (idx) => setState(() => _selectedIndex = idx),
        items: const [
          PmbNavItem(
            label: 'Kelola Berkas',
            icon: Icons.description_outlined,
            activeIcon: Icons.description,
          ),
          PmbNavItem(
            label: 'Riwayat',
            icon: Icons.history_outlined,
            activeIcon: Icons.history,
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
