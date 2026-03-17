import 'dart:ui';
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
    return SynapserTheme.accentTeal;
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
            // Zeit-Spalte
            SizedBox(
              width: 52,
              child: Text(
                timeFormat.format(startLocal),
                style: TextStyle(
                  color: _accentColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Vertikale Linie
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
                        color: _accentColor.withValues(alpha: 0.4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Event-Card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border(
                          left: BorderSide(color: _accentColor, width: 3),
                          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                          right: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            slot.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${timeFormat.format(startLocal)} - ${timeFormat.format(endLocal)}  ·  ${slot.durationMinutes} Min.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
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
