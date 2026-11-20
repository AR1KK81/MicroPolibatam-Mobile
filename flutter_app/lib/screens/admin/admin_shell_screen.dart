import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import 'admin_kelola_berkas_screen.dart';
import 'admin_riwayat_screen.dart';
import 'admin_profil_screen.dart';

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
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE8F0FE),
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment_rounded, color: Color(0xFF0052CC)),
            label: 'Kelola Berkas',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_rounded),
            selectedIcon: Icon(Icons.history_rounded, color: Color(0xFF0052CC)),
            label: 'Riwayat',
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
