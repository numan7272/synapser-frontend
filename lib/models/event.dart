import 'enums.dart';

class Event {
  final String id;
  final String name;
  final TaskType type;
  final int durationMinutes;
  final DateTime? fixedStartTime;
  final int priority;
  final TimePreference? preferredTimeBlock;
  final String? requiredLocation;
  final bool isWeatherDependent;
  final TransportationMode? transportationMode;
  final int planningWindowStartDay;

  const Event({
    required this.id,
    required this.name,
    required this.type,
    required this.durationMinutes,
    this.fixedStartTime,
    this.priority = 3,
    this.preferredTimeBlock,
    this.requiredLocation,
    this.isWeatherDependent = false,
    this.transportationMode,
    this.planningWindowStartDay = 0,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      name: json['name'] as String,
      type: TaskType.fromJson(json['type'] as String),
      durationMinutes: json['duration_minutes'] as int,
      fixedStartTime: json['fixed_start_time'] != null
          ? DateTime.parse(json['fixed_start_time'] as String)
          : null,
      priority: (json['priority'] as int?) ?? 3,
      preferredTimeBlock: json['preferred_time_block'] != null
          ? TimePreference.fromJson(json['preferred_time_block'] as String)
          : null,
      requiredLocation: json['required_location'] as String?,
      isWeatherDependent: (json['is_weather_dependent'] as bool?) ?? false,
      transportationMode: json['transportation_mode'] != null
          ? TransportationMode.fromJson(json['transportation_mode'] as String)
          : null,
      planningWindowStartDay: (json['planning_window_start_day'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toJson(),
      'duration_minutes': durationMinutes,
      'fixed_start_time': fixedStartTime?.toUtc().toIso8601String(),
      'priority': priority,
      'preferred_time_block': preferredTimeBlock?.toJson(),
      'required_location': requiredLocation,
      'is_weather_dependent': isWeatherDependent,
      'transportation_mode': transportationMode?.toJson(),
      'planning_window_start_day': planningWindowStartDay,
    };
  }
}
