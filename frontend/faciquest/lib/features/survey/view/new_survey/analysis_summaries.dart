part of 'analyse_results_page.dart';

extension _AnalysisSummaries on _AnalyseResultsPageState {
  Widget _buildOverviewTab(SurveyEntity survey) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRecentResponses(survey),
          16.heightBox,
          _buildCollectorPerformance(survey),
        ],
      ),
    );
  }

  Widget _buildResponsesTab(SurveyEntity survey) {
    return _ResultsTable(survey: survey);
  }

  Widget _buildAnalyticsTab(SurveyEntity survey) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionAnalytics(survey),
        ],
      ),
    );
  }
}
