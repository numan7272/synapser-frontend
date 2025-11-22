import 'dart:ui';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show Colors, CircularProgressIndicator, Icons, ThemeMode;
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'api_service.dart';
import 'theme.dart';

void main() {
  runApp(const SynapserApp());
}

class SynapserApp extends StatelessWidget {
  const SynapserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Synapser',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: LiquidColors.accent,
        scaffoldBackgroundColor: Colors.black,
        barBackgroundColor: Color(0x00000000),
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(fontFamily: '.SF Pro Text', color: Colors.white),
          navLargeTitleTextStyle: TextStyle(
            fontFamily: '.SF Pro Display',
            fontWeight: FontWeight.w800,
            fontSize: 34.0,
            color: Colors.white,
          ),
        ),
      ),
      home: LoginScreen(),
    );
  }
}

// Hilfsfunktion
bool get isApple => Platform.isMacOS || Platform.isIOS;

// ============================================================================
// 🔐 LOGIN SCREEN
// ============================================================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController(text: "testuser@example.com");
  final _passCtrl = TextEditingController(text: "SecurePassword123!");
  final _api = ApiService();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    final success = await _api.login(_emailCtrl.text, _passCtrl.text);
    setState(() => _isLoading = false);

    if (success && mounted) {
      // Normaler Login -> Dashboard
      Navigator.pushReplacement(context,
          CupertinoPageRoute(builder: (context) => const DashboardScreen()));
    } else {
      _showError("Login fehlgeschlagen. Bitte registrieren oder Daten prüfen.");
    }
  }

  Future<void> _register() async {
    setState(() => _isLoading = true);
    final success = await _api.register(_emailCtrl.text, _passCtrl.text);

    if (success) {
      // Nach Registrierung automatisch einloggen...
      final loginSuccess = await _api.login(_emailCtrl.text, _passCtrl.text);
      setState(() => _isLoading = false);

      if (loginSuccess && mounted) {
        // ...und zum ONBOARDING leiten (nicht Dashboard)
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (context) => const OnboardingScreen()));
      }
    } else {
      setState(() => _isLoading = false);
      _showError(
          "Registrierung fehlgeschlagen. User existiert vielleicht schon?");
    }
  }

  void _showError(String msg) {
    showCupertinoDialog(
      context: context,
      builder: (c) => CupertinoAlertDialog(
        title: const Text("Info"),
        content: Text(msg),
        actions: [
          CupertinoDialogAction(
              child: const Text("OK"), onPressed: () => Navigator.pop(c))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          const LiquidBackground(),
          Center(
            child: SingleChildScrollView(
              child: NativeGlassContainer(
                // Nutzt unser ausgelagertes Theme Widget
                padding: const EdgeInsets.all(32),
                child: SizedBox(
                  width: 320,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(CupertinoIcons.waveform_circle_fill,
                          size: 80, color: LiquidColors.accent),
                      const SizedBox(height: 20),
                      const Text("Synapser",
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text("Dein intelligenter Tag.",
                          style: TextStyle(
                              color: CupertinoColors.systemGrey
                                  .resolveFrom(context))),
                      const SizedBox(height: 40),

                      // Inputs
                      CupertinoTextField(
                        controller: _emailCtrl,
                        placeholder: "E-Mail",
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color:
                                CupertinoColors.systemGrey6.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white10)),
                        style: const TextStyle(color: Colors.white),
                        prefix: const Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Icon(CupertinoIcons.mail,
                                size: 20, color: Colors.grey)),
                      ),
                      const SizedBox(height: 16),

                      CupertinoTextField(
                        controller: _passCtrl,
                        placeholder: "Passwort",
                        obscureText: true,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color:
                                CupertinoColors.systemGrey6.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white10)),
                        style: const TextStyle(color: Colors.white),
                        prefix: const Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Icon(CupertinoIcons.lock,
                                size: 20, color: Colors.grey)),
                      ),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        child: CupertinoButton.filled(
                          onPressed: _isLoading ? null : _login,
                          borderRadius: BorderRadius.circular(12),
                          child: _isLoading
                              ? const CupertinoActivityIndicator(
                                  color: Colors.white)
                              : const Text("Anmelden",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CupertinoButton(
                        onPressed: _isLoading ? null : _register,
                        child: const Text("Account erstellen",
                            style:
                                TextStyle(color: CupertinoColors.systemGrey)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 🚀 ONBOARDING SCREEN (NEU)
// ============================================================================
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _jobCtrl = TextEditingController();
  final _locCtrl = TextEditingController();
  final _hoursCtrl = TextEditingController(text: "09:00 - 17:00");
  final _hobbiesCtrl = TextEditingController();
  final _api = ApiService();
  bool _isLoading = false;

  Future<void> _finishOnboarding() async {
    if (_jobCtrl.text.isEmpty || _locCtrl.text.isEmpty) {
      // Simple Validierung
      return;
    }

    setState(() => _isLoading = true);
    final hobbiesList = _hobbiesCtrl.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final success = await _api.submitOnboarding(
        occupation: _jobCtrl.text,
        homeLocation: _locCtrl.text,
        workHours: _hoursCtrl.text,
        hobbies: hobbiesList);

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pushReplacement(context,
          CupertinoPageRoute(builder: (context) => const DashboardScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          const LiquidBackground(), // Theme Background
          Center(
            child: SingleChildScrollView(
              child: NativeGlassContainer(
                padding: const EdgeInsets.all(32),
                child: SizedBox(
                  width: 350,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Willkommen!",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                          "Damit ich deinen Tag perfekt planen kann, brauche ich ein paar Infos.",
                          style: TextStyle(
                              color: CupertinoColors.systemGrey
                                  .resolveFrom(context),
                              fontSize: 15)),
                      const SizedBox(height: 30),
                      _buildLabel("Was machst du beruflich?"),
                      _buildInput(_jobCtrl, "z.B. Student, Entwickler"),
                      const SizedBox(height: 20),
                      _buildLabel("Wo startest du meistens? (Für Fahrzeiten)"),
                      _buildInput(_locCtrl, "z.B. Alexanderplatz, Berlin"),
                      const SizedBox(height: 20),
                      _buildLabel("Deine Kernarbeitszeit"),
                      _buildInput(_hoursCtrl, "09:00 - 17:00"),
                      const SizedBox(height: 20),
                      _buildLabel("Hobbys (Kommagetrennt)"),
                      _buildInput(_hobbiesCtrl, "Laufen, Lesen, Gaming"),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoButton.filled(
                          onPressed: _isLoading ? null : _finishOnboarding,
                          borderRadius: BorderRadius.circular(12),
                          child: _isLoading
                              ? const CupertinoActivityIndicator(
                                  color: Colors.white)
                              : const Text("Loslegen",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
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
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.systemGrey)),
    );
  }

  Widget _buildInput(TextEditingController ctrl, String placeholder) {
    return CupertinoTextField(
      controller: ctrl,
      placeholder: placeholder,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      style: const TextStyle(color: Colors.white),
      placeholderStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
    );
  }
}

// ============================================================================
// 🔮 DASHBOARD (MAIN UI)
// ============================================================================
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _textController = TextEditingController();
  final _api = ApiService();
  bool _isProcessing = false;

  // Daten
  List<dynamic> _schedule = [];
  String? _explanation;

  Future<void> _sendRequest() async {
    if (_textController.text.isEmpty) return;
    FocusScope.of(context).unfocus();

    setState(() => _isProcessing = true);
    final result = await _api.planTask(_textController.text);
    setState(() => _isProcessing = false);

    if (result['success'] == true) {
      setState(() {
        _schedule = result['data']['schedule'];
        _explanation = result['data']['explanation'];
        _textController.clear();
      });
    } else if (result['conflict'] != null) {
      _showConflictSheet(result['conflict']['detail']);
    } else {
      _showErrorDialog(
          result['error'] ?? "Ein unbekannter Fehler ist aufgetreten.");
    }
  }

  void _showConflictSheet(Map<String, dynamic> detail) {
    final suggestions = detail['suggestions'] as List<dynamic>? ?? [];

    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: const Color(0xFF1C1C1E),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 24),
                const Icon(CupertinoIcons.exclamationmark_triangle_fill,
                    size: 48, color: CupertinoColors.systemOrange),
                const SizedBox(height: 16),
                const Text("Zeitkonflikt",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 8),
                Text(detail['message'] ?? "Der Termin überschneidet sich.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 32),
                if (suggestions.isNotEmpty)
                  ...suggestions.map((s) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SizedBox(
                          width: double.infinity,
                          child: CupertinoButton(
                            color: CupertinoColors.systemGrey6.withOpacity(0.2),
                            onPressed: () async {
                              Navigator.pop(context);
                              _showErrorDialog(
                                  "Konfliktlösung ausgewählt: ${s['suggestion_text']}");
                            },
                            child: Text(s['suggestion_text'] ?? "Option",
                                style: const TextStyle(
                                    color: CupertinoColors.systemCyan,
                                    fontSize: 15)),
                          ),
                        ),
                      ))
                else
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoButton.filled(
                        child: const Text("Okay"),
                        onPressed: () => Navigator.pop(context)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String msg) {
    showCupertinoDialog(
        context: context,
        builder: (c) => CupertinoAlertDialog(
              title: const Text("Fehler"),
              content: Text(msg),
              actions: [
                CupertinoDialogAction(
                    child: const Text("OK"), onPressed: () => Navigator.pop(c))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: Stack(
        children: [
          const LiquidBackground(),
          CustomScrollView(
            slivers: [
              const CupertinoSliverNavigationBar(
                largeTitle: Text('Heute',
                    style: TextStyle(color: CupertinoColors.white)),
                backgroundColor: Color(0x00000000),
                border: null,
                stretch: true,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- INPUT BEREICH ---
                      NativeGlassContainer(
                        // Liquid Glass Container aus theme.dart
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: CupertinoTextField(
                                controller: _textController,
                                placeholder:
                                    "Neuer Termin (z.B. 'Morgen 10 Uhr Meeting')...",
                                placeholderStyle: const TextStyle(
                                    color: CupertinoColors.systemGrey),
                                style: const TextStyle(
                                    color: CupertinoColors.white),
                                decoration: null,
                                maxLines: 3,
                                minLines: 1,
                                onSubmitted: (_) => _sendRequest(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: _isProcessing ? null : _sendRequest,
                              child: _isProcessing
                                  ? const CupertinoActivityIndicator()
                                  : Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                          color: CupertinoColors.systemCyan,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                                color:
                                                    CupertinoColors.systemCyan,
                                                blurRadius: 10,
                                                spreadRadius: 1)
                                          ]),
                                      child: const Icon(CupertinoIcons.arrow_up,
                                          color: Colors.white, size: 22),
                                    ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // --- KI ERKLÄRUNG ---
                      if (_explanation != null) ...[
                        NativeGlassContainer(
                          color: const Color(0xFF5E5CE6).withOpacity(0.15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(CupertinoIcons.sparkles,
                                  color: Colors.yellow, size: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: Text(_explanation!,
                                      style: const TextStyle(
                                          height: 1.4, fontSize: 15))),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],

                      // --- ZEITPLAN ---
                      Text("ZEITPLAN",
                          style: TextStyle(
                              color: CupertinoColors.systemGrey2
                                  .resolveFrom(context),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2)),
                      const SizedBox(height: 12),

                      if (_schedule.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              children: [
                                Icon(CupertinoIcons.calendar_today,
                                    size: 40,
                                    color: CupertinoColors.systemGrey
                                        .withOpacity(0.3)),
                                const SizedBox(height: 10),
                                Text("Dein Tag ist noch leer.",
                                    style: TextStyle(
                                        color: CupertinoColors.systemGrey
                                            .withOpacity(0.5))),
                              ],
                            ),
                          ),
                        )
                      else
                        ..._schedule.map((slot) => _buildTimelineItem(slot)),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(dynamic slot) {
    final start = DateTime.parse(slot['start_time']);
    final end = DateTime.parse(slot['end_time']);
    final duration = end.difference(start).inMinutes;
    final fmt = DateFormat('HH:mm');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NativeGlassContainer(
        padding: EdgeInsets.zero,
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Zeitstreifen
              Container(
                width: 4,
                decoration: const BoxDecoration(
                  color: CupertinoColors.systemCyan,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(slot['name'],
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(CupertinoIcons.time,
                              size: 14, color: CupertinoColors.systemGrey),
                          const SizedBox(width: 6),
                          Text("${fmt.format(start)} - ${fmt.format(end)}",
                              style: const TextStyle(
                                  color: CupertinoColors.systemGrey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(4)),
                            child: Text("$duration min",
                                style: const TextStyle(
                                    color: CupertinoColors.systemGrey,
                                    fontSize: 12)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- LOKALE HELPER (Da wir theme.dart haben, hier nur als Wrapper für Windows-Support) ---
// Da in lib/theme.dart LiquidGlass definiert ist, nutzen wir das hier als NativeGlassContainer
// für Kompatibilität mit dem restlichen Code
class NativeGlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  const NativeGlassContainer(
      {super.key, required this.child, this.padding, this.color});

  @override
  Widget build(BuildContext context) {
    // Wir nutzen hier direkt das LiquidGlass Widget aus theme.dart
    return LiquidGlass(
      padding: padding,
      child: child,
    );
  }
}

// Background wrapper
class BackgroundMesh extends StatelessWidget {
  const BackgroundMesh({super.key});
  @override
  Widget build(BuildContext context) {
    return const LiquidBackground();
  }
}
