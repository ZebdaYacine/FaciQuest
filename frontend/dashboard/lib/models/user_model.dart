class UserModel {
  final String id;
  final String name;
  final String email;
  final String gender;
  final bool isActive;
  final int surveyCount;
  final int participationCount;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.isActive,
    required this.surveyCount,
    required this.participationCount,
    required this.createdAt,
    this.lastLoginAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      isActive: json['is_active'] ?? false,
      surveyCount: json['survey_count'] ?? 0,
      participationCount: json['participation_count'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      lastLoginAt: json['last_login_at'] != null 
          ? DateTime.tryParse(json['last_login_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': gender,
      'is_active': isActive,
      'survey_count': surveyCount,
      'participation_count': participationCount,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }
}

enum UserGender {
  male,
  female,
  other,
  all;

  String get displayName {
    switch (this) {
      case UserGender.male:
        return 'Male';
      case UserGender.female:
        return 'Female';
      case UserGender.other:
        return 'Other';
      case UserGender.all:
        return 'All';
    }
  }
}

class UserFilters {
  final bool? isActive;
  final UserGender gender;
  final int? minSurveys;
  final int? maxSurveys;
  final int? minParticipations;
  final int? maxParticipations;

  UserFilters({
    this.isActive,
    this.gender = UserGender.all,
    this.minSurveys,
    this.maxSurveys,
    this.minParticipations,
    this.maxParticipations,
  });

  UserFilters copyWith({
    bool? isActive,
    UserGender? gender,
    int? minSurveys,
    int? maxSurveys,
    int? minParticipations,
    int? maxParticipations,
  }) {
    return UserFilters(
      isActive: isActive ?? this.isActive,
      gender: gender ?? this.gender,
      minSurveys: minSurveys ?? this.minSurveys,
      maxSurveys: maxSurveys ?? this.maxSurveys,
      minParticipations: minParticipations ?? this.minParticipations,
      maxParticipations: maxParticipations ?? this.maxParticipations,
    );
  }
}
