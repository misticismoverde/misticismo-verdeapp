import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/arvore_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/perfil_screen.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await NotificationService.instance.initialize();
  await NotificationService.instance.requestPermissions();
  await NotificationService.instance.scheduleDailyNotification();

  runApp(const MisticismoVerdeApp());
}

class MisticismoVerdeApp extends StatelessWidget {
  const MisticismoVerdeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Misticismo Verde',
      debugShowCheckedModeBanner: false,
      navigatorKey: appNavigatorKey,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F0E8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A3D1F),
          primary: const Color(0xFF0A3D1F),
          secondary: const Color(0xFF4CAF50),
          surface: const Color(0xFFF5F0E8),
        ),
        textTheme: GoogleFonts.openSansTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFFF5F0E8),
          foregroundColor: const Color(0xFF2C1810),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.playfairDisplay(
            color: const Color(0xFF0A3D1F),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      routes: {
        '/onboarding': (_) => const OnboardingScreen(),
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(),
        '/arvore': (_) => const ArvoreScreen(),
        '/perfil': (_) => const PerfilScreen(),
      },
      home: const InitialRouter(),
    );
  }
}

class InitialRouter extends StatelessWidget {
  const InitialRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingVisto = StorageService.isOnboardingSeen();
    final email = StorageService.getEmail();

    if (!onboardingVisto) {
      return const OnboardingScreen();
    }

    if (email.isNotEmpty) {
      return const HomeScreen();
    }

    return const LoginScreen();
  }
}