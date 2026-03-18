import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SynapserTheme {
  // iOS 26 Liquid Glass - Base colors
  static const Color backgroundLight = Color(0xFFF0F2F5);
  static const Color backgroundWhite = Color(0xFFFFFFFF);

  // Vibrant tint colors (show through glass)
  static const Color tintBlue = Color(0xFF007AFF);
  static const Color tintPurple = Color(0xFFBF5AF2);
  static const Color tintGreen = Color(0xFF30D158);
  static const Color tintOrange = Color(0xFFFF9F0A);
  static const Color tintRed = Color(0xFFFF453A);
  static const Color tintCyan = Color(0xFF64D2FF);
  static const Color tintMint = Color(0xFF66D4CF);
  static const Color tintIndigo = Color(0xFF5E5CE6);

  // Text colors
  static const Color labelPrimary = Color(0xFF1C1C1E);
  static const Color labelSecondary = Color(0xFF636366);
  static const Color labelTertiary = Color(0xFFAEAEB2);

  static const Color errorRed = Color(0xFFFF453A);

  // Liquid Glass constants
  static const double glassRadius = 22.0;
  static const double glassBlurSigma = 40.0;
  static const double glassOpacity = 0.45;
  static const double glassBorderOpacity = 0.35;
  static const double glassSpecularOpacity = 0.5;

  /// Liquid Glass material - translucent with strong blur and specular edge
  static BoxDecoration liquidGlassDecoration({
    double? borderRadius,
    Color? tintColor,
    double? opacity,
  }) {
    final tint = tintColor ?? Colors.white;
    final op = opacity ?? glassOpacity;
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          tint.withValues(alpha: op),
          tint.withValues(alpha: op * 0.6),
        ],
      ),
      borderRadius: BorderRadius.circular(borderRadius ?? glassRadius),
      border: Border.all(
        color: Colors.white.withValues(alpha: glassBorderOpacity),
        width: 0.5,
      ),
      boxShadow: [
        // Outer shadow for depth
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
          spreadRadius: -4,
        ),
        // Inner specular highlight (simulated)
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.25),
          blurRadius: 1,
          offset: const Offset(0, 0.5),
        ),
      ],
    );
  }

  /// Tinted Liquid Glass with color accent
  static BoxDecoration tintedGlassDecoration(Color accentColor) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          accentColor.withValues(alpha: 0.18),
          accentColor.withValues(alpha: 0.08),
        ],
      ),
      borderRadius: BorderRadius.circular(glassRadius),
      border: Border.all(
        color: accentColor.withValues(alpha: 0.25),
        width: 0.5,
      ),
    );
  }

  /// Vibrant mesh gradient background
  static Widget meshGradientBackground({Widget? child}) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-1.0, -1.0),
          end: Alignment(1.0, 1.0),
          colors: [
            Color(0xFFE8F0FE), // Light blue
            Color(0xFFF5EEFF), // Light purple
            Color(0xFFFFF0F0), // Light pink
            Color(0xFFF0F8FF), // Ice blue
          ],
          stops: [0.0, 0.3, 0.6, 1.0],
        ),
      ),
      child: child,
    );
  }

  static ThemeData get liquidGlassTheme {
    final textTheme = GoogleFonts.interTextTheme(
      const TextTheme(
        headlineLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: labelPrimary, letterSpacing: -0.5),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: labelPrimary, letterSpacing: -0.5),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: labelPrimary),
        titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: labelPrimary),
        bodyLarge: TextStyle(fontSize: 17, color: labelPrimary),
        bodyMedium: TextStyle(fontSize: 15, color: labelSecondary),
        bodySmall: TextStyle(fontSize: 13, color: labelTertiary),
        labelLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: tintBlue),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: textTheme,
      colorScheme: const ColorScheme.light(
        primary: tintBlue,
        secondary: tintPurple,
        surface: backgroundWhite,
        error: errorRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: tintBlue),
        titleTextStyle: TextStyle(
          color: labelPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
