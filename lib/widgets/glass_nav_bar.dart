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
    return Container(
      decoration: BoxDecoration(
        color: SynapserTheme.backgroundSecondary,
        border: Border(
          top: BorderSide(color: SynapserTheme.separator.withValues(alpha: 0.3)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
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
    );
  }

  Widget _buildNavItem(_NavItem item, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              size: 24,
              color: isSelected
                  ? SynapserTheme.accentBlue
                  : SynapserTheme.labelTertiary,
            ),
            const SizedBox(height: 2),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? SynapserTheme.accentBlue
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
