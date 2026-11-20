import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import '../../widgets/pmb_widgets.dart';
import 'keuangan_kelola_bayar_screen.dart';
import 'keuangan_riwayat_screen.dart';
import 'keuangan_profil_screen.dart';

/// ============================================================================
/// BAGIAN 3: SHELL UTAMA USER STAF KEUANGAN
/// Mengelompokkan 3 halaman utama Staf Keuangan: Kelola Bayar, Riwayat Bayar, Profil
/// ============================================================================
class KeuanganShellScreen extends StatefulWidget {
  final PmbDataStore store;

  const KeuanganShellScreen({super.key, required this.store});

  @override
  State<KeuanganShellScreen> createState() => _KeuanganShellScreenState();
}

class _KeuanganShellScreenState extends State<KeuanganShellScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      KeuanganKelolaBayarScreen(store: widget.store),
      KeuanganRiwayatScreen(store: widget.store),
      KeuanganProfilScreen(store: widget.store),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: PmbBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (idx) => setState(() => _selectedIndex = idx),
        items: const [
          PmbNavItem(
            label: 'Kelola Bayar',
            icon: Icons.payments_outlined,
            activeIcon: Icons.payments,
          ),
          PmbNavItem(
            label: 'Riwayat Bayar',
            icon: Icons.receipt_long_outlined,
            activeIcon: Icons.receipt_long,
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
