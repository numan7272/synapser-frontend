import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

// --- FARBPALETTE ---
class LiquidColors {
  static const Color background = Color(0xFF050505);
  static const Color accent = CupertinoColors.systemCyan;
  static const Color glassBorder = Color(0x1AFFFFFF); // 10% Weiß
  static const Color glassBase = Color(0x0DFFFFFF); // 5% Weiß
}

// --- GLASS CONTAINER ---
class LiquidGlass extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double intensity;
  final VoidCallback? onTap;

  const LiquidGlass({
    super.key,
    required this.child,
    this.padding,
    this.intensity = 1.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: 20 * intensity, sigmaY: 20 * intensity),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: LiquidColors.glassBase.withOpacity(0.1 * intensity),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: LiquidColors.glassBorder, width: 0.5),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.15 * intensity),
                Colors.white.withOpacity(0.05 * intensity),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: content,
      );
    }
    return content;
  }
}

// --- HINTERGRUND ---
class LiquidBackground extends StatelessWidget {
  const LiquidBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: LiquidColors.background),
        // Atmosphärische Blobs
        Positioned(
            top: -150,
            right: -100,
            child: _Blob(color: const Color(0xFF0055FF), size: 500)),
        Positioned(
            bottom: 50,
            left: -100,
            child: _Blob(color: const Color(0xFF00DDFF), size: 400)),
        Positioned(
            top: 300,
            left: 50,
            child: _Blob(
                color: const Color(0xFFFF0055).withOpacity(0.3), size: 300)),
        // Noise Filter für Texture
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  const _Blob({required this.color, required this.size});
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: color.withOpacity(0.5)),
      );
}
