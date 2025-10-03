import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:synapser_frontend/screens/dashboard_screen.dart';
import 'package:synapser_frontend/screens/registration_screen.dart';
import 'package:synapser_frontend/widgets/glass_card.dart';

const String apiUrl = 'https://synapser-api-220389793919.europe-west3.run.app';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'test@example.com');
  final _passwordController =
      TextEditingController(text: 'a-very-secure-password');
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/auth/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'username': _emailController.text,
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final token = json.decode(response.body)['access_token'];
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DashboardScreen(token: token)),
          );
        }
      } else {
        final errorData = json.decode(response.body);
        setState(() {
          _errorMessage = errorData['detail'] ?? 'Login fehlgeschlagen.';
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
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
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: GlassCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('SYNAPSER',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                    const SizedBox(height: 8),
                    Text('Dein proaktiver KI-Assistent',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white70)),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'E-Mail'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Passwort'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 32),
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(_errorMessage!,
                            style: const TextStyle(color: Colors.redAccent)),
                      ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegistrationScreen()),
                        );
                      },
                      child: Text(
                        'Noch kein Konto? Jetzt registrieren',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
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
}
