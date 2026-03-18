import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as lg;
import '../config/theme.dart';

class GlassLoadingOverlay extends StatelessWidget {
  final String? message;

  const GlassLoadingOverlay({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.15),
      child: Center(
        child: lg.GlassCard(
          useOwnLayer: true,
          settings: lg.LiquidGlassSettings(
            thickness: 30,
            blur: 15,
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                lg.GlassProgressIndicator.circular(
                  size: 36,
                  strokeWidth: 3,
                  color: SynapserTheme.tintBlue,
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
      ),
    );
  }
}
