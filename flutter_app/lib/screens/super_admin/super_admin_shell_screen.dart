import 'package:flutter/material.dart';
import '../../services/pmb_data_store.dart';
import 'super_admin_beranda_screen.dart';
import 'super_admin_helpdesk_screen.dart';
import 'super_admin_rekening_screen.dart';
import 'super_admin_jurusan_screen.dart';
import 'super_admin_users_screen.dart';

class SuperAdminShellScreen extends StatefulWidget {
  final PmbDataStore store;

  const SuperAdminShellScreen({super.key, required this.store});

  @override
  State<SuperAdminShellScreen> createState() => _SuperAdminShellScreenState();
}

class _SuperAdminShellScreenState extends State<SuperAdminShellScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      SuperAdminBerandaScreen(
        store: widget.store,
        onNavigateTab: (idx) => setState(() => _selectedIndex = idx),
      ),
      SuperAdminHelpdeskScreen(store: widget.store),
      SuperAdminRekeningScreen(store: widget.store),
      SuperAdminJurusanScreen(store: widget.store),
      SuperAdminUsersScreen(store: widget.store),
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
            selectedIcon: Icon(Icons.home_rounded, color: Color(0xFF0052CC)),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.headset_mic_outlined),
            selectedIcon: Icon(Icons.headset_mic_rounded, color: Color(0xFF0052CC)),
            label: 'Helpdesk',
          ),
          NavigationDestination(
            icon: Icon(Icons.credit_card_outlined),
            selectedIcon: Icon(Icons.credit_card_rounded, color: Color(0xFF0052CC)),
            label: 'Rekening',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school_rounded, color: Color(0xFF0052CC)),
            label: 'Jurusan',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline_rounded),
            selectedIcon: Icon(Icons.people_rounded, color: Color(0xFF0052CC)),
            label: 'User',
          ),
        ],
      ),
    );
  }
}
