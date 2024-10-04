import 'package:equatable/equatable.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'new_survey_state.dart';

class NewSurveyCubit extends Cubit<NewSurveyState> {
  NewSurveyCubit({
    required this.surveyId,
    required this.action,
    required this.repository,
  }) : super(NewSurveyState(
          page: _pageFromAction(action),
        ));
  final SurveyAction action;
  final SurveyRepository repository;
  final String surveyId;
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
      previousPage: state.page,
      page: NewSurveyPages
          .values[(state.page.index + 1) % NewSurveyPages.values.length],
    ));
  }

  back() {
    emit(
      state.copyWith(
        page: (state.page == NewSurveyPages.questions)
            ? NewSurveyPages.surveyDetails
            : state.previousPage,
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
    if (action != SurveyAction.newSurvey && action != SurveyAction.edit) {
      return;
    }
    try {
      SurveyEntity? result;
      emit(state.copyWith(status: Status.showLoading));
      if (action == SurveyAction.newSurvey) {
        result = await repository.createSurvey(state.survey);
      } else {
        result = await repository.updateSurvey(state.survey);
      }
      emit(state.copyWith(
        status: Status.success,
        survey: result,
        page: NewSurveyPages.collectResponses,
        previousPage: state.page,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        msg: e.toString(),
      ));
    }
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

  Future<void> fetchSurvey() async {
    if (surveyId.isNotEmpty && surveyId != '-1') {
      emit(state.copyWith(status: Status.showLoading));
      await repository.getSurveyById(surveyId).then(
        (value) {
          emit(state.copyWith(survey: value, status: Status.success));
        },
      ).catchError((e) {
        emit(state.copyWith(status: Status.failure, msg: e.toString()));
      });
    } else {
      emit(state.copyWith(page: _pageFromAction(SurveyAction.newSurvey)));
    }
  }

  void editSurvey() {
    emit(state.copyWith(
      page: NewSurveyPages.surveyDetails,
      previousPage: state.page,
    ));
  }

  void sendSurvey() {
    emit(state.copyWith(
      page: NewSurveyPages.collectResponses,
      previousPage: state.page,
    ));
  }

  void analyzeSurvey() {
    emit(state.copyWith(
      page: NewSurveyPages.analyseResults,
      previousPage: state.page,
    ));
  }

  Future<void> deleteSurvey() async {
    try {
      await repository.deleteSurvey(surveyId);
    } catch (e) {
      emit(state.copyWith(status: Status.failure, msg: e.toString()));
    }
  }

  void goToSummary() {
    emit(state.copyWith(
      page: NewSurveyPages.summary,
      previousPage: state.page,
    ));
  }

  void fetchCollectors() async {
    final collectors = await repository.getMyCollectors(state.survey.id);
    emit(
      state.copyWith(
        survey: state.survey.copyWith(
          collectors: collectors,
        ),
      ),
    );
  }

  Future<List<TargetingCriteria>> fetchTargetingCriteria() {
    return repository.getTargetingCriteria();
  }

  Future<double?> estimatePrice(CollectorEntity collector) async {
    try {
      return repository.estimatePrice(collector);
    } catch (e) {
      emit(state.copyWith(status: Status.failure, msg: e.toString()));
    }
    return null;
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
