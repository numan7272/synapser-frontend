import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as lg;
import '../config/theme.dart';

class GlassNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const GlassNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 28),
      child: lg.GlassBottomBar(
        tabs: const [
          lg.GlassBottomBarTab(
            label: 'Home',
            icon: Icons.calendar_today_rounded,
            selectedIcon: Icons.calendar_today,
          ),
          lg.GlassBottomBarTab(
            label: 'Planen',
            icon: Icons.add_circle_outline_rounded,
            selectedIcon: Icons.add_circle_rounded,
          ),
          lg.GlassBottomBarTab(
            label: 'Tipps',
            icon: Icons.lightbulb_outline_rounded,
            selectedIcon: Icons.lightbulb_rounded,
          ),
          lg.GlassBottomBarTab(
            label: 'Profil',
            icon: Icons.person_outline_rounded,
            selectedIcon: Icons.person_rounded,
          ),
        ],
        selectedIndex: currentIndex,
        onTabSelected: onTap,
        glassSettings: lg.LiquidGlassSettings(
          thickness: 35,
          blur: 15,
          glassColor: Colors.white.withOpacity(0.15),
        ),
      ),
    );
  }
}
