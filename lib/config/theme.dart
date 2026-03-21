import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SynapserTheme {
  // ── Aurora Dark - Core Palette ──
  static const Color bgPrimary = Color(0xFF0D0D12);
  static const Color bgSecondary = Color(0xFF14141F);
  static const Color bgCard = Color(0xFF1A1A2E);
  static const Color bgCardHover = Color(0xFF22223A);
  static const Color bgSurface = Color(0xFF16162A);

  // Accent gradients
  static const Color accentBlue = Color(0xFF6C63FF);
  static const Color accentCyan = Color(0xFF00D4FF);
  static const Color accentPurple = Color(0xFFA855F7);
  static const Color accentPink = Color(0xFFEC4899);
  static const Color accentGreen = Color(0xFF22C55E);
  static const Color accentOrange = Color(0xFFF97316);
  static const Color accentRed = Color(0xFFEF4444);

  // Text
  static const Color textPrimary = Color(0xFFF1F1F6);
  static const Color textSecondary = Color(0xFF9CA3B0);
  static const Color textMuted = Color(0xFF5A5F73);

  // Borders
  static const Color borderSubtle = Color(0xFF2A2A40);
  static const Color borderGlow = Color(0xFF6C63FF);

  // Card radius
  static const double radiusSm = 12.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 24.0;

  /// Primary gradient (Blue → Cyan)
  static const LinearGradient gradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentBlue, accentCyan],
  );

  /// Secondary gradient (Purple → Pink)
  static const LinearGradient gradientSecondary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentPurple, accentPink],
  );

  /// Aurora background gradient
  static const LinearGradient gradientAurora = LinearGradient(
    begin: Alignment(-1.0, -1.0),
    end: Alignment(1.0, 1.0),
    colors: [
      Color(0xFF0D0D12),
      Color(0xFF12122B),
      Color(0xFF0F1A2E),
      Color(0xFF0D0D12),
    ],
    stops: [0.0, 0.35, 0.65, 1.0],
  );

  /// Card decoration with subtle border and glow
  static BoxDecoration cardDecoration({
    Color? glowColor,
    double radius = radiusLg,
  }) {
    return BoxDecoration(
      color: bgCard,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: glowColor?.withValues(alpha: 0.15) ?? borderSubtle,
        width: 1,
      ),
      boxShadow: glowColor != null
          ? [
              BoxShadow(
                color: glowColor.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
                spreadRadius: -4,
              ),
            ]
          : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
                spreadRadius: -2,
              ),
            ],
    );
  }

  /// Gradient border decoration for highlighted cards
  static Widget gradientBorderCard({
    required Widget child,
    Gradient gradient = gradientPrimary,
    double radius = radiusLg,
    double borderWidth = 1.5,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    Widget card = Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Container(
        margin: EdgeInsets.all(borderWidth),
        decoration: BoxDecoration(
          color: bgCard,
          borderRadius: BorderRadius.circular(radius - borderWidth),
        ),
        padding: padding ?? const EdgeInsets.all(20),
        child: child,
      ),
    );

    if (margin != null) {
      card = Padding(padding: margin, child: card);
    }

    return card;
  }

  /// Aurora dark background
  static Widget auroraBackground({Widget? child}) {
    return Container(
      decoration: const BoxDecoration(gradient: gradientAurora),
      child: child,
    );
  }

  static ThemeData get liquidGlassTheme {
    final textTheme = GoogleFonts.interTextTheme(
      const TextTheme(
        headlineLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: textPrimary, letterSpacing: -0.5),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textPrimary, letterSpacing: -0.5),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary),
        titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: textPrimary),
        bodyLarge: TextStyle(fontSize: 17, color: textPrimary),
        bodyMedium: TextStyle(fontSize: 15, color: textSecondary),
        bodySmall: TextStyle(fontSize: 13, color: textMuted),
        labelLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: accentBlue),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgPrimary,
      textTheme: textTheme,
      colorScheme: const ColorScheme.dark(
        primary: accentBlue,
        secondary: accentPurple,
        surface: bgCard,
        error: accentRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: accentBlue),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
