import 'dart:ui';
import 'package:flutter/material.dart';
import '../config/theme.dart';

class GlassButton extends StatefulWidget {
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
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.color ?? SynapserTheme.tintBlue;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        if (!widget.isLoading) widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedOpacity(
          opacity: _pressed ? 0.7 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  gradient: widget.isPrimary
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            accentColor.withValues(alpha: 0.85),
                            accentColor.withValues(alpha: 0.65),
                          ],
                        )
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.55),
                            Colors.white.withValues(alpha: 0.35),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.isPrimary
                        ? Colors.white.withValues(alpha: 0.3)
                        : Colors.white.withValues(alpha: 0.5),
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.isPrimary
                          ? accentColor.withValues(alpha: 0.25)
                          : Colors.black.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.isLoading)
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: widget.isPrimary
                              ? Colors.white
                              : SynapserTheme.labelPrimary,
                        ),
                      )
                    else ...[
                      if (widget.icon != null) ...[
                        Icon(widget.icon, size: 18,
                            color: widget.isPrimary
                                ? Colors.white
                                : SynapserTheme.labelPrimary),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.label,
                        style: TextStyle(
                          color: widget.isPrimary
                              ? Colors.white
                              : SynapserTheme.labelPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
