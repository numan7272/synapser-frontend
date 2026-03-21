import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/schedule_provider.dart';
import 'providers/suggestion_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/main_shell.dart';
import 'services/storage_service.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('de_DE');
  await initializeDateFormatting('en_US');
  runApp(const SynapserApp());
}

class SynapserApp extends StatelessWidget {
  const SynapserApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = StorageService();
    final apiService = ApiService(storageService);
    final authService = AuthService(apiService, storageService);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService, apiService),
        ),
        ChangeNotifierProvider(
          create: (_) => ScheduleProvider(apiService),
        ),
        ChangeNotifierProvider(
          create: (_) => SuggestionProvider(apiService),
        ),
      ],
      child: MaterialApp(
        title: 'Synapser',
        debugShowCheckedModeBanner: false,
        theme: SynapserTheme.liquidGlassTheme,
        locale: const Locale('de', 'DE'),
        supportedLocales: const [
          Locale('de', 'DE'),
          Locale('en', 'US'),
        ],
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        home: const _AuthGate(),
      ),
    );
  }
}

class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AuthProvider>().tryAutoLogin());
  }

  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthProvider>().status;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: switch (authStatus) {
        AuthStatus.initial || AuthStatus.loading => const SplashScreen(),
        AuthStatus.unauthenticated => const LoginScreen(),
        AuthStatus.onboardingRequired => const OnboardingScreen(),
        AuthStatus.authenticated => const MainShell(),
      },
    );
  }
}
