import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class SuggestionProvider extends ChangeNotifier {
  final ApiService _apiService;

  List<ProactiveSuggestion> _suggestions = [];
  bool _isLoading = false;
  String? _error;

  SuggestionProvider(this._apiService);

  List<ProactiveSuggestion> get suggestions => _suggestions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSuggestions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getSuggestions();
      _suggestions = response.suggestions;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void dismissSuggestion(String suggestionId) {
    _suggestions.removeWhere((s) => s.suggestionId == suggestionId);
    notifyListeners();
  }
}
