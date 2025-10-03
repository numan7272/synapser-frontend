import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final String token;
  const DashboardScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    // Hier werden wir die Vorschläge anzeigen
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const Center(
          child: Text('Login erfolgreich! Willkommen bei Synapser.')),
    );
  }
}
