part of 'survey_view.dart';

class _SubmitSection extends StatefulWidget {
  const _SubmitSection({required this.cubit});

  final SurveyCubit cubit;

  @override
  State<_SubmitSection> createState() => _SubmitSectionState();
}

class _SubmitSectionState extends State<_SubmitSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurveyCubit, SurveyState>(
      buildWhen: (previous, current) =>
          previous.submissionStatus != current.submissionStatus,
      builder: (context, state) {
        return AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: state.submissionStatus.isLoading
                  ? 1.0
                  : _pulseAnimation.value,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: context.colorScheme.primaryContainer
                          .withValues(alpha: 0.15),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                      spreadRadius: -4,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            context.colorScheme.primaryContainer
                                .withValues(alpha: 0.6),
                            context.colorScheme.tertiaryContainer
                                .withValues(alpha: 0.4),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: context.colorScheme.primary
                              .withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Background pattern
                          Positioned(
                            top: -40,
                            right: -40,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    context.colorScheme.primary
                                        .withValues(alpha: 0.15),
                                    context.colorScheme.primary
                                        .withValues(alpha: 0.0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Content
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                _buildHeader(context),
                                const SizedBox(height: 20),
                                _buildDescription(context),
                                const SizedBox(height: 32),
                                _buildSubmitButton(context, state),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.colorScheme.primary,
                context.colorScheme.primary.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.rocket_launch_rounded,
            color: context.colorScheme.onPrimary,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'survey.submit.ready.title'.tr(),
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'survey.submit.ready.message'.tr(),
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_rounded,
                color: context.colorScheme.primary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Your responses are secure',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, SurveyState state) {
    return BouncyButton(
      onTap: state.submissionStatus.isLoading
          ? null
          : () {
              HapticFeedback.mediumImpact();
              widget.cubit.submit();
            },
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: state.submissionStatus.isLoading
              ? null
              : LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    context.colorScheme.primary,
                    context.colorScheme.primary.withValues(alpha: 0.8),
                  ],
                ),
          color: state.submissionStatus.isLoading
              ? context.colorScheme.onSurface.withValues(alpha: 0.12)
              : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: state.submissionStatus.isLoading
              ? null
              : [
                  BoxShadow(
                    color: context.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (state.submissionStatus.isLoading) ...[
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(
                    context.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ] else ...[
              Icon(
                Icons.send_rounded,
                color: context.colorScheme.onPrimary,
                size: 20,
              ),
              const SizedBox(width: 12),
            ],
            Text(
              state.submissionStatus.isLoading
                  ? 'survey.submit.button.loading'.tr()
                  : 'survey.submit.button.default'.tr(),
              style: context.textTheme.titleMedium?.copyWith(
                color: state.submissionStatus.isLoading
                    ? context.colorScheme.onSurface.withValues(alpha: 0.6)
                    : context.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
