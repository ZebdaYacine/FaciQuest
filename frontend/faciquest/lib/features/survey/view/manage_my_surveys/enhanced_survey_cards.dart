part of 'manage_my_surveys_view.dart';

class EnhancedSurveyCard extends StatelessWidget {
  const EnhancedSurveyCard({super.key, required this.survey});

  final SurveyEntity survey;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${survey.name}, ${survey.status.labelKey.tr()}',
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        color: context.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: context.colorScheme.outlineVariant),
        ),
        child: InkWell(
          onTap: () => _openSurvey(context, SurveyAction.edit),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _SurveyStatusChip(status: survey.status),
                    const Spacer(),
                    SurveyActions(surveyId: survey.id),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  survey.name,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'manage.survey_with_questions'.tr(args: [
                    '${survey.questions.length}',
                    survey.questions.length == 1
                        ? 'manage.question'.tr()
                        : 'manage.questions'.tr(),
                  ]),
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: _SurveyMetric(
                        icon: Icons.forum_outlined,
                        value: '${survey.responseCount}',
                        label: 'manage.responses_label'.tr(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _SurveyMetric(
                        icon: Icons.schedule_rounded,
                        value: DateFormat.MMMd(
                          Localizations.localeOf(context).toString(),
                        ).format(survey.updatedAt ?? survey.createdAt),
                        label: 'manage.updated_label'.tr(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: () =>
                            _openSurvey(context, SurveyAction.analyze),
                        icon: const Icon(Icons.analytics_outlined),
                        label: Text('actions.analyze_results'.tr()),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.outlined(
                      onPressed: () =>
                          _openSurvey(context, SurveyAction.preview),
                      icon: const Icon(Icons.visibility_outlined),
                      tooltip: 'actions.preview_survey'.tr(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openSurvey(BuildContext context, SurveyAction action) async {
    HapticFeedback.selectionClick();
    await context.pushNamed(
      AppRoutes.newSurvey.name,
      extra: action,
      pathParameters: {'id': survey.id},
    );
    if (context.mounted) {
      context.read<ManageMySurveysCubit>().fetchSurveys();
    }
  }
}

class EnhancedSurveyListItem extends StatelessWidget {
  const EnhancedSurveyListItem({super.key, required this.survey});

  final SurveyEntity survey;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${survey.name}, ${survey.status.labelKey.tr()}',
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        color: context.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: context.colorScheme.outlineVariant),
        ),
        child: InkWell(
          onTap: () => _openSurvey(context, SurveyAction.edit),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.description_outlined,
                    color: context.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              survey.name,
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SurveyActions(surveyId: survey.id),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _SurveyStatusChip(status: survey.status),
                          _CompactMetric(
                            icon: Icons.forum_outlined,
                            label: 'manage.response_count'.plural(
                              survey.responseCount,
                              args: ['${survey.responseCount}'],
                            ),
                          ),
                          _CompactMetric(
                            icon: Icons.quiz_outlined,
                            label: 'manage.question_count'.plural(
                              survey.questions.length,
                              args: ['${survey.questions.length}'],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'manage.last_updated'.tr(args: [
                          DateFormat.yMMMd(
                            Localizations.localeOf(context).toString(),
                          ).format(survey.updatedAt ?? survey.createdAt),
                        ]),
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openSurvey(BuildContext context, SurveyAction action) async {
    HapticFeedback.selectionClick();
    await context.pushNamed(
      AppRoutes.newSurvey.name,
      extra: action,
      pathParameters: {'id': survey.id},
    );
    if (context.mounted) {
      context.read<ManageMySurveysCubit>().fetchSurveys();
    }
  }
}

class _SurveyStatusChip extends StatelessWidget {
  const _SurveyStatusChip({required this.status});

  final SurveyStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: status.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status.labelKey.tr(),
            style: context.textTheme.labelMedium?.copyWith(
              color: status.color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SurveyMetric extends StatelessWidget {
  const _SurveyMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: context.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactMetric extends StatelessWidget {
  const _CompactMetric({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: context.colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

extension on SurveyStatus {
  String get labelKey {
    switch (this) {
      case SurveyStatus.active:
        return 'status.active';
      case SurveyStatus.draft:
        return 'status.draft';
      case SurveyStatus.published:
        return 'status.published';
      case SurveyStatus.deleted:
        return 'status.closed';
    }
  }
}
