enum TaskType {
  flexibleTask,
  fixedAppointment,
  drivingTime;

  String toJson() {
    switch (this) {
      case TaskType.flexibleTask:
        return 'flexible_task';
      case TaskType.fixedAppointment:
        return 'fixed_appointment';
      case TaskType.drivingTime:
        return 'driving_time';
    }
  }

  static TaskType fromJson(String value) {
    switch (value) {
      case 'flexible_task':
        return TaskType.flexibleTask;
      case 'fixed_appointment':
        return TaskType.fixedAppointment;
      case 'driving_time':
        return TaskType.drivingTime;
      default:
        throw ArgumentError('Unknown TaskType: $value');
    }
  }
}

enum TimePreference {
  morning,
  afternoon,
  evening;

  String toJson() => name;

  static TimePreference fromJson(String value) {
    return TimePreference.values.firstWhere((e) => e.name == value);
  }
}

enum TransportationMode {
  driving,
  walking,
  bicycling,
  transit;

  String toJson() => name;

  static TransportationMode fromJson(String value) {
    return TransportationMode.values.firstWhere((e) => e.name == value);
  }
}
