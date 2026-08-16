part of 'analyse_results_page.dart';

extension _AnalysisCharts on _AnalyseResultsPageState {
  Widget _buildCollectorPerformance(SurveyEntity survey) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'analysis.collector_performance'.tr(),
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            16.heightBox,
            if (survey.collectors.isEmpty)
              Center(child: Text('error.no_collectors_yet'.tr()))
            else
              ...survey.collectors.map(
                (collector) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: context.colorScheme.primaryContainer,
                    child: Icon(
                      collector.type.icon,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  title: Text(
                    collector.name.isEmpty
                        ? 'survey.collectors.unnamed'.tr()
                        : collector.name,
                  ),
                  subtitle: Text(
                    'analysis.collector_response_count'.plural(
                      collector.responsesCount,
                      args: ['${collector.responsesCount}'],
                    ),
                  ),
                  trailing: Text(
                    'analysis.view_count'.plural(
                      collector.viewsCount,
                      args: ['${collector.viewsCount}'],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentResponses(SurveyEntity survey) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'analysis.recent_responses'.tr(),
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            16.heightBox,
            if (survey.submissions.isEmpty)
              Center(child: Text('analysis.no_responses'.tr()))
            else
              ...survey.submissions.take(3).toList().asMap().entries.map(
                    (entry) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: context.colorScheme.primaryContainer,
                        child: Text('${entry.key + 1}'),
                      ),
                      title: Text(
                        'analysis.response_number'.tr(
                          args: ['${entry.key + 1}'],
                        ),
                      ),
                      subtitle: Text(
                        'analysis.collector_value'.tr(
                          args: [entry.value.collectorId],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionAnalytics(SurveyEntity survey) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'analysis.question_analytics'.tr(),
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (survey.questions.isNotEmpty)
                  TextButton(
                    onPressed: () => _showAllQuestionAnalytics(survey),
                    child: Text('analysis.view_all'.tr()),
                  ),
              ],
            ),
            16.heightBox,
            if (survey.questions.isNotEmpty && survey.submissions.isNotEmpty)
              ...survey.questions.take(2).map((question) {
                final distribution =
                    ResponseDistributionAnalyzer.analyzeQuestion(
                  question,
                  survey.submissions,
                );
                final completionRate = survey.submissions.isNotEmpty
                    ? (distribution.totalResponses /
                        survey.submissions.length *
                        100)
                    : 0.0;

                return Column(
                  children: [
                    ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      leading: Icon(
                        question.type.icon,
                        color: context.colorScheme.primary,
                      ),
                      title: Text(
                        question.title,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'analysis.question_completion'.tr(args: [
                          completionRate.toStringAsFixed(1),
                          '${distribution.totalResponses}',
                        ]),
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: ResponseDistributionChart(
                              distribution: distribution),
                        ),
                      ],
                    ),
                    if (survey.questions.indexOf(question) <
                        survey.questions.take(2).length - 1)
                      const Divider(),
                  ],
                );
              })
            else if (survey.questions.isEmpty)
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.quiz_outlined,
                        size: 32,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                      8.heightBox,
                      Text(
                        'analysis.no_questions_in_survey'.tr(),
                        style: context.textTheme.titleSmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      4.heightBox,
                      Text(
                        'analysis.add_questions_to_see_distributions'.tr(),
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.hourglass_empty_rounded,
                        size: 32,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                      8.heightBox,
                      Text(
                        'analysis.waiting_for_responses'.tr(),
                        style: context.textTheme.titleSmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      4.heightBox,
                      Text(
                        'analysis.question_analytics_appear_when_responses_collected'
                            .tr(),
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
