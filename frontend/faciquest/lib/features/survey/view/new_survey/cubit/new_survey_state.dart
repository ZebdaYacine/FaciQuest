part of 'new_survey_cubit.dart';

class NewSurveyState extends Equatable {
  final SurveyEntity survey;
  final NewSurveyPages page;
  final NewSurveyPages previousPage;
  final Status status;
  final String? msg;
  

  NewSurveyState({
    SurveyEntity? survey,
    this.page = NewSurveyPages.surveyDetails,
    NewSurveyPages? previousPage,
    this.status = Status.initial,
    this.msg,
  })  : survey = survey ?? SurveyEntity.empty,
        previousPage = previousPage ?? page;

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
    NewSurveyPages? previousPage,
    Status? status,
    String? msg,
  }) {
    return NewSurveyState(
      survey: survey ?? this.survey,
      page: page ?? this.page,
      previousPage: previousPage ?? this.previousPage,
      status: status ?? Status.initial,
      msg: msg,
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
