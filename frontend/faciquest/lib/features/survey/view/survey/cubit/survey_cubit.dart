import 'package:equatable/equatable.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'survey_state.dart';

class SurveyCubit extends Cubit<SurveyState> {
  SurveyCubit({
    required this.surveyId,
    required this.repository,
  }) : super(SurveyState());
  final String surveyId;
  final SurveyRepository repository;

  Future<void> submit() async {
    emit(state.copyWith(submissionStatus: Status.showLoading));
    try {
      await repository.submitAnswers(
        SubmissionEntity(
          collectorId: state.survey.collectorId ?? state.survey.id,
          surveyId: surveyId,
          answers: state.answers.values.toList(),
        ),
      );

      if (!isClosed) {
        emit(
          state.copyWith(
            submissionStatus: Status.success,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          submissionStatus: Status.failure,
        ));
      }
    }
  }

  Future<void> getSurvey() async {
    try {
      emit(state.copyWith(status: Status.showLoading));
      final survey = await repository.getSurveyById(surveyId);
      emit(state.copyWith(survey: survey));
    } catch (e) {
      emit(state.copyWith(status: Status.failure));
    }
  }

  void onAnswerChanged(AnswerEntity value) {
    emit(state.copyWith(
      answers: {
        ...state.answers,
        value.questionId: value,
      },
    ));
  }

  void fetchCollectors() {}
}
