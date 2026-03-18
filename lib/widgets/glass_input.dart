import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as lg;
import '../config/theme.dart';

class GlassTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;

  const GlassTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    // Use the package's GlassTextField for the glass rendering layer,
    // wrapping a standard TextFormField for full form support
    return lg.GlassContainer(
      useOwnLayer: true,
      settings: lg.LiquidGlassSettings(
        thickness: 20,
        blur: 8,
        glassColor: Colors.white.withOpacity(0.15),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        onChanged: onChanged,
        textInputAction: textInputAction,
        onEditingComplete: onEditingComplete,
        style: const TextStyle(color: SynapserTheme.labelPrimary, fontSize: 17),
        cursorColor: SynapserTheme.tintBlue,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          hintStyle: const TextStyle(color: SynapserTheme.labelTertiary),
          labelStyle: const TextStyle(color: SynapserTheme.labelSecondary),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: SynapserTheme.tintBlue.withOpacity(0.6), width: 1.5),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: SynapserTheme.errorRed),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: SynapserTheme.errorRed, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
