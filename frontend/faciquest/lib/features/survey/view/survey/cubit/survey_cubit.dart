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

  Future<void> getSurvey() async {
    try {
      emit(state.copyWith(status: Status.showLoading));
      final survey = await repository.getSurveyById(surveyId);
      emit(state.copyWith(status: Status.success, survey: survey));
    } catch (e) {
      emit(state.copyWith(status: Status.failure));
    }
  }
}
