import 'survey_entity.dart';

class SurveyFilters {
  final SurveyStatus status;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? minReward;
  final double? maxReward;

  SurveyFilters({this.status = SurveyStatus.active, this.startDate, this.endDate, this.minReward, this.maxReward});

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
