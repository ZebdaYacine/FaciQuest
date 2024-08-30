import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';

part 'new_survey_state.dart';

class NewSurveyCubit extends Cubit<NewSurveyState> {
  NewSurveyCubit() : super(NewSurveyState());

  void onSurveyNameChanged(String value) {
    emit(
      state.copyWith(
        survey: state.survey.copyWith(
          name: value,
        ),
      ),
    );
  }

  void onSurveyDescriptionChanged(String value) {
    emit(
      state.copyWith(
        survey: state.survey.copyWith(
          description: value,
        ),
      ),
    );
  }

  void onSurveyLikertScaleChanged(LikertScale? value) {
    emit(
      state.copyWith(
        survey: state.survey.copyWith(
          likertScale: value,
        ),
      ),
    );
  }

  next() {
    emit(state.copyWith(
      page: NewSurveyPages.values[(state.page.index + 1) % 2],
    ));
  }

  back() {
    emit(
      state.copyWith(
        page: NewSurveyPages.values[(state.page.index - 1) % 2],
      ),
    );
  }

  void newQuestion(QuestionEntity value) {
    emit(
      state.copyWith(
        survey: state.survey.copyWith(
          questions: [...state.survey.questions, value],
        ),
      ),
    );
  }
}
