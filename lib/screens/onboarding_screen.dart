import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../l10n/l10n.dart';
import '../models/models.dart';
import '../providers/auth_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_button.dart';
import '../widgets/glass_input.dart';
import '../widgets/glass_toast.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _occupationController = TextEditingController();
  final _workHoursController = TextEditingController();
  final _locationController = TextEditingController();
  final Set<String> _selectedHobbies = {};

  static const _hobbyOptions = [
    'Sport', 'Lesen', 'Kochen', 'Musik', 'Gaming',
    'Reisen', 'Fotografie', 'Gärtnern', 'Yoga', 'Programmieren',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _occupationController.dispose();
    _workHoursController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      _submit();
    }
  }

  Future<void> _submit() async {
    final s = S.of(context);
    final request = OnboardingRequest(
      occupation: _occupationController.text.isNotEmpty
          ? _occupationController.text
          : null,
      hobbies: _selectedHobbies.toList(),
      workHours: _workHoursController.text.isNotEmpty
          ? _workHoursController.text
          : null,
      homeLocation: _locationController.text.isNotEmpty
          ? _locationController.text
          : 'Nicht festgelegt',
    );

    final success = await context.read<AuthProvider>().submitOnboarding(request);
    if (!success && mounted) {
      GlassToast.show(context,
          message: s.onboardingError, type: ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Container(
      decoration: BoxDecoration(gradient: SynapserTheme.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Progress Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _currentPage ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _currentPage
                          ? SynapserTheme.accentTeal
                          : Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),

              // Pages
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  children: [
                    _buildOccupationPage(s),
                    _buildHobbiesPage(s),
                    _buildWorkHoursPage(s),
                    _buildLocationPage(s),
                  ],
                ),
              ),

              // Buttons
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    if (_currentPage < 3)
                      Expanded(
                        child: GlassButton(
                          label: s.skip,
                          isPrimary: false,
                          onPressed: _nextPage,
                        ),
                      ),
                    if (_currentPage < 3) const SizedBox(width: 12),
                    Expanded(
                      child: GlassButton(
                        label: _currentPage == 3 ? s.done : s.next,
                        onPressed: _nextPage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOccupationPage(S s) {
    return _pageContent(
      icon: Icons.work_outline_rounded,
      title: s.whatDoYouDo,
      child: GlassTextField(
        controller: _occupationController,
        hintText: s.occupationHint,
      ),
    );
  }

  Widget _buildHobbiesPage(S s) {
    return _pageContent(
      icon: Icons.favorite_border_rounded,
      title: s.whatAreYourHobbies,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _hobbyOptions.map((hobby) {
          final selected = _selectedHobbies.contains(hobby);
          return FilterChip(
            label: Text(hobby),
            selected: selected,
            onSelected: (v) {
              setState(() {
                if (v) {
                  _selectedHobbies.add(hobby);
                } else {
                  _selectedHobbies.remove(hobby);
                }
              });
            },
            selectedColor: SynapserTheme.accentTeal.withValues(alpha: 0.3),
            backgroundColor: Colors.white.withValues(alpha: 0.08),
            labelStyle: TextStyle(
              color: selected ? SynapserTheme.accentTeal : Colors.white70,
            ),
            side: BorderSide(
              color: selected
                  ? SynapserTheme.accentTeal.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.15),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWorkHoursPage(S s) {
    return _pageContent(
      icon: Icons.schedule_rounded,
      title: s.whenDoYouWork,
      child: GlassTextField(
        controller: _workHoursController,
        hintText: s.workHoursHint,
      ),
    );
  }

  Widget _buildLocationPage(S s) {
    return _pageContent(
      icon: Icons.location_on_outlined,
      title: s.whereDoYouLive,
      child: GlassTextField(
        controller: _locationController,
        hintText: s.locationHint,
      ),
    );
  }

  Widget _pageContent({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: SynapserTheme.accentTeal)
              .animate()
              .scale(duration: 400.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          GlassCard(child: child)
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1),
        ],
      ),
    );
  }
}
