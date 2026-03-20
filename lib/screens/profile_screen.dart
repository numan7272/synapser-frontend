import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as lg;
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../l10n/l10n.dart';
import '../providers/auth_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final s = S.of(context);

    if (user == null) return const SizedBox();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Avatar - Liquid Glass circle with shader
            lg.GlassContainer(
              useOwnLayer: true,
              width: 80,
              height: 80,
              shape: const lg.LiquidOval(),
              settings: lg.LiquidGlassSettings(
                thickness: 25,
                blur: 10,
                glassColor: SynapserTheme.tintBlue.withValues(alpha: 0.2),
              ),
              child: Center(
                child: Text(
                  user.email[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: SynapserTheme.tintBlue,
                  ),
                ),
              ),
            ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 12),
            Text(
              user.email,
              style: const TextStyle(
                  color: SynapserTheme.labelSecondary, fontSize: 15),
            ),
            const SizedBox(height: 32),

            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.profile,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: SynapserTheme.labelPrimary)),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.work_outline_rounded, s.occupation,
                      user.occupation ?? '-'),
                  _buildDivider(),
                  _buildInfoRow(Icons.schedule_rounded, s.workHours,
                      user.workHours ?? '-'),
                  _buildDivider(),
                  _buildInfoRow(Icons.location_on_outlined, s.location,
                      user.homeLocation),
                  if (user.hobbies.isNotEmpty) ...[
                    _buildDivider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.favorite_border_rounded,
                            color: SynapserTheme.labelTertiary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: user.hobbies.map<Widget>((h) {
                              return lg.GlassChip(
                                label: h,
                                selectedColor: SynapserTheme.tintBlue,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: GlassButton(
                label: s.logout,
                icon: Icons.logout_rounded,
                isPrimary: false,
                color: SynapserTheme.tintRed,
                onPressed: () => auth.logout(),
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
            const SizedBox(height: 24),

            const Text(
              'Synapser v2.0.0',
              style: TextStyle(
                  color: SynapserTheme.labelTertiary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(height: 1, color: Colors.white.withValues(alpha: 0.3)),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: SynapserTheme.labelTertiary, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    color: SynapserTheme.labelTertiary, fontSize: 13)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                    color: SynapserTheme.labelPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}
