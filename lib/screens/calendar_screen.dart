import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../l10n/l10n.dart';
import '../providers/schedule_provider.dart';
import '../widgets/timeline_slot.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDate;
  late List<DateTime> _weekDays;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _generateWeekDays();
  }

  void _generateWeekDays() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    _weekDays = List.generate(14, (i) => monday.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = context.watch<ScheduleProvider>();
    final daySlots = scheduleProvider.getScheduleForDate(_selectedDate);
    final s = S.of(context);
    final locale = S.locale(context);

    return Container(
      decoration: BoxDecoration(gradient: SynapserTheme.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(s.weekView,
              style: const TextStyle(color: Colors.white, fontSize: 18)),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Date Picker
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _weekDays.length,
                  itemBuilder: (context, index) {
                    final day = _weekDays[index];
                    final isSelected = DateUtils.isSameDay(day, _selectedDate);
                    final isToday = DateUtils.isSameDay(day, DateTime.now());

                    return GestureDetector(
                      onTap: () => setState(() => _selectedDate = day),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? SynapserTheme.accentTeal.withValues(alpha: 0.25)
                              : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? SynapserTheme.accentTeal.withValues(alpha: 0.5)
                                : isToday
                                    ? SynapserTheme.accentPurple
                                        .withValues(alpha: 0.3)
                                    : Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('E', locale).format(day),
                              style: TextStyle(
                                fontSize: 11,
                                color: isSelected
                                    ? SynapserTheme.accentTeal
                                    : Colors.white54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${day.day}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? SynapserTheme.accentTeal
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),

              // Day Label
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat('EEEE, d. MMMM', locale).format(_selectedDate),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Timeline
              Expanded(
                child: daySlots.isEmpty
                    ? Center(
                        child: Text(
                          s.noEventsOnDay,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 24),
                        itemCount: daySlots.length,
                        itemBuilder: (context, index) {
                          return TimelineSlotWidget(
                            slot: daySlots[index],
                            isLast: index == daySlots.length - 1,
                          ).animate().fadeIn(
                                delay: Duration(milliseconds: 50 * index),
                                duration: 300.ms,
                              );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
