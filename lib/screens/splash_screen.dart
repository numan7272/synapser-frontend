import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SynapserTheme.backgroundPrimary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: SynapserTheme.accentBlue,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 32,
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 1500.ms),
            const SizedBox(height: 24),
            const Text(
              'Synapser',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: SynapserTheme.labelPrimary,
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
                color: SynapserTheme.labelTertiary,
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
            const SizedBox(height: 48),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: SynapserTheme.accentBlue,
              ),
            ).animate().fadeIn(delay: 600.ms),
          ],
        ),
      ),
    );
  }
}
