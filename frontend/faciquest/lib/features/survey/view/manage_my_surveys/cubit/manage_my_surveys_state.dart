part of 'manage_my_surveys_cubit.dart';

class ManageMySurveysState {
  List<SurveyEntity> get filteredSurveys {
    if (searchQuery == null || searchQuery!.isEmpty) {
      return surveys;
    }
    return surveys.where((survey) {
      return survey.name.toLowerCase().contains(searchQuery!.toLowerCase()) ||
          survey.id.toLowerCase().contains(searchQuery!.toLowerCase());
    }).toList();
  }

  final Status status;
  final String? msg;
  final List<SurveyEntity> surveys;
  final String? searchQuery;

  ManageMySurveysState({
    this.status = Status.initial,
    this.msg,
    this.surveys = const [],
    this.searchQuery,
  });

  ManageMySurveysState copyWith({
    Status? status,
    String? msg,
    List<SurveyEntity>? surveys,
    String? searchQuery,
  }) {
    return ManageMySurveysState(
      status: status ?? this.status,
      msg: msg ?? this.msg,
      surveys: surveys ?? this.surveys,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
