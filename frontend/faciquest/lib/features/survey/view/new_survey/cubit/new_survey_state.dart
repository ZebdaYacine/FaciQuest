part of 'new_survey_cubit.dart';

class NewSurveyState extends Equatable {
  final SurveyEntity survey;
  final NewSurveyPages page;
  final NewSurveyPages previousPage;
  final List<TargetingCriteria> targetingCriteria;
  final Status status;
  final String? msg;
  final bool shouldShowCollectorModal;

  NewSurveyState({
    SurveyEntity? survey,
    this.page = NewSurveyPages.surveyDetails,
    NewSurveyPages? previousPage,
    this.status = Status.initial,
    this.targetingCriteria = const [],
    this.msg,
    this.shouldShowCollectorModal = false,
  })  : survey = survey ?? SurveyEntity.empty,
        previousPage = previousPage ?? page;

  @override
  List<Object?> get props => [survey, status, page, msg, targetingCriteria, shouldShowCollectorModal];

  NewSurveyState copyWith({
    SurveyEntity? survey,
    NewSurveyPages? page,
    NewSurveyPages? previousPage,
    List<TargetingCriteria>? targetingCriteria,
    Status? status,
    String? msg,
    bool? shouldShowCollectorModal,
  }) {
    return NewSurveyState(
      survey: survey ?? this.survey,
      page: page ?? this.page,
      previousPage: previousPage ?? this.previousPage,
      status: status ?? Status.initial,
      targetingCriteria: targetingCriteria ?? this.targetingCriteria,
      msg: msg,
      shouldShowCollectorModal: shouldShowCollectorModal ?? this.shouldShowCollectorModal,
    );
  }
}

enum NewSurveyPages {
  summary('Summary'),
  surveyDetails('Survey Details'),
  questions('Questions'),
  collectResponses('Collect Responses'),
  analyseResults('Analyse Results');

  final String title;

  const NewSurveyPages(this.title);
}
