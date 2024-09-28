import 'package:equatable/equatable.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'new_survey_state.dart';

class NewSurveyCubit extends Cubit<NewSurveyState> {
  NewSurveyCubit(SurveyAction action)
      : super(NewSurveyState(
          page: _pageFromAction(action),
        ));

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
      page: NewSurveyPages
          .values[(state.page.index + 1) % NewSurveyPages.values.length],
    ));
  }

  back() {
    emit(
      state.copyWith(
        page: NewSurveyPages
            .values[(state.page.index - 1) % NewSurveyPages.values.length],
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

  submitSurvey() async {
    emit(state.copyWith(status: Status.showLoading));
    await Future.delayed(const Duration(seconds: 4));
    emit(state.copyWith(
      status: Status.success,
      page: NewSurveyPages.collectResponses,
    ));
  }

  void refreshList(QuestionEntity value, int index) {
    // Create a copy of the current list of questions
    final updatedQuestions = List<QuestionEntity>.from(state.survey.questions);

    // Replace the question at the given index with the new value
    updatedQuestions[index] = value;

    // Emit the updated state with the modified list of questions
    emit(
      state.copyWith(
        survey: state.survey.copyWith(
          questions: updatedQuestions, // Use the updated list here
        ),
      ),
    );
  }
}

NewSurveyPages _pageFromAction(SurveyAction action) {
  switch (action) {
    case SurveyAction.delete:
    case SurveyAction.newSurvey:
      return NewSurveyPages.surveyDetails;
    case SurveyAction.edit:
      return NewSurveyPages.summary;
    case SurveyAction.preview:
      return NewSurveyPages.questions;
    case SurveyAction.analyze:
      return NewSurveyPages.analyseResults;
    case SurveyAction.collectResponses:
      return NewSurveyPages.collectResponses;
  }
}
