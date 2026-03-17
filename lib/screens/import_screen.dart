import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../l10n/l10n.dart';
import '../providers/schedule_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_button.dart';
import '../widgets/glass_toast.dart';
import '../widgets/glass_loading_overlay.dart';
import '../widgets/conflict_resolution_view.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  File? _selectedFile;
  final _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) {
      setState(() => _selectedFile = File(picked.path));
    }
  }

  Future<void> _import() async {
    if (_selectedFile == null) return;

    final provider = context.read<ScheduleProvider>();
    final success = await provider.importFile(_selectedFile!);

    if (mounted) {
      if (success) {
        GlassToast.show(context,
            message: S.of(context).importSuccess, type: ToastType.success);
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

    return Container(
      decoration: BoxDecoration(gradient: SynapserTheme.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(s.importSchedule,
              style: const TextStyle(color: Colors.white, fontSize: 18)),
        ),
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: scheduleProvider.activeConflict != null
                    ? GlassCard(
                        child: ConflictResolutionView(
                          conflict: scheduleProvider.activeConflict!,
                          isLoading: scheduleProvider.isLoading,
                          onSuggestionChosen: (suggestion) async {
                            final success = await scheduleProvider
                                .resolveConflict(suggestion);
                            if (success && mounted) {
                              GlassToast.show(context,
                                  message: s.conflictResolved,
                                  type: ToastType.success);
                              Navigator.pop(context);
                            }
                          },
                          onCancel: () => scheduleProvider.clearConflict(),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Info
                          GlassCard(
                            child: Column(
                              children: [
                                const Icon(Icons.document_scanner_rounded,
                                    color: SynapserTheme.accentTeal, size: 36),
                                const SizedBox(height: 12),
                                Text(s.importDescription,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 14)),
                              ],
                            ),
                          ).animate().fadeIn(duration: 400.ms),
                          const SizedBox(height: 20),

                          // Picker Buttons
                          Row(
                            children: [
                              Expanded(
                                child: GlassButton(
                                  label: s.takePhoto,
                                  icon: Icons.camera_alt_outlined,
                                  isPrimary: false,
                                  onPressed: () =>
                                      _pickImage(ImageSource.camera),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GlassButton(
                                  label: s.fromGallery,
                                  icon: Icons.photo_library_outlined,
                                  isPrimary: false,
                                  onPressed: () =>
                                      _pickImage(ImageSource.gallery),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Preview
                          if (_selectedFile != null) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                _selectedFile!,
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 300.ms)
                                .scale(begin: const Offset(0.95, 0.95)),
                            const SizedBox(height: 20),
                            GlassButton(
                              label: s.importNow,
                              icon: Icons.upload_rounded,
                              isLoading: scheduleProvider.isLoading,
                              onPressed: _import,
                            ),
                          ],
                        ],
                      ),
              ),
            ),

            // Loading Overlay
            if (scheduleProvider.isLoading)
              GlassLoadingOverlay(message: s.aiAnalyzing),
          ],
        ),
      ),
    );
  }
}
