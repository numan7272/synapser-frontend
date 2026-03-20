import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as lg;

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final Color? accentColor;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = lg.GlassCard(
      useOwnLayer: true,
      settings: lg.LiquidGlassSettings(
        thickness: 30,
        blur: 12,
        glassColor: accentColor?.withValues(alpha: 0.15) ?? Colors.white.withValues(alpha: 0.1),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(20),
        child: child,
      ),
    );

    if (margin != null) {
      card = Padding(padding: margin!, child: card);
    }

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }

    return card;
  }
}
