import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_survey_repository.dart';

void main() {
  final survey = SurveyEntity(
    id: 'survey-1',
    name: 'Customer feedback',
    status: SurveyStatus.active,
  );

  test('home cubit emits streamed surveys for the extracted home list',
      () async {
    final repository = FakeSurveyRepository();
    addTearDown(repository.close);
    final cubit = HomeCubit(repository);
    addTearDown(cubit.close);

    repository.surveysController.add([survey]);
    await expectLater(
      cubit.stream,
      emits(
        isA<HomeState>()
            .having((state) => state.status, 'status', Status.success)
            .having((state) => state.surveys, 'surveys', [survey]),
      ),
    );
  });

  test('manage-surveys cubit feeds filtering and sorting slices', () async {
    final repository = FakeSurveyRepository()
      ..mySurveys = [
        survey,
        SurveyEntity(id: 'draft-1', name: 'Draft', status: SurveyStatus.draft),
      ];
    addTearDown(repository.close);
    final cubit = ManageMySurveysCubit(repository);
    addTearDown(cubit.close);

    await cubit.fetchSurveys();
    cubit.updateFilter(FilterOption.active);

    expect(cubit.state.status, Status.success);
    expect(cubit.state.filteredSurveys, [survey]);
  });

  test('new-survey cubit preserves details across collect and analysis pages',
      () {
    final repository = FakeSurveyRepository();
    addTearDown(repository.close);
    final cubit = NewSurveyCubit(
      action: SurveyAction.newSurvey,
      surveyId: '-1',
      repository: repository,
    );
    addTearDown(cubit.close);

    cubit.onSurveyNameChanged('Research survey');
    cubit.sendSurvey();
    expect(cubit.state.page, NewSurveyPages.collectResponses);
    expect(cubit.state.survey.name, 'Research survey');

    cubit.analyzeSurvey();
    expect(cubit.state.page, NewSurveyPages.analyseResults);
    expect(cubit.state.survey.name, 'Research survey');
  });

  test('survey cubit loads the survey used by the question renderer', () async {
    final repository = FakeSurveyRepository()..survey = survey;
    addTearDown(repository.close);
    final cubit = SurveyCubit(surveyId: survey.id, repository: repository);
    addTearDown(cubit.close);

    await cubit.getSurvey();

    expect(cubit.state.survey, survey);
    expect(cubit.state.status, Status.success);
  });
}
