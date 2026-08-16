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

  test('survey copyWith preserves loaded metrics while collectors refresh',
      () async {
    final collector = CollectorEntity(
      id: 'collector-1',
      name: 'Target audience',
      surveyId: survey.id,
    );
    final loadedSurvey = SurveyEntity(
      id: survey.id,
      name: survey.name,
      responseCount: 42,
      viewCount: 80,
      questionCount: 5,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026, 8),
    );
    final repository = FakeSurveyRepository()
      ..survey = loadedSurvey
      ..collectors = [collector];
    addTearDown(repository.close);
    final cubit = NewSurveyCubit(
      action: SurveyAction.edit,
      surveyId: survey.id,
      repository: repository,
    );
    addTearDown(cubit.close);

    await cubit.fetchSurvey();
    await cubit.fetchCollectors();

    expect(cubit.state.status, Status.success);
    expect(cubit.state.survey.collectors, [collector]);
    expect(cubit.state.survey.responseCount, 42);
    expect(cubit.state.survey.viewCount, 80);
    expect(cubit.state.survey.createdAt, DateTime(2026));
  });

  test('collector deletion persists and reconciles the collector list',
      () async {
    final repository = FakeSurveyRepository()
      ..survey = survey
      ..collectors = const [];
    addTearDown(repository.close);
    final cubit = NewSurveyCubit(
      action: SurveyAction.collectResponses,
      surveyId: survey.id,
      repository: repository,
    );
    addTearDown(cubit.close);

    await cubit.fetchSurvey();
    final deleted = await cubit.deleteCollector('collector-1');

    expect(deleted, isTrue);
    expect(repository.deletedCollectorId, 'collector-1');
    expect(cubit.state.status, Status.success);
    expect(cubit.state.survey.collectors, isEmpty);
  });

  test('workspace navigation preserves successful survey state', () async {
    final repository = FakeSurveyRepository()..survey = survey;
    addTearDown(repository.close);
    final cubit = NewSurveyCubit(
      action: SurveyAction.edit,
      surveyId: survey.id,
      repository: repository,
    );
    addTearDown(cubit.close);

    await cubit.fetchSurvey();
    cubit.goToPage(NewSurveyPages.collectResponses);

    expect(cubit.state.page, NewSurveyPages.collectResponses);
    expect(cubit.state.status, Status.success);
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
