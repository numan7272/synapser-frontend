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

    return SynapserTheme.auroraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Progress dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _currentPage ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: i == _currentPage ? SynapserTheme.gradientPrimary : null,
                      color: i == _currentPage ? null : SynapserTheme.textMuted.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),

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
          return GestureDetector(
            onTap: () {
              setState(() {
                if (selected) {
                  _selectedHobbies.remove(hobby);
                } else {
                  _selectedHobbies.add(hobby);
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: selected ? SynapserTheme.gradientPrimary : null,
                color: selected ? null : SynapserTheme.bgSurface,
                borderRadius: BorderRadius.circular(SynapserTheme.radiusSm),
                border: Border.all(
                  color: selected
                      ? Colors.transparent
                      : SynapserTheme.borderSubtle,
                  width: 1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: SynapserTheme.accentBlue.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                hobby,
                style: TextStyle(
                  color: selected ? Colors.white : SynapserTheme.textSecondary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
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
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: SynapserTheme.gradientPrimary,
              borderRadius: BorderRadius.circular(SynapserTheme.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: SynapserTheme.accentBlue.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, size: 28, color: Colors.white),
          ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: SynapserTheme.textPrimary,
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
