import 'package:flutter/material.dart';
import '../config/theme.dart';

class GlassLoadingOverlay extends StatelessWidget {
  final String? message;

  const GlassLoadingOverlay({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.15),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: SynapserTheme.cardDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: SynapserTheme.accentBlue,
                ),
              ),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(
                  message!,
                  style: const TextStyle(
                    color: SynapserTheme.labelSecondary,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
