part of 'collect_responses_page.dart';

class SurveyStatsCard extends StatelessWidget {
  const SurveyStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewSurveyCubit, NewSurveyState>(
      builder: (context, state) {
        final survey = state.survey;
        final totalResponses = survey.submissions.length;
        final totalCollectors = survey.collectors.length;
        final activeCollectors = survey.collectors
            .where((c) => c.status == CollectorStatus.open)
            .length;

        return Container(
          margin: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.analytics_outlined,
                        color: context.colorScheme.primary,
                        size: 28,
                      ),
                      12.widthBox,
                      Text(
                        'survey.stats.performance'.tr(),
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  20.heightBox,
                  Row(
                    children: [
                      Expanded(
                        child: _StatItem(
                          icon: Icons.people_outline,
                          label: 'survey.stats.total_responses'.tr(),
                          value: totalResponses.toString(),
                          color: context.colorScheme.primary,
                        ),
                      ),
                      Expanded(
                        child: _StatItem(
                          icon: Icons.campaign_outlined,
                          label: 'survey.stats.active_collectors'.tr(),
                          value: '$activeCollectors/$totalCollectors',
                          color: context.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  if (totalCollectors > 0) ...[
                    16.heightBox,
                    LinearProgressIndicator(
                      value: totalCollectors > 0
                          ? activeCollectors / totalCollectors
                          : 0,
                      backgroundColor:
                          context.colorScheme.surfaceContainerHighest,
                      valueColor:
                          AlwaysStoppedAnimation(context.colorScheme.primary),
                    ),
                    8.heightBox,
                    Text(
                      'survey.stats.collector_activity_rate'.tr(),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        8.heightBox,
        Text(
          value,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        4.heightBox,
        Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// Collector Options Section
