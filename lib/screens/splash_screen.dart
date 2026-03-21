import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SynapserTheme.auroraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo with gradient glow
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: SynapserTheme.gradientPrimary,
                  borderRadius: BorderRadius.circular(SynapserTheme.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: SynapserTheme.accentBlue.withValues(alpha: 0.4),
                      blurRadius: 28,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 2000.ms),
              const SizedBox(height: 28),
              const Text(
                'Synapser',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: SynapserTheme.textPrimary,
                  letterSpacing: -0.5,
                ),
              )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: 0.3, curve: Curves.easeOutCubic),
              const SizedBox(height: 8),
              const Text(
                'KI-gestützter Lebensplaner',
                style: TextStyle(
                  fontSize: 15,
                  color: SynapserTheme.textMuted,
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
              const SizedBox(height: 48),
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: SynapserTheme.accentCyan,
                ),
              ).animate().fadeIn(delay: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}
