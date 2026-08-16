import 'package:faciquest/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('generic fields expose inline errors and advance focus',
      (tester) async {
    final firstFocus = FocusNode();
    final secondFocus = FocusNode();
    addTearDown(firstFocus.dispose);
    addTearDown(secondFocus.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Form(
            child: Column(
              children: [
                GenericInputField(
                  label: 'First field',
                  focusNode: firstFocus,
                  textInputAction: TextInputAction.next,
                  errorMessage: 'Localized inline error',
                ),
                GenericInputField(
                  label: 'Second field',
                  focusNode: secondFocus,
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextFormField).first);
    await tester.pump();
    expect(firstFocus.hasFocus, isTrue);
    expect(find.text('Localized inline error'), findsOneWidget);

    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump();
    expect(secondFocus.hasFocus, isTrue);
  });
}
