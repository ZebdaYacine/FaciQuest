part of 'home_view.dart';

class _EmptyState extends StatefulWidget {
  const _EmptyState();

  @override
  State<_EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<_EmptyState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Padding(
              padding: AppSpacing.spacing_4.padding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            context.colorScheme.primary.withValues(alpha: 0.1),
                            context.colorScheme.primaryContainer
                                .withValues(alpha: 0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(
                          color: context.colorScheme.primary
                              .withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.explore_off_rounded,
                        size: 48,
                        color:
                            context.colorScheme.primary.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                  AppSpacing.spacing_4.heightBox,
                  SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        Text(
                          'home.empty_state.no_surveys'.tr(),
                          style: context.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.onSurface,
                            letterSpacing: -0.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.spacing_2.heightBox,
                        Text(
                          'home.empty_state.description'.tr(),
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.spacing_4.heightBox,
                        OutlinedButton.icon(
                          onPressed: () {
                            AppRoutes.newSurvey.push(
                              context,
                              pathParameters: {'id': '-1'},
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(Icons.add_circle_outline_rounded),
                          label: Text(
                            'home.empty_state.create_first_survey'.tr(),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FailureState extends StatefulWidget {
  const _FailureState();

  @override
  State<_FailureState> createState() => _FailureStateState();
}

class _FailureStateState extends State<_FailureState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _bounceAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.bounceOut),
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Center(
            child: Padding(
              padding: AppSpacing.spacing_4.padding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _bounceAnimation,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            context.colorScheme.error.withValues(alpha: 0.1),
                            context.colorScheme.errorContainer
                                .withValues(alpha: 0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(
                          color:
                              context.colorScheme.error.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.cloud_off_rounded,
                        size: 48,
                        color: context.colorScheme.error.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  AppSpacing.spacing_4.heightBox,
                  Text(
                    'home.error_state.error_message'.tr(),
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurface,
                      letterSpacing: -0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.spacing_2.heightBox,
                  Text(
                    'home.error_state.error_description'.tr(),
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.spacing_4.heightBox,
                  FilledButton.icon(
                    onPressed: () {
                      context.read<HomeCubit>().fetchSurveys();
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(
                      'home.error_state.try_again'.tr(),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
