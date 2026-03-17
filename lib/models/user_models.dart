class UserCreate {
  final String email;
  final String password;

  const UserCreate({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class UserProfile {
  final String userId;
  final String email;
  final String? occupation;
  final List<String> hobbies;
  final String? workHours;
  final String homeLocation;

  const UserProfile({
    required this.userId,
    required this.email,
    this.occupation,
    this.hobbies = const [],
    this.workHours,
    this.homeLocation = 'Nicht festgelegt',
  });

  bool get needsOnboarding => occupation == null && hobbies.isEmpty;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'] as String,
      email: json['email'] as String,
      occupation: json['occupation'] as String?,
      hobbies: (json['hobbies'] as List?)?.cast<String>() ?? [],
      workHours: json['work_hours'] as String?,
      homeLocation: (json['home_location'] as String?) ?? 'Nicht festgelegt',
    );
  }
}

class Token {
  final String accessToken;
  final String tokenType;

  const Token({required this.accessToken, required this.tokenType});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
    );
  }
}

class OnboardingRequest {
  final String? occupation;
  final List<String> hobbies;
  final String? workHours;
  final String homeLocation;

  const OnboardingRequest({
    this.occupation,
    this.hobbies = const [],
    this.workHours,
    required this.homeLocation,
  });

  Map<String, dynamic> toJson() {
    return {
      'occupation': occupation,
      'hobbies': hobbies,
      'work_hours': workHours,
      'home_location': homeLocation,
    };
  }
}
