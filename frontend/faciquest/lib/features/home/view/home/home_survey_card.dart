part of 'home_view.dart';

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
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
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
                  color: colorScheme.onSurface,
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
    final participantsLabel =
        '${100 + (widget.index * 23)} ${'home.survey_card.participants'.tr()}';
    final title =
        widget.surveyEntity?.name ?? 'home.survey_card.fallback_title'.tr();
    final description = widget.surveyEntity?.description ??
        'home.survey_card.fallback_description'.tr();
    final price =
        widget.surveyEntity?.price?.toStringAsFixed(2).replaceAll('.', ',') ??
            'home.survey_card.fallback_price'.tr();

    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        scale: _isHovered ? 1.02 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          margin: AppSpacing.spacing_2.bottomPadding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: cardColor.withValues(alpha: _isHovered ? 0.12 : 0.04),
                blurRadius: _isHovered ? 32 : 16,
                offset: Offset(0, _isHovered ? 12 : 6),
                spreadRadius: _isHovered ? 0 : -4,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? colorScheme.surface.withValues(alpha: 0.4)
                      : Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                            .withValues(alpha: _isHovered ? 0.15 : 0.08)
                        : cardColor.withValues(alpha: _isHovered ? 0.3 : 0.1),
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -40,
                      right: -40,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _isHovered ? 180 : 140,
                        height: _isHovered ? 180 : 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              cardColor.withValues(alpha: 0.15),
                              cardColor.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      left: -30,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _isHovered ? 140 : 100,
                        height: _isHovered ? 140 : 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              cardColor.withValues(alpha: 0.1),
                              cardColor.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (widget.surveyEntity != null) {
                            AppRoutes.survey.push(
                              context,
                              pathParameters: {'id': widget.surveyEntity!.id},
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(24),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: cardColor.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      Icons.quiz_rounded,
                                      color: cardColor,
                                      size: 26,
                                    ),
                                  ),
                                  AppSpacing.spacing_3.widthBox,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: colorScheme.onSurface,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        AppSpacing.spacing_1_5.heightBox,
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            _buildInfoPill(
                                              icon: Icons.access_time_rounded,
                                              label:
                                                  'home.survey_card.duration_text'
                                                      .tr(),
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
                                  height: 1.5,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 20),
                              Divider(
                                color:
                                    colorScheme.outline.withValues(alpha: 0.1),
                                height: 1,
                                thickness: 1,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          colorScheme.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.monetization_on_rounded,
                                          color: colorScheme.onSurfaceVariant,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          price,
                                          style: textTheme.titleSmall?.copyWith(
                                            color: colorScheme.onSurface,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.green.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: const BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          'home.survey_card.status_active'.tr(),
                                          style:
                                              textTheme.labelMedium?.copyWith(
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.green.shade300
                                                    : Colors.green.shade700,
                                            fontWeight: FontWeight.w600,
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
        ),
      ),
    );
  }
}
