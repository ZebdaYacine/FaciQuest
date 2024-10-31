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
    await repository.submitAnswers(
      SubmissionEntity(
        collectorId: state.survey.collectorId ?? '',
        answers: state.answers.toList(),
        surveyId: surveyId,
      ),
    );

    if (!isClosed) emit(state.copyWith(submissionStatus: Status.success));
  }

  Future<void> getSurvey() async {
    try {
      emit(state.copyWith(status: Status.showLoading));
      final survey = await repository.getSurveyById(surveyId);
      emit(state.copyWith(status: Status.success, survey: survey));
    } catch (e) {
      emit(state.copyWith(status: Status.failure));
    }
  }

  void onAnswerChanged(AnswerEntity value) {
    final answers = Set<AnswerEntity>.from(state.answers);
    answers.removeWhere((element) => element.questionId == value.questionId);
    answers.add(value);
    emit(
      state.copyWith(
        answers: answers,
      ),
    );
  }

  void fetchCollectors() {}
}
