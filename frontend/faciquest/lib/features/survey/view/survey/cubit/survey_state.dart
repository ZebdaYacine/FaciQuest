part of 'survey_cubit.dart';

class SurveyState extends Equatable {
  final Status status;
  final Status submissionStatus;
  final SurveyEntity survey;

  final Set<AnswerEntity> answers;

  SurveyState({
    this.status = Status.initial,
    this.submissionStatus = Status.initial,
    SurveyEntity? survey,
    this.answers = const {},
  }) : survey = survey ?? SurveyEntity.empty;

  SurveyState copyWith({
    Status? status,
    Status? submissionStatus,
    SurveyEntity? survey,
    Set<AnswerEntity>? answers,
  }) {
    return SurveyState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      status: status ?? Status.initial,
      survey: survey ?? this.survey,
      answers: answers ?? this.answers,
    );
  }

  @override
  List<Object?> get props => [status, submissionStatus, survey, answers];
}
