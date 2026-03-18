import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../widgets/glass_nav_bar.dart';
import 'home_screen.dart';
import 'suggestions_screen.dart';
import 'profile_screen.dart';
import 'ai_task_input_sheet.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    SizedBox(),
    SuggestionsScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    if (index == 1) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const AiTaskInputSheet(),
      );
      return;
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return SynapserTheme.meshGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: IndexedStack(
          index: _currentIndex == 1 ? 0 : _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: GlassNavBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
        ),
      ),
    );
  }
}
