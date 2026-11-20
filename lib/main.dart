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

  @override
  Widget build(BuildContext context) {
    final currentUser = store.currentUser;

    Widget homeScreen;
    if (currentUser == null) {
      homeScreen = LoginScreen(store: store);
    } else {
      switch (currentUser.role) {
        case 'admin':
          homeScreen = AdminShellScreen(store: store);
          break;
        case 'keuangan':
          homeScreen = KeuanganShellScreen(store: store);
          break;
        case 'super_admin':
          homeScreen = SuperAdminShellScreen(store: store);
          break;
        case 'maba':
        default:
          homeScreen = MabaShellScreen(store: store);
          break;
      }
    }

    return MaterialApp(
      title: 'Sistem PMB Microcredential Polibatam',
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
      home: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: homeScreen,
        ),
      ),
    );
  }
}
