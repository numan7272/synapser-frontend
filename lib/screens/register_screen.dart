import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../l10n/l10n.dart';
import '../providers/auth_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_button.dart';
import '../widgets/glass_input.dart';
import '../widgets/glass_toast.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!success && mounted) {
      GlassToast.show(
        context,
        message: authProvider.error ?? S.of(context).registerError,
        type: ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final s = S.of(context);

    return Scaffold(
      backgroundColor: SynapserTheme.backgroundPrimary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: SynapserTheme.accentBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          s.createAccount,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: SynapserTheme.labelPrimary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        GlassTextField(
                          controller: _emailController,
                          hintText: s.email,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(Icons.email_outlined,
                              color: SynapserTheme.labelTertiary),
                          validator: (v) {
                            if (v == null || !v.contains('@')) {
                              return s.invalidEmail;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        GlassTextField(
                          controller: _passwordController,
                          hintText: s.password,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(Icons.lock_outline_rounded,
                              color: SynapserTheme.labelTertiary),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: SynapserTheme.labelTertiary,
                            ),
                            onPressed: () =>
                                setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          validator: (v) {
                            if (v == null || v.length < 8) {
                              return s.passwordTooShort;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        GlassTextField(
                          controller: _confirmPasswordController,
                          hintText: s.confirmPassword,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: _register,
                          prefixIcon: const Icon(Icons.lock_outline_rounded,
                              color: SynapserTheme.labelTertiary),
                          validator: (v) {
                            if (v != _passwordController.text) {
                              return s.passwordsMismatch;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        GlassButton(
                          label: s.register,
                          isLoading: auth.status == AuthStatus.loading,
                          onPressed: _register,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(s.hasAccount,
                          style: const TextStyle(
                              color: SynapserTheme.labelTertiary)),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(s.login,
                            style: const TextStyle(
                                color: SynapserTheme.accentBlue,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
