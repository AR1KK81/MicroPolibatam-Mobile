import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import 'maba_beranda_screen.dart';
import 'maba_status_screen.dart';
import 'maba_profil_screen.dart';
import 'maba_formulir_screen.dart';

class MabaShellScreen extends StatefulWidget {
  final PmbDataStore store;

  const MabaShellScreen({super.key, required this.store});

  @override
  State<MabaShellScreen> createState() => _MabaShellScreenState();
}

class _MabaShellScreenState extends State<MabaShellScreen> {
  int _selectedIndex = 0;

  void _openFormulir({int initialTab = 0}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MabaFormulirScreen(store: widget.store, initialTab: initialTab),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      MabaBerandaScreen(
        store: widget.store,
        onOpenFormulir: (tab) => _openFormulir(initialTab: tab),
        onSwitchTab: (idx) => setState(() => _selectedIndex = idx),
      ),
      MabaStatusScreen(
        store: widget.store,
        onOpenFormulir: (tab) => _openFormulir(initialTab: tab),
      ),
      MabaProfilScreen(
        store: widget.store,
        onOpenFormulir: () => _openFormulir(initialTab: 0),
      ),
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
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: Color(0xFF003BA5)),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.fact_check_outlined),
            selectedIcon: Icon(Icons.fact_check_rounded, color: Color(0xFF003BA5)),
            label: 'Status',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: Color(0xFF003BA5)),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
