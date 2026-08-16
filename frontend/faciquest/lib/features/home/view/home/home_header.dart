part of 'home_view.dart';

class HomeHeaderSliver extends StatelessWidget {
  const HomeHeaderSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 340,
      floating: false,
      pinned: true,
      snap: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.colorScheme.primary.withValues(alpha: 0.1),
                context.colorScheme.primaryContainer.withValues(alpha: 0.15),
                Colors.transparent,
              ],
            ),
          ),
          child: SafeArea(
            child: AdaptiveContentWidth(
              child: Padding(
                padding: AppSpacing.spacing_3.padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppSpacing.spacing_4.heightBox,
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TweenAnimationBuilder<double>(
                                duration: context.prefersReducedMotion
                                    ? Duration.zero
                                    : const Duration(milliseconds: 800),
                                tween: Tween(begin: 0.0, end: 1.0),
                                builder: (context, value, child) {
                                  return Transform.translate(
                                    offset: Offset(0, 20 * (1 - value)),
                                    child: Opacity(
                                      opacity: value,
                                      child: Text(
                                        'home.welcome_title'.tr(),
                                        style: context.textTheme.headlineLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: context.colorScheme.primary,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              AppSpacing.spacing_1.heightBox,
                              TweenAnimationBuilder<double>(
                                duration: context.prefersReducedMotion
                                    ? Duration.zero
                                    : const Duration(milliseconds: 1000),
                                tween: Tween(begin: 0.0, end: 1.0),
                                builder: (context, value, child) {
                                  return Transform.translate(
                                    offset: Offset(0, 20 * (1 - value)),
                                    child: Opacity(
                                      opacity: value,
                                      child: Text(
                                        'home.welcome_subtitle'.tr(),
                                        style: context.textTheme.bodyLarge
                                            ?.copyWith(
                                          color: context
                                              .colorScheme.onSurfaceVariant,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        TweenAnimationBuilder<double>(
                          duration: context.prefersReducedMotion
                              ? Duration.zero
                              : const Duration(milliseconds: 600),
                          tween: Tween(begin: 0.0, end: 1.0),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: InkWell(
                                onTap: () {
                                  AppRoutes.profile.push(context);
                                },
                                borderRadius: BorderRadius.circular(24),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: context.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: context.colorScheme.shadow
                                            .withValues(alpha: 0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor:
                                        context.colorScheme.primaryContainer,
                                    child: Text(
                                      'YG',
                                      style: TextStyle(
                                        color: context
                                            .colorScheme.onPrimaryContainer,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    AppSpacing.spacing_3.heightBox,
                    TweenAnimationBuilder<double>(
                      duration: context.prefersReducedMotion
                          ? Duration.zero
                          : const Duration(milliseconds: 1200),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: Opacity(
                            opacity: value,
                            child: FilledButton.icon(
                              onPressed: () {
                                AppRoutes.manageMySurveys.push(context);
                              },
                              style: FilledButton.styleFrom(
                                minimumSize: const Size(200, 56),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 2,
                                shadowColor: context.colorScheme.primary
                                    .withValues(alpha: 0.3),
                              ),
                              icon: const Icon(
                                  Icons.dashboard_customize_rounded,
                                  size: 20),
                              label: Text(
                                'home.manage_surveys'.tr(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
