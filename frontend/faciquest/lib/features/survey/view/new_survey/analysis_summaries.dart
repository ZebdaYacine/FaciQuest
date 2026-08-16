part of 'analyse_results_page.dart';

extension _AnalysisSummaries on _AnalyseResultsPageState {
  Widget _buildOverviewTab(SurveyEntity survey) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResponseOverview(survey),
          20.heightBox,
          _buildCollectorPerformance(survey),
          20.heightBox,
          _buildRecentResponses(survey),
        ],
      ),
    );
  }

  Widget _buildResponsesTab(SurveyEntity survey) {
    return Column(
      children: [
        AppSpacing.spacing_2.heightBox,
        const Expanded(child: _ResultsTable()),
      ],
    );
  }

  Widget _buildAnalyticsTab(SurveyEntity survey) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResponseTrends(),
          20.heightBox,
          _buildQuestionAnalytics(survey),
          20.heightBox,
          _buildDeviceBreakdown(),
        ],
      ),
    );
  }

  Widget _buildBottomActions(SurveyEntity survey) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: context.colorScheme.outlineVariant,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            OutlinedButton.icon(
              onPressed: () {
                context.read<NewSurveyCubit>().back();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: context.colorScheme.error,
                side: BorderSide(color: context.colorScheme.error),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              icon: Icon(
                Icons.arrow_back_rounded,
                color: context.colorScheme.error,
              ),
              label: Text('actions.back'.tr()),
            ),
            16.widthBox,
            Expanded(
              child: FilledButton.icon(
                onPressed: survey.submissions.isNotEmpty
                    ? () => _showAdvancedAnalytics(survey)
                    : null,
                icon: const Icon(Icons.insights_rounded),
                label: Text('actions.advanced_analytics'.tr()),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
