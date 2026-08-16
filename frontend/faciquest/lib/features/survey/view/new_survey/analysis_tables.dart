part of 'analyse_results_page.dart';

class _ResultsTable extends StatelessWidget {
  const _ResultsTable({required this.survey});

  final SurveyEntity survey;

  @override
  Widget build(BuildContext context) {
    if (survey.submissions.isEmpty) {
      return Center(
        child: Padding(
          padding: AppSpacing.spacing_4.padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 48,
                color: context.colorScheme.primary,
              ),
              12.heightBox,
              Text(
                'analysis.no_responses'.tr(),
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              4.heightBox,
              Text(
                'analysis.distributions_appear_when_responses_collected'.tr(),
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: survey.submissions.length + 1,
      separatorBuilder: (_, __) => 12.heightBox,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'analysis.responses'.tr(),
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '${survey.submissions.length}',
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        }

        final submission = survey.submissions[index - 1];
        return _ResponseCard(
          index: index,
          submission: submission,
          survey: survey,
        );
      },
    );
  }
}

class _ResponseCard extends StatelessWidget {
  const _ResponseCard({
    required this.index,
    required this.submission,
    required this.survey,
  });

  final int index;
  final SubmissionEntity submission;
  final SurveyEntity survey;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: CircleAvatar(
          backgroundColor: context.colorScheme.primaryContainer,
          foregroundColor: context.colorScheme.onPrimaryContainer,
          child: Text('$index'),
        ),
        title: Text(
          'analysis.response_number'.tr(args: ['$index']),
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          'analysis.collector_value'.tr(
            args: [
              submission.collectorId.isEmpty
                  ? 'analysis.unknown_collector'.tr()
                  : submission.collectorId,
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        children: [
          Divider(color: context.colorScheme.outlineVariant),
          if (submission.answers.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'analysis.no_answers_recorded'.tr(),
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            ...submission.answers.map(
              (answer) => Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        _questionTitle(answer.questionId),
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    12.widthBox,
                    Expanded(
                      flex: 5,
                      child: Text(
                        _answerText(answer),
                        textAlign: TextAlign.end,
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _questionTitle(String questionId) {
    for (final question in survey.questions) {
      if (question.id == questionId) return question.title;
    }
    return 'analysis.unknown_question'.tr();
  }

  String _answerText(AnswerEntity answer) {
    final value = answer.plutoCell.value;
    if (value == null || value.toString().trim().isEmpty) {
      return 'analysis.no_answer'.tr();
    }
    if (value is Iterable) return value.join(', ');
    return value.toString();
  }
}
