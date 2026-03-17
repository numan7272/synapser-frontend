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
        // Header
        Row(
          children: [
            Icon(Icons.warning_amber_rounded,
                color: SynapserTheme.accentAmber, size: 24),
            const SizedBox(width: 8),
            Text(
              'Planungskonflikt',
              style: TextStyle(
                color: SynapserTheme.accentAmber,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          conflict.message,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14),
        ),
        const SizedBox(height: 16),

        // Konflikte
        if (conflict.conflictingEvents.isNotEmpty) ...[
          Text(
            'Betroffene Termine:',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: conflict.conflictingEvents.map((event) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: SynapserTheme.accentAmber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: SynapserTheme.accentAmber.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  event.name,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],

        // Vorschläge
        Text(
          'Lösungsvorschläge:',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
        ),
        const SizedBox(height: 8),
        ...conflict.suggestions.map((suggestion) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              accentColor: SynapserTheme.accentTeal,
              onTap: isLoading ? null : () => onSuggestionChosen(suggestion),
              child: Row(
                children: [
                  const Icon(Icons.auto_fix_high_rounded,
                      color: SynapserTheme.accentTeal, size: 18),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      suggestion.suggestionText,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: Colors.white38, size: 20),
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
