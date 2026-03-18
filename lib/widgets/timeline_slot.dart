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
                style: TextStyle(
                  color: SynapserTheme.labelTertiary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _accentColor,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      color: SynapserTheme.separator.withValues(alpha: 0.4),
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
                    color: SynapserTheme.backgroundSecondary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border(
                      left: BorderSide(color: _accentColor, width: 3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        slot.name,
                        style: const TextStyle(
                          color: SynapserTheme.labelPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${timeFormat.format(startLocal)} - ${timeFormat.format(endLocal)}  ·  ${slot.durationMinutes} Min.',
                        style: TextStyle(
                          color: SynapserTheme.labelTertiary,
                          fontSize: 13,
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
