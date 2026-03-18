import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../config/theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SynapserTheme.meshGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Liquid Glass logo
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          SynapserTheme.tintBlue.withValues(alpha: 0.6),
                          SynapserTheme.tintPurple.withValues(alpha: 0.4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 0.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: SynapserTheme.tintBlue.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 2000.ms),
              const SizedBox(height: 28),
              const Text(
                'Synapser',
                style: TextStyle(
                  fontSize: 36,
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
                  color: SynapserTheme.tintBlue,
                ),
              ).animate().fadeIn(delay: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}
