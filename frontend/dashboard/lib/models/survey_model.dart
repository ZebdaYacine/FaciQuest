class SurveyModel {
  final String id;
  final String title;
  final String description;
  final SurveyStatus status;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? publishedAt;
  final int participantCount;
  final double rewardAmount;
  final int questionCount;

  SurveyModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    this.publishedAt,
    required this.participantCount,
    required this.rewardAmount,
    required this.questionCount,
  });

  factory SurveyModel.fromJson(Map<String, dynamic> json) {
    return SurveyModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: SurveyStatus.fromString(json['status'] ?? 'pending'),
      createdBy: json['created_by'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      publishedAt: json['published_at'] != null 
          ? DateTime.tryParse(json['published_at']) 
          : null,
      participantCount: json['participant_count'] ?? 0,
      rewardAmount: (json['reward_amount'] ?? 0.0).toDouble(),
      questionCount: json['question_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.value,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'published_at': publishedAt?.toIso8601String(),
      'participant_count': participantCount,
      'reward_amount': rewardAmount,
      'question_count': questionCount,
    };
  }
}

enum SurveyStatus {
  pending('pending'),
  published('published'),
  rejected('rejected'),
  draft('draft'),
  all('all');

  const SurveyStatus(this.value);
  final String value;

  static SurveyStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return SurveyStatus.pending;
      case 'published':
        return SurveyStatus.published;
      case 'rejected':
        return SurveyStatus.rejected;
      case 'draft':
        return SurveyStatus.draft;
      default:
        return SurveyStatus.pending;
    }
  }

  String get displayName {
    switch (this) {
      case SurveyStatus.pending:
        return 'Pending';
      case SurveyStatus.published:
        return 'Published';
      case SurveyStatus.rejected:
        return 'Rejected';
      case SurveyStatus.draft:
        return 'Draft';
      case SurveyStatus.all:
        return 'All';
    }
  }
}

class SurveyFilters {
  final SurveyStatus status;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? minReward;
  final double? maxReward;

  SurveyFilters({
    this.status = SurveyStatus.all,
    this.startDate,
    this.endDate,
    this.minReward,
    this.maxReward,
  });

  SurveyFilters copyWith({
    SurveyStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    double? minReward,
    double? maxReward,
  }) {
    return SurveyFilters(
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      minReward: minReward ?? this.minReward,
      maxReward: maxReward ?? this.maxReward,
    );
  }
}
