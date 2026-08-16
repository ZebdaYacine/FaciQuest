part of 'analyse_results_page.dart';

class _AdvancedAnalyticsModal extends StatelessWidget {
  const _AdvancedAnalyticsModal({required this.survey});

  final SurveyEntity survey;

  @override
  Widget build(BuildContext context) {
    return AppBackDrop(
      headerActions: BackdropHeaderActions.none,
      title: Text(
        'analysis.advanced_analytics'.tr(),
        style: context.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('analysis.advanced_analytics_coming_soon'.tr()),
                    const SizedBox(height: 20),
                    Text('analysis.detailed_statistical_analysis_description'
                        .tr()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: FilledButton.icon(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.close_rounded),
        label: Text('analysis.close'.tr()),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
        ),
      ),
    );
  }
}

class _AllQuestionAnalyticsModal extends StatelessWidget {
  const _AllQuestionAnalyticsModal({required this.survey});

  final SurveyEntity survey;

  @override
  Widget build(BuildContext context) {
    return AppBackDrop(
      headerActions: BackdropHeaderActions.none,
      title: Text(
        'analysis.all_question_analytics'.tr(),
        style: context.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        '${survey.questions.length} questions • ${survey.submissions.length} total responses',
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
      body: survey.questions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.quiz_outlined,
                    size: 64,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  16.heightBox,
                  Text(
                    'analysis.no_questions_in_survey'.tr(),
                    style: context.textTheme.titleLarge?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  8.heightBox,
                  Text(
                    'analysis.add_questions_detailed_analytics'.tr(),
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: survey.questions.map((question) {
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
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    question.type.icon,
                                    color: context.colorScheme.primary,
                                  ),
                                  12.widthBox,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          question.title,
                                          style: context.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        4.heightBox,
                                        Row(
                                          children: [
                                            Text(
                                              question.type.name,
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                color:
                                                    context.colorScheme.primary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            8.widthBox,
                                            Text(
                                              '•',
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                color: context.colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                            ),
                                            8.widthBox,
                                            Text(
                                              '${completionRate.toStringAsFixed(1)}% completion',
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                color: context.colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          context.colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${distribution.totalResponses}',
                                      style: context.textTheme.labelSmall
                                          ?.copyWith(
                                        color: context.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              20.heightBox,
                              ResponseDistributionChart(
                                  distribution: distribution),
                            ],
                          ),
                        ),
                      ),
                      if (survey.questions.indexOf(question) <
                          survey.questions.length - 1)
                        20.heightBox,
                    ],
                  );
                }).toList(),
              ),
            ),
      actions: FilledButton.icon(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.close_rounded),
        label: Text('analysis.close'.tr()),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
        ),
      ),
    );
  }
}
