import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
