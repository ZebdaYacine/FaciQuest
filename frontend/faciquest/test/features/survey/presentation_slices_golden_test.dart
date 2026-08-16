import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpSlice(
    WidgetTester tester,
    Widget child, {
    Size size = const Size(390, 700),
  }) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: RepaintBoundary(
          key: const Key('golden-surface'),
          child: Scaffold(body: child),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('home survey-section golden', (tester) async {
    await pumpSlice(
      tester,
      const CustomScrollView(slivers: [HomeSurveySectionHeader()]),
      size: const Size(390, 140),
    );

    await expectLater(
      find.byKey(const Key('golden-surface')),
      matchesGoldenFile('goldens/home_survey_section.png'),
    );
  });

  testWidgets('manage-surveys failure-state golden', (tester) async {
    await pumpSlice(
      tester,
      EnhancedErrorWidget(message: 'Connection unavailable', onRetry: () {}),
    );

    await expectLater(
      find.byKey(const Key('golden-surface')),
      matchesGoldenFile('goldens/manage_surveys_failure.png'),
    );
  });

  testWidgets('collector loading-state golden', (tester) async {
    await pumpSlice(tester, const CollectorsLoadingStateView());

    await expectLater(
      find.byKey(const Key('golden-surface')),
      matchesGoldenFile('goldens/collectors_loading.png'),
    );
  });

  testWidgets('survey empty-state golden', (tester) async {
    await pumpSlice(tester, const SurveyEmptyStateView());

    await expectLater(
      find.byKey(const Key('golden-surface')),
      matchesGoldenFile('goldens/survey_empty.png'),
    );
  });

  testWidgets('analysis empty-state golden', (tester) async {
    await pumpSlice(tester, const AnalysisEmptyStateView());

    await expectLater(
      find.byKey(const Key('golden-surface')),
      matchesGoldenFile('goldens/analysis_empty.png'),
    );
  });
}
