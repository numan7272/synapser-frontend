import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

            // Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    SynapserTheme.accentTeal.withValues(alpha: 0.3),
                    SynapserTheme.accentPurple.withValues(alpha: 0.3),
                  ],
                ),
                border: Border.all(
                  color: SynapserTheme.accentTeal.withValues(alpha: 0.4),
                ),
              ),
              child: Center(
                child: Text(
                  user.email[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 12),
            Text(
              user.email,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
            ),
            const SizedBox(height: 32),

            // Profile Info
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.profile,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.work_outline_rounded, s.occupation,
                      user.occupation ?? '-'),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.schedule_rounded, s.workHours,
                      user.workHours ?? '-'),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.location_on_outlined, s.location,
                      user.homeLocation),
                  if (user.hobbies.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.favorite_border_rounded,
                            color: Colors.white.withValues(alpha: 0.5),
                            size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: user.hobbies.map((h) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: SynapserTheme.accentTeal
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: SynapserTheme.accentTeal
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(h,
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 12)),
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

            // Logout
            SizedBox(
              width: double.infinity,
              child: GlassButton(
                label: s.logout,
                icon: Icons.logout_rounded,
                isPrimary: false,
                color: SynapserTheme.errorRed,
                onPressed: () => auth.logout(),
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
            const SizedBox(height: 24),

            // Version
            Text(
              'Synapser v2.0.0',
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.25), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.5), size: 18),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4), fontSize: 11)),
            Text(value,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ],
    );
  }
}
