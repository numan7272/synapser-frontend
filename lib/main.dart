import 'package:flutter/material.dart';
// Importiere den neuen Test-Screen
import 'package:synapser_frontend/screens/glass_test_screen.dart';

void main() {
  runApp(const SynapserApp());
}

class SynapserApp extends StatelessWidget {
  const SynapserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Synapser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1C1C1E),
        fontFamily: '.SF Pro Display',
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF63E6BE),
          secondary: Color(0xFF63E6BE),
          surface: Color(0xFF2C2C2E),
          onSurface: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2C2C2E),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          labelStyle: const TextStyle(color: Colors.white54),
        ),
        useMaterial3: true,
      ),
      // Leite die App zum Start auf den Test-Screen um
      home: const GlassTestScreen(),
    );
  }
}
