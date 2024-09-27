part of 'survey_cubit.dart';

class SurveyState {
  final Status status;
  final SurveyEntity survey;

  SurveyState({
    this.status = Status.initial,
    this.survey = SurveyEntity.empty,
  });
}
