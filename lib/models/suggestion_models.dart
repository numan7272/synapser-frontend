import 'event.dart';

class ProactiveSuggestion {
  final String suggestionId;
  final String title;
  final String description;
  final Event eventToSchedule;

  const ProactiveSuggestion({
    required this.suggestionId,
    required this.title,
    required this.description,
    required this.eventToSchedule,
  });

  factory ProactiveSuggestion.fromJson(Map<String, dynamic> json) {
    return ProactiveSuggestion(
      suggestionId: json['suggestion_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      eventToSchedule: Event.fromJson(json['event_to_schedule'] as Map<String, dynamic>),
    );
  }
}

class SuggestionResponse {
  final List<ProactiveSuggestion> suggestions;

  const SuggestionResponse({required this.suggestions});

  factory SuggestionResponse.fromJson(Map<String, dynamic> json) {
    return SuggestionResponse(
      suggestions: (json['suggestions'] as List)
          .map((s) => ProactiveSuggestion.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}
