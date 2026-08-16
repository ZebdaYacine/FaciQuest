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

  void next() {
    emit(state.copyWith(
      previousPage: state.page,
      page: NewSurveyPages
          .values[(state.page.index + 1) % NewSurveyPages.values.length],
    ));
  }

  void back() {
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

    // Create a copy of the questions list to avoid mutating state directly
    final questions = List<QuestionEntity>.from(state.survey.questions);
    final item = questions.removeAt(oldIndex);
    questions.insert(newIndex, item);

    // Emit the new state with the reordered questions
    emit(
      state.copyWith(
        survey: state.survey.copyWith(
          questions: questions,
        ),
      ),
    );
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

  Future<void> submitSurvey() async {
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
        shouldShowCollectorModal:
            action == SurveyAction.newSurvey, // Only show for new surveys
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

  void goToPage(NewSurveyPages page) {
    if (page == state.page) return;
    emit(state.copyWith(page: page, previousPage: state.page));
  }

  Future<bool> deleteSurvey() async {
    try {
      emit(state.copyWith(status: Status.showLoading));
      await repository.deleteSurvey(surveyId);
      if (isClosed) return false;
      emit(state.copyWith(status: Status.success));
      return true;
    } catch (e) {
      if (isClosed) return false;
      emit(state.copyWith(status: Status.failure, msg: e.toString()));
      return false;
    }
  }

  void goToSummary() {
    emit(state.copyWith(
      page: NewSurveyPages.summary,
      previousPage: state.page,
    ));
  }

  Future<void> fetchCollectors() async {
    if (state.survey.id.isEmpty) return;
    emit(state.copyWith(status: Status.showLoading));
    try {
      final collectors = await repository.getSurveyCollectors(state.survey.id);
      if (isClosed) return;
      emit(
        state.copyWith(
          status: Status.success,
          survey: state.survey.copyWith(
            collectors: collectors,
          ),
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(status: Status.failure, msg: e.toString()));
    }
  }

  Future<List<TargetingCriteria>> fetchTargetingCriteria() {
    if (state.targetingCriteria.isNotEmpty) {
      return Future.value(state.targetingCriteria);
    }
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

  Future<void> createCollector(CollectorEntity collector) async {
    await repository.createCollector(collector);
  }

  Future<bool> deleteCollector(String id) async {
    emit(state.copyWith(status: Status.showLoading));
    try {
      await repository.deleteCollector(id);
      final collectors = await repository.getSurveyCollectors(state.survey.id);
      if (isClosed) return false;
      emit(
        state.copyWith(
          status: Status.success,
          survey: state.survey.copyWith(collectors: collectors),
        ),
      );
      return true;
    } catch (e) {
      if (isClosed) return false;
      emit(state.copyWith(status: Status.failure, msg: e.toString()));
      return false;
    }
  }

  Future<List<SubmissionEntity>> fetchSubmissionPage(
      {required int page, required pageSize}) async {
    final submissions = await repository.getSubmissions(
      surveyId: state.survey.id,
      page: page,
      pageSize: pageSize,
    );
    emit(state.copyWith(
        survey: state.survey.copyWith(
      submissions: submissions,
    )));
    return submissions;
  }

  void resetCollectorModalFlag() {
    emit(state.copyWith(shouldShowCollectorModal: false));
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
