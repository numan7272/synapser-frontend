import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/models.dart';
import 'glass_card.dart';
import 'glass_button.dart';

class ConflictResolutionView extends StatelessWidget {
  final SchedulingConflictResponse conflict;
  final ValueChanged<ResolutionSuggestion> onSuggestionChosen;
  final VoidCallback onCancel;
  final bool isLoading;

  const ConflictResolutionView({
    super.key,
    required this.conflict,
    required this.onSuggestionChosen,
    required this.onCancel,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: SynapserTheme.accentOrange, size: 24),
            const SizedBox(width: 8),
            const Text(
              'Planungskonflikt',
              style: TextStyle(
                color: SynapserTheme.accentOrange,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          conflict.message,
          style: const TextStyle(color: SynapserTheme.textSecondary, fontSize: 15),
        ),
        const SizedBox(height: 16),

        if (conflict.conflictingEvents.isNotEmpty) ...[
          const Text(
            'Betroffene Termine:',
            style: TextStyle(color: SynapserTheme.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: conflict.conflictingEvents.map<Widget>((event) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: SynapserTheme.bgSurface,
                  borderRadius: BorderRadius.circular(SynapserTheme.radiusSm),
                  border: Border.all(color: SynapserTheme.borderSubtle, width: 1),
                ),
                child: Text(
                  event.name,
                  style: const TextStyle(
                    color: SynapserTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],

        const Text(
          'Lösungsvorschläge:',
          style: TextStyle(color: SynapserTheme.textMuted, fontSize: 13),
        ),
        const SizedBox(height: 8),
        ...conflict.suggestions.map((suggestion) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              accentColor: SynapserTheme.accentBlue,
              onTap: isLoading ? null : () => onSuggestionChosen(suggestion),
              child: Row(
                children: [
                  const Icon(Icons.auto_fix_high_rounded,
                      color: SynapserTheme.accentBlue, size: 18),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      suggestion.suggestionText,
                      style: const TextStyle(
                        color: SynapserTheme.textPrimary,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: SynapserTheme.textMuted, size: 20),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
        Center(
          child: GlassButton(
            label: 'Abbrechen',
            isPrimary: false,
            onPressed: onCancel,
          ),
        ),
      ],
    );
  }
}
