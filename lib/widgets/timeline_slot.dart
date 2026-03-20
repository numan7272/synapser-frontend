import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as lg;
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
      return SynapserTheme.tintOrange;
    }
    return SynapserTheme.tintBlue;
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
                  color: SynapserTheme.labelTertiary,
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
                      color: SynapserTheme.labelTertiary.withValues(alpha: 0.2),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: lg.GlassContainer(
                  useOwnLayer: true,
                  settings: lg.LiquidGlassSettings(
                    thickness: 25,
                    blur: 10,
                    glassColor: Colors.white.withValues(alpha: 0.15),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: _accentColor, width: 3),
                      ),
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
                          style: const TextStyle(
                            color: SynapserTheme.labelSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
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
