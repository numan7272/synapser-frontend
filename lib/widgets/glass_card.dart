import 'dart:ui';
import 'package:flutter/material.dart';
import '../config/theme.dart';

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
    final radius = borderRadius ?? SynapserTheme.glassRadius;

    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: SynapserTheme.glassBlurSigma,
          sigmaY: SynapserTheme.glassBlurSigma,
        ),
        child: Container(
          decoration: accentColor != null
              ? SynapserTheme.tintedGlassDecoration(accentColor!)
              : SynapserTheme.liquidGlassDecoration(borderRadius: radius),
          padding: padding ?? const EdgeInsets.all(20),
          child: child,
        ),
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
