import 'package:equatable/equatable.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'new_survey_state.dart';

class NewSurveyCubit extends Cubit<NewSurveyState> {
  NewSurveyCubit() : super(const NewSurveyState());

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

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = state.survey.questions.removeAt(oldIndex);
    state.survey.questions.insert(newIndex, item);
  }

  void removeQuestion(int index) {
    var temp = List<QuestionEntity>.from(state.survey.questions);
    temp.removeAt(index);
    emit(
      state.copyWith(
        survey: state.survey.copyWith(
          questions: temp,
        ),
      ),
    );
  }

  void newQuestionsList(List<QuestionEntity> newQuestions) {
    emit(
      state.copyWith(
        survey: state.survey.copyWith(
          questions: newQuestions,
        ),
      ),
    );
  }
}
