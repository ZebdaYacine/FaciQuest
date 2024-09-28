part of 'new_survey_cubit.dart';

class NewSurveyState extends Equatable {
  final SurveyEntity survey;
  final NewSurveyPages page;
  final Status status;
  final String? msg;

  NewSurveyState({
    SurveyEntity? survey,
    this.page = NewSurveyPages.surveyDetails,
    this.status = Status.initial,
    this.msg,
  }) : survey = survey ?? SurveyEntity.empty;

  @override
  List<Object?> get props => [
        survey,
        status,
        page,
        msg,
      ];

  NewSurveyState copyWith({
    SurveyEntity? survey,
    NewSurveyPages? page,
    Status? status,
    String? msg,
  }) {
    return NewSurveyState(
      survey: survey ?? this.survey,
      page: page ?? this.page,
      status: status ?? Status.initial,
      msg: msg,
    );
  }
}

enum NewSurveyPages {
  summary,
  surveyDetails,
  questions,
  collectResponses,
  analyseResults
}
