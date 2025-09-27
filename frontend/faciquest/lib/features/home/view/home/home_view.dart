import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(getIt<SurveyRepository>()),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.colorScheme.surface,
                context.colorScheme.surfaceContainerLowest,
                context.colorScheme.surface.withOpacity(0.98),
              ],
            ),
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<HomeCubit>().fetchSurveys();
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverAppBar(
                  expandedHeight: 320,
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
                            context.colorScheme.primary.withOpacity(0.1),
                            context.colorScheme.primaryContainer.withOpacity(0.15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: SafeArea(
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
                                          duration: const Duration(milliseconds: 800),
                                          tween: Tween(begin: 0.0, end: 1.0),
                                          builder: (context, value, child) {
                                            return Transform.translate(
                                              offset: Offset(0, 20 * (1 - value)),
                                              child: Opacity(
                                                opacity: value,
                                                child: Text(
                                                  'home.welcome_title'.tr(),
                                                  style: context.textTheme.headlineLarge?.copyWith(
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
                                          duration: const Duration(milliseconds: 1000),
                                          tween: Tween(begin: 0.0, end: 1.0),
                                          builder: (context, value, child) {
                                            return Transform.translate(
                                              offset: Offset(0, 20 * (1 - value)),
                                              child: Opacity(
                                                opacity: value,
                                                child: Text(
                                                  'home.welcome_subtitle'.tr(),
                                                  style: context.textTheme.bodyLarge?.copyWith(
                                                    color: context.colorScheme.onSurfaceVariant,
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
                                    duration: const Duration(milliseconds: 600),
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
                                                  color: context.colorScheme.shadow.withOpacity(0.1),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: CircleAvatar(
                                              radius: 24,
                                              backgroundColor: context.colorScheme.primaryContainer,
                                              child: Text(
                                                'YG',
                                                style: TextStyle(
                                                  color: context.colorScheme.onPrimaryContainer,
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
                                duration: const Duration(milliseconds: 1200),
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
                                          shadowColor: context.colorScheme.primary.withOpacity(0.3),
                                        ),
                                        icon: const Icon(Icons.dashboard_customize_rounded, size: 20),
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
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: AppSpacing.spacing_3,
                      right: AppSpacing.spacing_3,
                      top: AppSpacing.spacing_2,
                      bottom: AppSpacing.spacing_1,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.explore_rounded,
                          color: context.colorScheme.primary,
                          size: 24,
                        ),
                        AppSpacing.spacing_2.widthBox,
                        Text(
                          'home.available_surveys'.tr(),
                          style: context.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.onSurface,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state.status.isFailure) {
                      return const SliverFillRemaining(
                        child: _FailureState(),
                      );
                    }
                    if (state.status.isSuccess && state.surveys.isEmpty) {
                      return const SliverFillRemaining(
                        child: _EmptyState(),
                      );
                    }
                    return SliverPadding(
                      padding: EdgeInsets.all(AppSpacing.spacing_3),
                      sliver: SliverList.builder(
                        itemCount: state.surveys.isEmpty ? 10 : state.surveys.length,
                        itemBuilder: (context, index) {
                          SurveyEntity? surveyEntity;
                          if (state.surveys.isEmpty) {
                            surveyEntity = null;
                          } else {
                            surveyEntity = state.surveys[index];
                          }

                          if (state.status.isLoading) {
                            return SlideInAnimation(
                              delay: Duration(milliseconds: index * 100),
                              direction: SlideDirection.bottom,
                              child: SkeletonCard(
                                padding: AppSpacing.spacing_4.padding,
                                isLoading: true,
                              ),
                            );
                          } else {
                            return SlideInAnimation(
                              delay: Duration(milliseconds: index * 100),
                              direction: SlideDirection.bottom,
                              child: BouncyButton(
                                onTap: () {
                                  AppRoutes.survey.push(
                                    context,
                                    pathParameters: {
                                      'id': surveyEntity?.id ?? '-1',
                                    },
                                  );
                                },
                                child: _SurveyCard(
                                  surveyEntity: surveyEntity,
                                  index: index,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 32),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 800),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Opacity(
                opacity: value,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    AppRoutes.newSurvey.push(
                      context,
                      pathParameters: {
                        'id': '-1',
                      },
                    );
                  },
                  backgroundColor: context.colorScheme.primaryContainer,
                  foregroundColor: context.colorScheme.onPrimaryContainer,
                  elevation: 6,
                  extendedPadding: const EdgeInsets.symmetric(horizontal: 20),
                  icon: const Icon(Icons.add_circle_outline_rounded),
                  label: Text(
                    'home.new_survey'.tr(),
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
      ),
    );
  }
}

class _EmptyState extends StatefulWidget {
  const _EmptyState();

  @override
  State<_EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<_EmptyState> with SingleTickerProviderStateMixin {
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
                            context.colorScheme.primary.withOpacity(0.1),
                            context.colorScheme.primaryContainer.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(
                          color: context.colorScheme.primary.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.explore_off_rounded,
                        size: 48,
                        color: context.colorScheme.primary.withOpacity(0.7),
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

class _FailureStateState extends State<_FailureState> with SingleTickerProviderStateMixin {
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
                            context.colorScheme.error.withOpacity(0.1),
                            context.colorScheme.errorContainer.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(
                          color: context.colorScheme.error.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.cloud_off_rounded,
                        size: 48,
                        color: context.colorScheme.error.withOpacity(0.8),
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

class _SurveyCard extends StatefulWidget {
  const _SurveyCard({
    this.surveyEntity,
    required this.index,
  });

  final SurveyEntity? surveyEntity;
  final int index;

  @override
  State<_SurveyCard> createState() => _SurveyCardState();
}

class _SurveyCardState extends State<_SurveyCard> {
  bool _isHovered = false;

  void _setHover(bool value) {
    if (_isHovered == value) {
      return;
    }
    setState(() {
      _isHovered = value;
    });
  }

  Widget _buildInfoPill({
    required IconData icon,
    required String label,
    required ColorScheme colorScheme,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.92),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.18),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 8),
            spreadRadius: -6,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: accentColor,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      context.colorScheme.primary,
      context.colorScheme.secondary,
      context.colorScheme.tertiary,
      context.colorScheme.primaryContainer,
    ];
    final cardColor = colors[widget.index % colors.length];
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final participantsLabel = '${100 + (widget.index * 23)} ${'home.survey_card.participants'.tr()}';
    final title = widget.surveyEntity?.name ?? 'home.survey_card.fallback_title'.tr();
    final description = widget.surveyEntity?.description ?? 'home.survey_card.fallback_description'.tr();
    final price =
        widget.surveyEntity?.price?.toStringAsFixed(2).replaceAll('.', ',') ?? 'home.survey_card.fallback_price'.tr();

    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        scale: _isHovered ? 1.01 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          margin: AppSpacing.spacing_2.bottomPadding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surface,
                cardColor.withOpacity(_isHovered ? 0.16 : 0.1),
                cardColor.withOpacity(_isHovered ? 0.06 : 0.03),
              ],
              stops: const [0.0, 0.55, 1.0],
            ),
            border: Border.all(
              color: cardColor.withOpacity(_isHovered ? 0.24 : 0.16),
              width: 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: cardColor.withOpacity(_isHovered ? 0.24 : 0.14),
                blurRadius: _isHovered ? 28 : 20,
                offset: const Offset(0, 18),
                spreadRadius: -12,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                Positioned(
                  top: -32,
                  right: -32,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 320),
                    width: _isHovered ? 160 : 120,
                    height: _isHovered ? 160 : 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          cardColor.withOpacity(_isHovered ? 0.26 : 0.18),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -28,
                  left: -28,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 320),
                    width: _isHovered ? 120 : 90,
                    height: _isHovered ? 120 : 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          cardColor.withOpacity(_isHovered ? 0.2 : 0.12),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(_isHovered ? 0.08 : 0.04),
                          Colors.white.withOpacity(0.0),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: AppSpacing.spacing_2.padding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      cardColor,
                                      cardColor.withOpacity(0.85),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.14),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: cardColor.withOpacity(0.35),
                                      blurRadius: 18,
                                      offset: const Offset(0, 10),
                                      spreadRadius: -8,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.quiz_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              AppSpacing.spacing_3.widthBox,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: colorScheme.onSurface,
                                        letterSpacing: -0.3,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    AppSpacing.spacing_2.heightBox,
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        _buildInfoPill(
                                          icon: Icons.access_time_rounded,
                                          label: 'home.survey_card.duration_text'.tr(),
                                          colorScheme: colorScheme,
                                          accentColor: cardColor,
                                        ),
                                        _buildInfoPill(
                                          icon: Icons.group_rounded,
                                          label: participantsLabel,
                                          colorScheme: colorScheme,
                                          accentColor: cardColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.spacing_3.heightBox,
                          Text(
                            description,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              height: 1.55,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.transparent,
                                  colorScheme.outline.withOpacity(0.18),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 11,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      cardColor.withOpacity(0.95),
                                      cardColor.withOpacity(0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.16),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: cardColor.withOpacity(0.35),
                                      blurRadius: 18,
                                      offset: const Offset(0, 12),
                                      spreadRadius: -10,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.monetization_on_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      price,
                                      style: textTheme.titleSmall?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.secondaryContainer.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: colorScheme.onSecondaryContainer.withOpacity(0.12),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorScheme.secondaryContainer.withOpacity(0.28),
                                      blurRadius: 12,
                                      offset: const Offset(0, 10),
                                      spreadRadius: -8,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(4),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.green.withOpacity(0.4),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'home.survey_card.status_active'.tr(),
                                      style: textTheme.labelMedium?.copyWith(
                                        color: colorScheme.onSecondaryContainer,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
