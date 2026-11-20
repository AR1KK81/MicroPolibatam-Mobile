import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import 'keuangan_kelola_bayar_screen.dart';
import 'keuangan_riwayat_screen.dart';
import 'keuangan_profil_screen.dart';

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
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE8F0FE),
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.credit_card_outlined),
            selectedIcon: Icon(Icons.credit_card_rounded, color: Color(0xFF0052CC)),
            label: 'Kelola Bayar',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_rounded),
            selectedIcon: Icon(Icons.history_rounded, color: Color(0xFF0052CC)),
            label: 'Riwayat Bayar',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: Color(0xFF0052CC)),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
