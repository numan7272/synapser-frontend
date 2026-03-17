import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../l10n/l10n.dart';
import '../providers/schedule_provider.dart';
import '../providers/suggestion_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_button.dart';
import '../widgets/glass_toast.dart';

class SuggestionsScreen extends StatefulWidget {
  const SuggestionsScreen({super.key});

  @override
  State<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<SuggestionProvider>().fetchSuggestions());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SuggestionProvider>();
    final s = S.of(context);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline_rounded,
                    color: SynapserTheme.accentPurple, size: 24),
                const SizedBox(width: 8),
                Text(
                  s.suggestions,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: provider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: SynapserTheme.accentTeal,
                    ),
                  )
                : provider.suggestions.isEmpty
                    ? _buildEmptyState(s)
                    : RefreshIndicator(
                        color: SynapserTheme.accentTeal,
                        backgroundColor: SynapserTheme.backgroundDark,
                        onRefresh: provider.fetchSuggestions,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                          itemCount: provider.suggestions.length,
                          itemBuilder: (context, index) {
                            final suggestion = provider.suggestions[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GlassCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      suggestion.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: SynapserTheme.accentTeal,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      suggestion.description,
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.6),
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GlassButton(
                                            label: s.scheduleSuggestion,
                                            icon: Icons.check_rounded,
                                            onPressed: () async {
                                              final scheduleProvider =
                                                  context.read<ScheduleProvider>();
                                              final success =
                                                  await scheduleProvider.addTaskWithAi(
                                                suggestion
                                                    .eventToSchedule.name,
                                              );
                                              if (mounted) {
                                                if (success) {
                                                  provider.dismissSuggestion(
                                                      suggestion.suggestionId);
                                                  GlassToast.show(context,
                                                      message: s.taskAdded,
                                                      type: ToastType.success);
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        GlassButton(
                                          label: s.dismiss,
                                          isPrimary: false,
                                          onPressed: () {
                                            provider.dismissSuggestion(
                                                suggestion.suggestionId);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ).animate().fadeIn(
                                    delay: Duration(milliseconds: 50 * index),
                                    duration: 300.ms,
                                  ).slideY(begin: 0.05),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(S s) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lightbulb_outline_rounded,
              size: 56, color: Colors.white.withValues(alpha: 0.15)),
          const SizedBox(height: 16),
          Text(s.noSuggestions,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4), fontSize: 16)),
          const SizedBox(height: 8),
          Text(s.noSuggestionsHint,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3), fontSize: 13)),
        ],
      ),
    );
  }
}
