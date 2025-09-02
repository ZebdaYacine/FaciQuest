import 'package:flutter/material.dart';
import 'package:awesome_extensions/awesome_extensions.dart';

import '../core.dart';

class LoadingSkeleton extends StatefulWidget {
  const LoadingSkeleton({
    super.key,
    required this.child,
    this.isLoading = true,
    this.shimmerColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  });

  final Widget child;
  final bool isLoading;
  final Color? shimmerColor;
  final Color? highlightColor;
  final Duration duration;

  @override
  State<LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    final shimmerColor = widget.shimmerColor ?? context.colorScheme.surfaceContainerHighest.withOpacity(0.3);
    final highlightColor = widget.highlightColor ?? context.colorScheme.surface.withOpacity(0.8);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.0, 0.5, 1.0],
              colors: [
                shimmerColor,
                highlightColor,
                shimmerColor,
              ],
              transform: _SlidingGradientTransform(_animation.value),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.slidePercent);

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

// Skeleton components for common UI elements
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.isLoading = true,
  });

  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return LoadingSkeleton(
      isLoading: isLoading,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class SkeletonText extends StatelessWidget {
  const SkeletonText({
    super.key,
    required this.width,
    this.height = 14,
    this.borderRadius,
    this.isLoading = true,
  });

  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: width,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(4),
      isLoading: isLoading,
    );
  }
}

class SkeletonAvatar extends StatelessWidget {
  const SkeletonAvatar({
    super.key,
    this.size = 48,
    this.isLoading = true,
  });

  final double size;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
      isLoading: isLoading,
    );
  }
}

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({
    super.key,
    this.padding,
    this.isLoading = true,
    this.showAvatar = true,
    this.showSubtitle = true,
  });

  final EdgeInsets? padding;
  final bool isLoading;
  final bool showAvatar;
  final bool showSubtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? AppSpacing.spacing_3.padding,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (showAvatar) ...[
                SkeletonAvatar(
                  size: 48,
                  isLoading: isLoading,
                ),
                AppSpacing.spacing_3.widthBox,
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonText(
                      width: 200,
                      height: 18,
                      isLoading: isLoading,
                    ),
                    if (showSubtitle) ...[
                      AppSpacing.spacing_1.heightBox,
                      SkeletonText(
                        width: 150,
                        height: 14,
                        isLoading: isLoading,
                      ),
                    ],
                  ],
                ),
              ),
              SkeletonBox(
                width: 24,
                height: 24,
                borderRadius: BorderRadius.circular(4),
                isLoading: isLoading,
              ),
            ],
          ),
          AppSpacing.spacing_3.heightBox,
          SkeletonText(
            width: double.infinity,
            height: 14,
            isLoading: isLoading,
          ),
          AppSpacing.spacing_1.heightBox,
          SkeletonText(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 14,
            isLoading: isLoading,
          ),
          AppSpacing.spacing_3.heightBox,
          Row(
            children: [
              SkeletonBox(
                width: 80,
                height: 32,
                borderRadius: BorderRadius.circular(16),
                isLoading: isLoading,
              ),
              const Spacer(),
              SkeletonBox(
                width: 60,
                height: 24,
                borderRadius: BorderRadius.circular(12),
                isLoading: isLoading,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Loading states for different UI patterns
class LoadingState extends StatelessWidget {
  const LoadingState({
    super.key,
    this.message = 'Loading...',
    this.showProgress = true,
    this.icon,
  });

  final String message;
  final bool showProgress;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: context.colorScheme.primaryContainer.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                size: 40,
                color: context.colorScheme.primary,
              ),
            ),
            AppSpacing.spacing_4.heightBox,
          ],
          if (showProgress) ...[
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: context.colorScheme.primary,
              ),
            ),
            AppSpacing.spacing_3.heightBox,
          ],
          Text(
            message,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class PulsingDot extends StatefulWidget {
  const PulsingDot({
    super.key,
    this.color,
    this.size = 8,
    this.duration = const Duration(milliseconds: 1000),
  });

  final Color? color;
  final double size;
  final Duration duration;

  @override
  State<PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<PulsingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color ?? context.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({
    super.key,
    this.dotColor,
    this.dotSize = 6,
    this.spacing = 4,
  });

  final Color? dotColor;
  final double dotSize;
  final double spacing;

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Stagger the animations
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.only(
                right: index < 2 ? widget.spacing : 0,
              ),
              child: Opacity(
                opacity: _animations[index].value,
                child: Container(
                  width: widget.dotSize,
                  height: widget.dotSize,
                  decoration: BoxDecoration(
                    color: widget.dotColor ?? context.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
