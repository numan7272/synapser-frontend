class ApiConfig {
  // Für Android Emulator: 10.0.2.2 = Host localhost
  // Für iOS Simulator / Web: localhost
  static const String baseUrl = 'http://10.0.2.2:8000';
  static const Duration timeout = Duration(seconds: 30);

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';

  // Protected
  static const String me = '/me';
  static const String onboarding = '/onboarding/submit';
  static const String addWithAi = '/schedule/add-with-ai';
  static const String importFile = '/schedule/import-file';
  static const String resolveConflict = '/schedule/resolve-conflict';
  static const String suggestions = '/suggestions';
}
