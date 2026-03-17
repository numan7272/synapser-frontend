import '../models/models.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _apiService;
  final StorageService _storageService;

  AuthService(this._apiService, this._storageService);

  Future<UserProfile> login(String email, String password) async {
    final token = await _apiService.login(email, password);
    await _storageService.saveToken(token.accessToken);
    return await _apiService.getMe();
  }

  Future<UserProfile> register(String email, String password) async {
    await _apiService.register(email, password);
    return await login(email, password);
  }

  Future<UserProfile?> tryAutoLogin() async {
    final token = await _storageService.getToken();
    if (token == null) return null;
    try {
      return await _apiService.getMe();
    } catch (_) {
      await _storageService.deleteToken();
      return null;
    }
  }

  Future<void> logout() async {
    await _storageService.clearAll();
  }
}
