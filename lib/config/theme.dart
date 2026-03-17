import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SynapserTheme {
  // Farben
  static const Color backgroundDark = Color(0xFF0A0E21);
  static const Color backgroundMid = Color(0xFF1A1A3E);
  static const Color backgroundLight = Color(0xFF0D2137);
  static const Color accentTeal = Color(0xFF00D4AA);
  static const Color accentPurple = Color(0xFF7B61FF);
  static const Color accentOrange = Color(0xFFFF8A65);
  static const Color accentAmber = Color(0xFFFFCA28);
  static const Color glassWhite = Colors.white;
  static const Color errorRed = Color(0xFFFF5252);

  // Glass Konstanten
  static const double glassRadius = 24.0;
  static const double glassBorderOpacity = 0.15;
  static const double glassBackgroundOpacity = 0.08;
  static const double glassBlurSigma = 20.0;

  static BoxDecoration glassDecoration({
    double? borderRadius,
    double? backgroundOpacity,
    Color? borderColor,
  }) {
    return BoxDecoration(
      color: glassWhite.withValues(alpha: backgroundOpacity ?? glassBackgroundOpacity),
      borderRadius: BorderRadius.circular(borderRadius ?? glassRadius),
      border: Border.all(
        color: (borderColor ?? glassWhite).withValues(alpha: glassBorderOpacity),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  static BoxDecoration accentGlassDecoration(Color accentColor) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          accentColor.withValues(alpha: 0.2),
          accentColor.withValues(alpha: 0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(glassRadius),
      border: Border.all(
        color: accentColor.withValues(alpha: 0.3),
        width: 1,
      ),
    );
  }

  static LinearGradient backgroundGradient = const LinearGradient(
    colors: [backgroundDark, backgroundMid, backgroundLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Widget backgroundContainer({Widget? child}) {
    return Container(
      decoration: BoxDecoration(gradient: backgroundGradient),
      child: child,
    );
  }

  static ThemeData get darkTheme {
    final textTheme = GoogleFonts.interTextTheme(
      const TextTheme(
        headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
        bodySmall: TextStyle(fontSize: 12, color: Colors.white54),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: textTheme,
      colorScheme: const ColorScheme.dark(
        primary: accentTeal,
        secondary: accentPurple,
        surface: backgroundDark,
        error: errorRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
