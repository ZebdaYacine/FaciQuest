import 'dart:ui' as ui;

import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'auth shell remains scrollable with large text on a short screen',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(667, 375));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: MediaQuery(
            data: const MediaQueryData(
              size: Size(667, 375),
              textScaler: TextScaler.linear(2),
              disableAnimations: true,
            ),
            child: const AuthPageScaffold(
              title: 'A deliberately long authentication title',
              description:
                  'Supporting text remains readable with large system text.',
              icon: Icons.lock_outline_rounded,
              showLanguageMenu: false,
              child: SizedBox(height: 360),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(
        tester.getSize(find.byType(IconButton)).height,
        greaterThanOrEqualTo(48),
      );
      final fade = tester.widget<FadeTransition>(
        find.byKey(const Key('auth-page-entrance')),
      );
      expect(fade.opacity.value, 1);
    },
  );

  test('auth states require passwords with at least eight characters', () {
    final shortSignUp = const SignUpState().copyWith(
      username: 'youcef',
      email: 'youcef@example.com',
      phone: '0555555555',
      password: 'short',
      cPassword: 'short',
      agreeToTerms: true,
    );
    final validSignUp = shortSignUp.copyWith(
      password: 'long-enough',
      cPassword: 'long-enough',
    );

    expect(shortSignUp.isValid, isFalse);
    expect(validSignUp.isValid, isTrue);
    expect(
      SetNewPasswordState(password: 'short', cPassword: 'short').isValid,
      isFalse,
    );
    expect(
      SetNewPasswordState(
        password: 'long-enough',
        cPassword: 'long-enough',
      ).isValid,
      isTrue,
    );
  });

  testWidgets('auth header follows RTL direction', (tester) async {
    await tester.binding.setSurfaceSize(const Size(375, 812));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Directionality(
          textDirection: ui.TextDirection.rtl,
          child: AuthPageScaffold(
            title: 'العنوان',
            description: 'الوصف',
            icon: Icons.lock_outline_rounded,
            showLanguageMenu: false,
            child: SizedBox(height: 40),
          ),
        ),
      ),
    );

    expect(tester.getCenter(find.byType(IconButton)).dx, greaterThan(300));
    expect(tester.takeException(), isNull);
  });
}
