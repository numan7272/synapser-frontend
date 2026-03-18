import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as lg;
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../l10n/l10n.dart';
import '../providers/schedule_provider.dart';
import '../widgets/glass_button.dart';
import '../widgets/glass_input.dart';
import '../widgets/glass_toast.dart';
import '../widgets/conflict_resolution_view.dart';

class AiTaskInputSheet extends StatefulWidget {
  const AiTaskInputSheet({super.key});

  @override
  State<AiTaskInputSheet> createState() => _AiTaskInputSheetState();
}

class _AiTaskInputSheetState extends State<AiTaskInputSheet> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final provider = context.read<ScheduleProvider>();
    final success = await provider.addTaskWithAi(text);

    if (mounted) {
      if (success) {
        GlassToast.show(context,
            message: S.of(context).taskAdded, type: ToastType.success);
        Navigator.pop(context);
      } else if (provider.activeConflict == null && provider.error != null) {
        GlassToast.show(context,
            message: provider.error!, type: ToastType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = context.watch<ScheduleProvider>();
    final s = S.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: lg.GlassPanel(
            useOwnLayer: true,
            settings: lg.LiquidGlassSettings(
              thickness: 35,
              blur: 15,
              glassColor: Colors.white.withOpacity(0.25),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 5,
                      decoration: BoxDecoration(
                        color: SynapserTheme.labelTertiary.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (scheduleProvider.activeConflict != null)
                    ConflictResolutionView(
                      conflict: scheduleProvider.activeConflict!,
                      isLoading: scheduleProvider.isLoading,
                      onSuggestionChosen: (suggestion) async {
                        final success =
                            await scheduleProvider.resolveConflict(suggestion);
                        if (success && mounted) {
                          GlassToast.show(context,
                              message: s.conflictResolved,
                              type: ToastType.success);
                          Navigator.pop(context);
                        }
                      },
                      onCancel: () {
                        scheduleProvider.clearConflict();
                      },
                    ).animate().fadeIn(duration: 300.ms)
                  else ...[
                    Row(
                      children: [
                        lg.GlassContainer(
                          useOwnLayer: true,
                          width: 34,
                          height: 34,
                          settings: lg.LiquidGlassSettings(
                            thickness: 20,
                            blur: 8,
                            glassColor: SynapserTheme.tintBlue.withOpacity(0.15),
                          ),
                          child: const Icon(Icons.auto_awesome_rounded,
                              color: SynapserTheme.tintBlue, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          s.whatToSchedule,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: SynapserTheme.labelPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    GlassTextField(
                      controller: _textController,
                      hintText: s.describeTask,
                      maxLines: 3,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: _submit,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      s.taskExamples,
                      style: const TextStyle(
                        color: SynapserTheme.labelTertiary,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: GlassButton(
                        label: s.schedule,
                        icon: Icons.send_rounded,
                        isLoading: scheduleProvider.isLoading,
                        onPressed: _submit,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
