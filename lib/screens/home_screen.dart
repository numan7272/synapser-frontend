import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../l10n/l10n.dart';
import '../providers/schedule_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_button.dart';
import '../widgets/timeline_slot.dart';
import 'ai_task_input_sheet.dart';
import 'calendar_screen.dart';
import 'import_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = context.watch<ScheduleProvider>();
    final todaySlots = scheduleProvider.getScheduleForDate(_selectedDate);
    final s = S.of(context);
    final isToday = DateUtils.isSameDay(_selectedDate, DateTime.now());

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isToday ? s.today : DateFormat('EEEE', S.locale(context)).format(_selectedDate),
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: SynapserTheme.labelPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('d. MMMM yyyy', S.locale(context)).format(_selectedDate),
                      style: const TextStyle(
                        fontSize: 15,
                        color: SynapserTheme.labelTertiary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.calendar_month_rounded,
                          color: SynapserTheme.tintBlue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CalendarScreen(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.upload_file_rounded,
                          color: SynapserTheme.tintBlue),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ImportScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // AI Explanation Banner
          if (scheduleProvider.explanation != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GlassCard(
                accentColor: SynapserTheme.tintPurple,
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.auto_awesome_rounded,
                        color: SynapserTheme.tintPurple, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        scheduleProvider.explanation!,
                        style: const TextStyle(
                          color: SynapserTheme.labelSecondary,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: scheduleProvider.clearExplanation,
                      child: const Icon(Icons.close_rounded,
                          color: SynapserTheme.labelTertiary, size: 18),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1),
            ),

          const SizedBox(height: 12),

          // Timeline
          Expanded(
            child: todaySlots.isEmpty
                ? _buildEmptyState(s)
                : RefreshIndicator(
                    color: SynapserTheme.tintBlue,
                    onRefresh: () async {},
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 100),
                      itemCount: todaySlots.length,
                      itemBuilder: (context, index) {
                        return TimelineSlotWidget(
                          slot: todaySlots[index],
                          isLast: index == todaySlots.length - 1,
                        ).animate().fadeIn(
                              delay: Duration(milliseconds: 50 * index),
                              duration: 300.ms,
                            ).slideX(begin: 0.05);
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
          Icon(
            Icons.event_available_rounded,
            size: 56,
            color: SynapserTheme.labelTertiary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            s.noEventsToday,
            style: const TextStyle(
              fontSize: 18,
              color: SynapserTheme.labelSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            s.addFirstTask,
            style: const TextStyle(
              fontSize: 15,
              color: SynapserTheme.labelTertiary,
            ),
          ),
          const SizedBox(height: 24),
          GlassButton(
            label: s.addTask,
            icon: Icons.add_rounded,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const AiTaskInputSheet(),
              );
            },
          ),
        ],
      ).animate().fadeIn(duration: 600.ms),
    );
  }
}
