import 'event.dart';
import 'scheduled_slot.dart';

class SchedulingRequest {
  final List<Event> currentEvents;
  final String newTaskText;

  const SchedulingRequest({
    this.currentEvents = const [],
    this.newTaskText = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'current_events': currentEvents.map((e) => e.toJson()).toList(),
      'new_task_text': newTaskText,
    };
  }
}

class SchedulingResponse {
  final List<ScheduledSlot> schedule;
  final String explanation;

  const SchedulingResponse({
    required this.schedule,
    required this.explanation,
  });

  factory SchedulingResponse.fromJson(Map<String, dynamic> json) {
    return SchedulingResponse(
      schedule: (json['schedule'] as List)
          .map((s) => ScheduledSlot.fromJson(s as Map<String, dynamic>))
          .toList(),
      explanation: json['explanation'] as String,
    );
  }
}

class ConflictInfo {
  final String eventId;
  final String name;
  final DateTime conflictingTime;

  const ConflictInfo({
    required this.eventId,
    required this.name,
    required this.conflictingTime,
  });

  factory ConflictInfo.fromJson(Map<String, dynamic> json) {
    return ConflictInfo(
      eventId: json['event_id'] as String,
      name: json['name'] as String,
      conflictingTime: DateTime.parse(json['conflicting_time'] as String),
    );
  }
}

class ResolutionSuggestion {
  final String suggestionText;
  final String action;
  final Map<String, dynamic> payload;

  const ResolutionSuggestion({
    required this.suggestionText,
    required this.action,
    required this.payload,
  });

  factory ResolutionSuggestion.fromJson(Map<String, dynamic> json) {
    return ResolutionSuggestion(
      suggestionText: json['suggestion_text'] as String,
      action: json['action'] as String,
      payload: Map<String, dynamic>.from(json['payload'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'suggestion_text': suggestionText,
      'action': action,
      'payload': payload,
    };
  }
}

class SchedulingConflictResponse {
  final String message;
  final List<ConflictInfo> conflictingEvents;
  final List<ResolutionSuggestion> suggestions;

  const SchedulingConflictResponse({
    required this.message,
    required this.conflictingEvents,
    required this.suggestions,
  });

  factory SchedulingConflictResponse.fromJson(Map<String, dynamic> json) {
    return SchedulingConflictResponse(
      message: json['message'] as String,
      conflictingEvents: (json['conflicting_events'] as List)
          .map((c) => ConflictInfo.fromJson(c as Map<String, dynamic>))
          .toList(),
      suggestions: (json['suggestions'] as List)
          .map((s) => ResolutionSuggestion.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ResolveConflictRequest {
  final SchedulingRequest originalRequest;
  final ResolutionSuggestion chosenSuggestion;

  const ResolveConflictRequest({
    required this.originalRequest,
    required this.chosenSuggestion,
  });

  Map<String, dynamic> toJson() {
    return {
      'original_request': originalRequest.toJson(),
      'chosen_suggestion': chosenSuggestion.toJson(),
    };
  }
}
