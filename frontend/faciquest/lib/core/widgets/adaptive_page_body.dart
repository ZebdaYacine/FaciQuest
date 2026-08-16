import 'package:flutter/material.dart';

/// Applies safe, adaptive gutters and a readable maximum content width.
class AdaptivePageBody extends StatelessWidget {
  const AdaptivePageBody({
    required this.child,
    super.key,
    this.maxWidth = 720,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontal = switch (constraints.maxWidth) {
          >= 840 => 48.0,
          >= 600 => 32.0,
          _ => 24.0,
        };

        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding:
                padding ?? EdgeInsets.fromLTRB(horizontal, 16, horizontal, 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

/// Centers non-scrolling page content without adding another scroll view.
class AdaptiveContentWidth extends StatelessWidget {
  const AdaptiveContentWidth({
    required this.child,
    super.key,
    this.maxWidth = 1200,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

/// Sliver equivalent of [AdaptivePageBody] for custom-scroll-view screens.
class AdaptiveSliverPadding extends StatelessWidget {
  const AdaptiveSliverPadding({
    required this.sliver,
    super.key,
    this.maxWidth = 1200,
    this.top = 16,
    this.bottom = 24,
  });

  final Widget sliver;
  final double maxWidth;
  final double top;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.crossAxisExtent;
        final baseGutter = switch (width) {
          >= 840 => 48.0,
          >= 600 => 32.0,
          _ => 24.0,
        };
        final horizontal = width > maxWidth + (baseGutter * 2)
            ? (width - maxWidth) / 2
            : baseGutter;

        return SliverPadding(
          padding: EdgeInsets.fromLTRB(horizontal, top, horizontal, bottom),
          sliver: sliver,
        );
      },
    );
  }
}

extension MotionPreferences on BuildContext {
  /// Whether non-essential transitions should be removed for accessibility.
  bool get prefersReducedMotion => MediaQuery.disableAnimationsOf(this);
}
