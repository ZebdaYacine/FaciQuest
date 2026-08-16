part of 'analyse_results_page.dart';

extension _AnalysisCharts on _AnalyseResultsPageState {
  Widget _buildResponseOverview(SurveyEntity survey) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'analysis.response_distribution_overview'.tr(),
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            16.heightBox,
            if (survey.questions.isNotEmpty && survey.submissions.isNotEmpty)
              ...survey.questions.take(3).map((question) {
                final distribution =
                    ResponseDistributionAnalyzer.analyzeQuestion(
                  question,
                  survey.submissions,
                );
                return Column(
                  children: [
                    ResponseDistributionChart(distribution: distribution),
                    24.heightBox,
                  ],
                );
              })
            else
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.colorScheme.outlineVariant,
                    style: BorderStyle.solid,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bar_chart_outlined,
                        size: 48,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                      16.heightBox,
                      Text(
                        survey.questions.isEmpty
                            ? 'analysis.no_questions_in_survey'.tr()
                            : 'analysis.no_responses'.tr(),
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      8.heightBox,
                      Text(
                        survey.questions.isEmpty
                            ? 'analysis.add_questions_to_see_distributions'.tr()
                            : 'analysis.distributions_appear_when_responses_collected'
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

  Widget _buildCollectorPerformance(SurveyEntity survey) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'analysis.collector_performance'.tr(),
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            16.heightBox,
            if (survey.collectors.isEmpty)
              Center(child: Text('error.no_collectors_yet'.tr()))
            else
              ...survey.collectors.map(
                (collector) => ListTile(
                  leading: Icon(collector.type.icon),
                  title: Text(collector.name),
                  subtitle: Text('${collector.responsesCount} responses'),
                  trailing: Text('${collector.viewsCount} views'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentResponses(SurveyEntity survey) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'analysis.recent_responses'.tr(),
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            16.heightBox,
            if (survey.submissions.isEmpty)
              Center(child: Text('analysis.no_responses'.tr()))
            else
              ...survey.submissions.take(3).map(
                    (response) => ListTile(
                      title: Text(
                          '${'analysis.response'.tr()} ${response.surveyId}'),
                      subtitle: Text(
                          '${'analysis.collector'.tr()} ${response.collectorId}'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponseTrends() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'analysis.response_trends'.tr(),
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            16.heightBox,
            SizedBox(
              height: 200,
              child:
                  Center(child: Text('analysis.trends_chart_placeholder'.tr())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionAnalytics(SurveyEntity survey) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'analysis.question_analytics'.tr(),
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (survey.questions.isNotEmpty)
                  FilledButton.tonalIcon(
                    onPressed: () => _showAllQuestionAnalytics(survey),
                    icon: const Icon(Icons.analytics_outlined),
                    label: Text('analysis.view_all'.tr()),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
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
                        '${completionRate.toStringAsFixed(1)}% completion rate • ${distribution.totalResponses} responses',
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

  Widget _buildDeviceBreakdown() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'analysis.device_breakdown'.tr(),
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            16.heightBox,
            ListTile(
              leading: const Icon(Icons.smartphone),
              title: Text('analysis.mobile'.tr()),
              trailing: const Text('65%'),
            ),
            ListTile(
              leading: const Icon(Icons.computer),
              title: Text('analysis.desktop'.tr()),
              trailing: const Text('25%'),
            ),
            ListTile(
              leading: const Icon(Icons.tablet),
              title: Text('analysis.tablet'.tr()),
              trailing: const Text('10%'),
            ),
          ],
        ),
      ),
    );
  }
}
