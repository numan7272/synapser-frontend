import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SynapserTheme {
  // Apple-style minimal colors
  static const Color backgroundPrimary = Color(0xFFF2F2F7);
  static const Color backgroundSecondary = Colors.white;
  static const Color backgroundTertiary = Color(0xFFE5E5EA);

  static const Color labelPrimary = Color(0xFF000000);
  static const Color labelSecondary = Color(0xFF3C3C43);
  static const Color labelTertiary = Color(0xFF8E8E93);
  static const Color labelQuaternary = Color(0xFFC7C7CC);

  static const Color accentBlue = Color(0xFF007AFF);
  static const Color accentGreen = Color(0xFF34C759);
  static const Color accentOrange = Color(0xFFFF9500);
  static const Color accentRed = Color(0xFFFF3B30);
  static const Color accentPurple = Color(0xFFAF52DE);
  static const Color accentTeal = Color(0xFF5AC8FA);

  static const Color separator = Color(0xFFD1D1D6);
  static const Color errorRed = Color(0xFFFF3B30);

  static const double cardRadius = 16.0;

  static BoxDecoration cardDecoration({
    double? borderRadius,
    Color? backgroundColor,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? backgroundSecondary,
      borderRadius: BorderRadius.circular(borderRadius ?? cardRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration accentCardDecoration(Color accentColor) {
    return BoxDecoration(
      color: accentColor.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(cardRadius),
    );
  }

  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.interTextTheme(
      const TextTheme(
        headlineLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: labelPrimary, letterSpacing: -0.5),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: labelPrimary, letterSpacing: -0.5),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: labelPrimary),
        titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: labelPrimary),
        bodyLarge: TextStyle(fontSize: 17, color: labelPrimary),
        bodyMedium: TextStyle(fontSize: 15, color: labelSecondary),
        bodySmall: TextStyle(fontSize: 13, color: labelTertiary),
        labelLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: accentBlue),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundPrimary,
      textTheme: textTheme,
      colorScheme: const ColorScheme.light(
        primary: accentBlue,
        secondary: accentPurple,
        surface: backgroundSecondary,
        error: errorRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: accentBlue),
        titleTextStyle: TextStyle(
          color: labelPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
