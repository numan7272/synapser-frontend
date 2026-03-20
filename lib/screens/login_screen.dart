import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as lg;
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../l10n/l10n.dart';
import '../providers/auth_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_button.dart';
import '../widgets/glass_input.dart';
import '../widgets/glass_toast.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!success && mounted) {
      GlassToast.show(
        context,
        message: authProvider.error ?? S.of(context).loginError,
        type: ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final s = S.of(context);

    return SynapserTheme.meshGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Liquid Glass logo
                    lg.GlassContainer(
                      useOwnLayer: true,
                      width: 64,
                      height: 64,
                      settings: lg.LiquidGlassSettings(
                        thickness: 30,
                        blur: 10,
                        glassColor: SynapserTheme.tintBlue.withValues(alpha: 0.35),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                    const SizedBox(height: 12),
                    const Text(
                      'Synapser',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: SynapserTheme.labelPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            s.welcomeBack,
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
                            textInputAction: TextInputAction.done,
                            onEditingComplete: _login,
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
                          const SizedBox(height: 24),
                          GlassButton(
                            label: s.login,
                            isLoading: auth.status == AuthStatus.loading,
                            onPressed: _login,
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(s.noAccount,
                            style: const TextStyle(
                                color: SynapserTheme.labelTertiary)),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                    const RegisterScreen(),
                                transitionsBuilder: (_, anim, __, child) {
                                  return FadeTransition(
                                      opacity: anim, child: child);
                                },
                              ),
                            );
                          },
                          child: Text(s.register,
                              style: const TextStyle(
                                  color: SynapserTheme.tintBlue,
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
      ),
    );
  }
}
