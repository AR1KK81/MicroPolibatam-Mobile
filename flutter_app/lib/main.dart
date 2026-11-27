import 'package:flutter/material.dart';
import 'services/pmb_data_store.dart';
import 'screens/auth/login_screen.dart';
import 'screens/maba/maba_shell_screen.dart';
import 'screens/admin/admin_shell_screen.dart';
import 'screens/keuangan/keuangan_shell_screen.dart';
import 'screens/super_admin/super_admin_shell_screen.dart';

void main() {
  runApp(const MicroPolibatamApp());
}

class MicroPolibatamApp extends StatefulWidget {
  const MicroPolibatamApp({super.key});

  @override
  State<MicroPolibatamApp> createState() => _MicroPolibatamAppState();
}

class _MicroPolibatamAppState extends State<MicroPolibatamApp> {
  final PmbDataStore store = PmbDataStore.instance;

  @override
  void initState() {
    super.initState();
    store.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    store.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  /// Pembungkus frame mobile `max-w-[430px]` dengan latar luar `#EEF2FA` dan bayangan halus
  /// sama persis seperti `<div class="min-h-screen bg-[#EEF2FA] flex justify-center"><div class="w-full max-w-[430px] ...">` di Blade Views
  Widget _wrapMobileFrame(Widget child) {
    return ColoredBox(
      color: const Color(0xFFEEF2FA),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 430),
          decoration: BoxDecoration(
            color: const Color(0xFFFBF8FF),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.06),
                blurRadius: 40,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = store.currentUser;

    Widget homeScreen;
    if (currentUser == null) {
      // Halaman Login menggunakan full-width gradient persis seperti `resources/views/auth/login.blade.php`
      homeScreen = LoginScreen(store: store);
    } else {
      Widget roleShell;
      switch (currentUser.role) {
        case 'admin':
          roleShell = AdminShellScreen(store: store);
          break;
        case 'keuangan':
          roleShell = KeuanganShellScreen(store: store);
          break;
        case 'super_admin':
          roleShell = SuperAdminShellScreen(store: store);
          break;
        case 'maba':
        default:
          roleShell = MabaShellScreen(store: store);
          break;
      }
      homeScreen = _wrapMobileFrame(roleShell);
    }

    return MaterialApp(
      title: 'Masuk — Sistem PMB Microcredential Polibatam',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFBF8FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0052CC),
          primary: const Color(0xFF0052CC),
          secondary: const Color(0xFF003BA5),
          surface: Colors.white,
        ),
        fontFamily: 'Segoe UI',
      ),
      home: homeScreen,
    );
  }
}
