import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, onboardingRequired }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final ApiService _apiService;

  AuthStatus _status = AuthStatus.initial;
  UserProfile? _currentUser;
  String? _error;

  AuthProvider(this._authService, this._apiService);

  AuthStatus get status => _status;
  UserProfile? get currentUser => _currentUser;
  String? get error => _error;

  Future<void> tryAutoLogin() async {
    _status = AuthStatus.loading;
    notifyListeners();

    final profile = await _authService.tryAutoLogin();
    if (profile == null) {
      _status = AuthStatus.unauthenticated;
    } else {
      _currentUser = profile;
      _status = profile.needsOnboarding
          ? AuthStatus.onboardingRequired
          : AuthStatus.authenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _error = null;
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final profile = await _authService.login(email, password);
      _currentUser = profile;
      _status = profile.needsOnboarding
          ? AuthStatus.onboardingRequired
          : AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    _error = null;
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final profile = await _authService.register(email, password);
      _currentUser = profile;
      _status = AuthStatus.onboardingRequired;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> submitOnboarding(OnboardingRequest request) async {
    try {
      final profile = await _apiService.submitOnboarding(request);
      _currentUser = profile;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  String _parseError(dynamic e) {
    if (e is DioException) {
      final detail = e.response?.data?['detail'];
      if (detail is String) return detail;
      return 'Netzwerkfehler. Bitte versuche es erneut.';
    }
    return e.toString().replaceAll('Exception: ', '');
  }
}
