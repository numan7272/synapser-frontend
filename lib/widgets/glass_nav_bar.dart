import 'dart:ui';
import 'package:flutter/material.dart';
import '../config/theme.dart';

class GlassNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const GlassNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    _NavItem(icon: Icons.calendar_today_rounded, activeIcon: Icons.calendar_today, label: 'Home'),
    _NavItem(icon: Icons.add_circle_outline_rounded, activeIcon: Icons.add_circle_rounded, label: 'Planen'),
    _NavItem(icon: Icons.lightbulb_outline_rounded, activeIcon: Icons.lightbulb_rounded, label: 'Tipps'),
    _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 28),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.65),
                  Colors.white.withValues(alpha: 0.45),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.6),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                  spreadRadius: -4,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_items.length, (index) {
                final item = _items[index];
                final isSelected = index == currentIndex;
                return _buildNavItem(item, isSelected, () => onTap(index));
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(_NavItem item, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: isSelected
                  ? BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          SynapserTheme.tintBlue.withValues(alpha: 0.2),
                          SynapserTheme.tintCyan.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    )
                  : null,
              child: Icon(
                isSelected ? item.activeIcon : item.icon,
                size: 22,
                color: isSelected
                    ? SynapserTheme.tintBlue
                    : SynapserTheme.labelTertiary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? SynapserTheme.tintBlue
                    : SynapserTheme.labelTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({required this.icon, required this.activeIcon, required this.label});
}
