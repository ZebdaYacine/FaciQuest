import 'package:faciquest/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('light theme uses the accessible FaciQuest blue palette', () {
    expect(AppTheme.light.colorScheme.primary, kPrimaryDarkColor);
    expect(AppTheme.light.colorScheme.primaryContainer, kPrimaryContainerColor);
  });

  Future<void> pumpAdaptiveBody(
    WidgetTester tester, {
    required Size size,
  }) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: AdaptivePageBody(
            child: SizedBox(
              key: Key('content'),
              width: double.infinity,
              height: 20,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('uses compact gutters on a small phone', (tester) async {
    await pumpAdaptiveBody(tester, size: const Size(375, 812));

    final content = tester.getRect(find.byKey(const Key('content')));
    expect(content.left, 24);
    expect(content.right, 351);
  });

  testWidgets('constrains content width on a tablet', (tester) async {
    await pumpAdaptiveBody(tester, size: const Size(1024, 768));

    final content = tester.getRect(find.byKey(const Key('content')));
    expect(content.width, 720);
    expect(content.center.dx, 512);
  });

  testWidgets('constrains sliver content on an expanded layout',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: CustomScrollView(
            slivers: [
              AdaptiveSliverPadding(
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    key: Key('sliver-content'),
                    width: double.infinity,
                    height: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final content = tester.getRect(find.byKey(const Key('sliver-content')));
    expect(content.width, 1200);
    expect(content.center.dx, 720);
  });

  testWidgets('global button theme keeps primary actions touch friendly',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Center(
            child: FilledButton(
              onPressed: () {},
              child: const Text('Continue'),
            ),
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(FilledButton)).height,
      greaterThanOrEqualTo(52),
    );
  });
}
