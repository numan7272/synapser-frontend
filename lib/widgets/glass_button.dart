import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as lg;
import '../config/theme.dart';

class GlassButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isPrimary;
  final IconData? icon;
  final Color? color;

  const GlassButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isPrimary = true,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = color ?? SynapserTheme.tintBlue;

    return lg.GlassButton.custom(
      onTap: isLoading ? () {} : (onPressed ?? () {}),
      enabled: !isLoading && onPressed != null,
      width: double.infinity,
      height: 48,
      shape: const lg.LiquidRoundedSuperellipse(borderRadius: 16),
      settings: lg.LiquidGlassSettings(
        thickness: isPrimary ? 35 : 25,
        blur: 10,
        glassColor: isPrimary
            ? accentColor.withOpacity(0.6)
            : Colors.white.withOpacity(0.3),
      ),
      glowColor: isPrimary ? accentColor : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: isPrimary ? Colors.white : SynapserTheme.labelPrimary,
              ),
            )
          else ...[
            if (icon != null) ...[
              Icon(icon, size: 18,
                  color: isPrimary ? Colors.white : SynapserTheme.labelPrimary),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.white : SynapserTheme.labelPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
