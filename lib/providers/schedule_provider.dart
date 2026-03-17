import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class ScheduleProvider extends ChangeNotifier {
  final ApiService _apiService;

  List<ScheduledSlot> _currentSchedule = [];
  String? _explanation;
  SchedulingConflictResponse? _activeConflict;
  SchedulingRequest? _pendingRequest;
  bool _isLoading = false;
  String? _error;

  ScheduleProvider(this._apiService);

  List<ScheduledSlot> get currentSchedule => _currentSchedule;
  String? get explanation => _explanation;
  SchedulingConflictResponse? get activeConflict => _activeConflict;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<ScheduledSlot> getScheduleForDate(DateTime date) {
    return _currentSchedule.where((slot) {
      final local = slot.startTime.toLocal();
      return local.year == date.year &&
          local.month == date.month &&
          local.day == date.day;
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  List<Event> _slotsToEvents() {
    return _currentSchedule.map((slot) {
      return Event(
        id: slot.eventId,
        name: slot.name,
        type: TaskType.fixedAppointment,
        durationMinutes: slot.durationMinutes,
        fixedStartTime: slot.startTime,
      );
    }).toList();
  }

  Future<bool> addTaskWithAi(String taskText) async {
    _isLoading = true;
    _error = null;
    _activeConflict = null;
    notifyListeners();

    final request = SchedulingRequest(
      currentEvents: _slotsToEvents(),
      newTaskText: taskText,
    );

    try {
      final response = await _apiService.addWithAi(request);
      _currentSchedule = response.schedule;
      _explanation = response.explanation;
      _isLoading = false;
      notifyListeners();
      return true;
    } on SchedulingConflictException catch (e) {
      _activeConflict = e.conflict;
      _pendingRequest = request;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> importFile(File file) async {
    _isLoading = true;
    _error = null;
    _activeConflict = null;
    notifyListeners();

    try {
      final response = await _apiService.importFile(file, _slotsToEvents());
      _currentSchedule = response.schedule;
      _explanation = response.explanation;
      _isLoading = false;
      notifyListeners();
      return true;
    } on SchedulingConflictException catch (e) {
      _activeConflict = e.conflict;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resolveConflict(ResolutionSuggestion suggestion) async {
    if (_pendingRequest == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final request = ResolveConflictRequest(
        originalRequest: _pendingRequest!,
        chosenSuggestion: suggestion,
      );
      final response = await _apiService.resolveConflict(request);
      _currentSchedule = response.schedule;
      _explanation = response.explanation;
      _activeConflict = null;
      _pendingRequest = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearConflict() {
    _activeConflict = null;
    _pendingRequest = null;
    notifyListeners();
  }

  void clearExplanation() {
    _explanation = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
