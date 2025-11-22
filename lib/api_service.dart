import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Für Windows lokal
  static const String baseUrl = 'http://127.0.0.1:8000';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, String>> _headers() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // --- AUTHENTIFIZIERUNG ---

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        body: {'username': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['access_token']);
        return true;
      }
      print("Login Failed: ${response.body}");
      return false;
    } catch (e) {
      print('Login Network Error: $e');
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'home_location': 'Nicht festgelegt'
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Register Error: $e');
      return false;
    }
  }

  // --- ONBOARDING (NEU) ---

  Future<bool> submitOnboarding({
    required String occupation,
    required String workHours,
    required String homeLocation,
    List<String> hobbies = const [],
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/onboarding/submit'),
        headers: await _headers(),
        body: json.encode({
          "occupation": occupation,
          "work_hours": workHours,
          "home_location": homeLocation,
          "hobbies": hobbies
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Onboarding Error: $e');
      return false;
    }
  }

  // --- FEATURES ---

  Future<Map<String, dynamic>> planTask(String text) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/schedule/add-with-ai'),
        headers: await _headers(),
        body: json.encode({"current_events": [], "new_task_text": text}),
      );
      return _parseResponse(response);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> resolveConflict(
      Map<String, dynamic> originalReq, Map<String, dynamic> suggestion) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/schedule/resolve-conflict'),
        headers: await _headers(),
        body: json.encode(
            {"original_request": originalReq, "chosen_suggestion": suggestion}),
      );
      return _parseResponse(response);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Map<String, dynamic> _parseResponse(http.Response response) {
    try {
      final decoded = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        return {'success': true, 'data': decoded};
      } else if (response.statusCode == 409) {
        return {'success': false, 'conflict': decoded};
      } else {
        return {
          'success': false,
          'error': decoded['detail'] ?? 'Server Error ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'JSON Parse Error: $e'};
    }
  }
}
