import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_survey_repository.dart';

void main() {
  testWidgets('question renderer forwards typed answers', (tester) async {
    AnswerEntity? answer;
    final question = ShortAnswerQuestion(
      id: 'question-1',
      title: 'How was your visit?',
      order: 0,
      isRequired: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SurveyQuestionRenderer(
            question: question,
            index: 0,
            onAnswerChanged: (value) => answer = value,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'Excellent');

    expect(answer, isA<ShortAnswerAnswer>());
    expect((answer as ShortAnswerAnswer).value, 'Excellent');
  });

  testWidgets('extracted error state preserves its retry callback',
      (tester) async {
    var retries = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: EnhancedErrorWidget(
            message: 'Connection unavailable',
            onRetry: () => retries++,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(PrimaryButton));

    expect(retries, 1);
  });

  testWidgets('collector failure state exposes a working retry action',
      (tester) async {
    var retries = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: CollectorsFailureStateView(
            onRetry: () async => retries++,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(FilledButton));

    expect(retries, 1);
  });

  testWidgets('polished survey card fits a compact mobile grid',
      (tester) async {
    final repository = FakeSurveyRepository();
    addTearDown(repository.close);
    final cubit = ManageMySurveysCubit(repository);
    addTearDown(cubit.close);
    final survey = SurveyEntity(
      id: 'survey-1',
      name: 'Customer experience feedback survey',
      status: SurveyStatus.active,
      responseCount: 24,
      questions: [
        ShortAnswerQuestion(
          id: 'question-1',
          title: 'What should we improve?',
          order: 0,
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: BlocProvider.value(
          value: cubit,
          child: Scaffold(
            body: SizedBox(
              width: 375,
              height: 330,
              child: EnhancedSurveyCard(survey: survey),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(EnhancedSurveyCard), findsOneWidget);
  });

  testWidgets('survey summary remains scrollable on a compact screen',
      (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final survey = SurveyEntity(
      id: 'survey-1',
      name: 'Quarterly customer experience survey',
      description: 'A concise description that explains the survey purpose.',
      status: SurveyStatus.active,
      responseCount: 42,
      viewCount: 80,
    );
    final repository = FakeSurveyRepository()..survey = survey;
    addTearDown(repository.close);
    final cubit = NewSurveyCubit(
      action: SurveyAction.edit,
      surveyId: survey.id,
      repository: repository,
    );
    addTearDown(cubit.close);
    await cubit.fetchSurvey();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: BlocProvider.value(
          value: cubit,
          child: Scaffold(body: SummaryPage(survey: survey)),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });

  testWidgets('analysis uses expandable response cards on a phone',
      (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final question = ShortAnswerQuestion(
      id: 'question-1',
      title: 'What should we improve?',
      order: 0,
    );
    final survey = SurveyEntity(
      id: 'survey-1',
      name: 'Quarterly customer feedback',
      status: SurveyStatus.active,
      viewCount: 18,
      questions: [question],
      submissions: [
        SubmissionEntity(
          surveyId: 'survey-1',
          collectorId: 'Public link',
          answers: const [
            ShortAnswerAnswer(
              questionId: 'question-1',
              value: 'Faster support',
            ),
          ],
        ),
      ],
    );
    final repository = FakeSurveyRepository()..survey = survey;
    addTearDown(repository.close);
    final cubit = NewSurveyCubit(
      action: SurveyAction.analyze,
      surveyId: survey.id,
      repository: repository,
    );
    addTearDown(cubit.close);
    await cubit.fetchSurvey();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: RepaintBoundary(
          key: const Key('analysis-golden'),
          child: BlocProvider.value(
            value: cubit,
            child: const Scaffold(body: AnalyseResultsPage()),
          ),
        ),
      ),
    );

    await expectLater(
      find.byKey(const Key('analysis-golden')),
      matchesGoldenFile('goldens/analysis_overview_mobile.png'),
    );

    await tester.tap(find.widgetWithText(Tab, 'analysis.responses'));
    await tester.pumpAndSettle();

    expect(find.byType(ExpansionTile), findsOneWidget);
    await tester.tap(find.byType(ExpansionTile));
    await tester.pumpAndSettle();

    expect(find.text('What should we improve?'), findsOneWidget);
    expect(find.text('Faster support'), findsOneWidget);

    await tester.tap(find.widgetWithText(Tab, 'analysis.analytics'));
    await tester.pumpAndSettle();
    expect(find.text('analysis.question_analytics'), findsOneWidget);
  });
}
