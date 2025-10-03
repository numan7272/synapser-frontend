import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:synapser_frontend/widgets/glass_card.dart';
import 'package:synapser_frontend/screens/login_screen.dart'; // For apiUrl

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _register() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = "Bitte fülle alle Felder aus.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Registrierung erfolgreich! Du kannst dich jetzt einloggen.'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Zurück zum Login-Screen
        }
      } else {
        final errorData = json.decode(response.body);
        setState(() {
          _errorMessage =
              errorData['detail'] ?? 'Registrierung fehlgeschlagen.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ein Netzwerkfehler ist aufgetreten.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Wiederverwendbarer Hintergrund (könnte man auch auslagern)
          ..._buildBackground(context),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: GlassCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Konto erstellen',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'E-Mail'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                          labelText: 'Passwort (min. 8 Zeichen)'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 32),
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Registrieren',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(_errorMessage!,
                            style: const TextStyle(color: Colors.redAccent)),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return [
      Positioned(
        top: size.height * 0.1,
        left: size.width * 0.1,
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.4),
                Theme.of(context).colorScheme.primary.withOpacity(0),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        bottom: size.height * 0.2,
        right: size.width * 0.15,
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.purpleAccent.withOpacity(0.3),
                Colors.purpleAccent.withOpacity(0),
              ],
            ),
          ),
        ),
      ),
    ];
  }
}
