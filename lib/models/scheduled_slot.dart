class ScheduledSlot {
  final String eventId;
  final String name;
  final DateTime startTime;
  final DateTime endTime;

  const ScheduledSlot({
    required this.eventId,
    required this.name,
    required this.startTime,
    required this.endTime,
  });

  int get durationMinutes => endTime.difference(startTime).inMinutes;

  factory ScheduledSlot.fromJson(Map<String, dynamic> json) {
    return ScheduledSlot(
      eventId: json['event_id'] as String,
      name: json['name'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'name': name,
      'start_time': startTime.toUtc().toIso8601String(),
      'end_time': endTime.toUtc().toIso8601String(),
    };
  }
}
