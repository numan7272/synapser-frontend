import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: SynapserTheme.backgroundGradient),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    SynapserTheme.accentTeal.withValues(alpha: 0.3),
                    SynapserTheme.accentPurple.withValues(alpha: 0.3),
                  ],
                ),
                border: Border.all(
                  color: SynapserTheme.accentTeal.withValues(alpha: 0.4),
                ),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: SynapserTheme.accentTeal,
                size: 36,
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .shimmer(duration: 2000.ms, color: Colors.white24),
            const SizedBox(height: 24),
            // App Name
            const Text(
              'Synapser',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            )
                .animate()
                .fadeIn(duration: 800.ms)
                .slideY(begin: 0.3, curve: Curves.easeOutCubic),
            const SizedBox(height: 8),
            Text(
              'KI-gestützter Lebensplaner',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 600.ms),
            const SizedBox(height: 48),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: SynapserTheme.accentTeal,
              ),
            ).animate().fadeIn(delay: 600.ms),
          ],
        ),
      ),
    );
  }
}
