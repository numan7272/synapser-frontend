import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../models/models.dart';

class TimelineSlotWidget extends StatelessWidget {
  final ScheduledSlot slot;
  final bool isLast;

  const TimelineSlotWidget({
    super.key,
    required this.slot,
    this.isLast = false,
  });

  Color get _accentColor {
    final name = slot.name.toLowerCase();
    if (name.contains('fahrt') || name.contains('driving')) {
      return SynapserTheme.accentOrange;
    }
    return SynapserTheme.accentBlue;
  }

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final startLocal = slot.startTime.toLocal();
    final endLocal = slot.endTime.toLocal();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 52,
              child: Text(
                timeFormat.format(startLocal),
                style: const TextStyle(
                  color: SynapserTheme.textMuted,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _accentColor,
                    boxShadow: [
                      BoxShadow(
                        color: _accentColor.withValues(alpha: 0.35),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      color: SynapserTheme.textMuted.withValues(alpha: 0.2),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: SynapserTheme.bgCard,
                    borderRadius: BorderRadius.circular(SynapserTheme.radiusMd),
                    border: Border.all(
                      color: SynapserTheme.borderSubtle,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _accentColor.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 3,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _accentColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              slot.name,
                              style: const TextStyle(
                                color: SynapserTheme.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${timeFormat.format(startLocal)} - ${timeFormat.format(endLocal)}  ·  ${slot.durationMinutes} Min.',
                              style: const TextStyle(
                                color: SynapserTheme.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
