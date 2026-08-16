part of 'analyse_results_page.dart';

extension _AnalysisExport on _AnalyseResultsPageState {
  void _handleExport(String format, SurveyEntity survey) async {
    try {
      if (format != 'csv') return;
      await _exportToCSV(survey);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('analysis.csv_ready'.tr()),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('error.export_data_error'.tr(args: [e.toString()])),
          backgroundColor: context.colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _exportToCSV(SurveyEntity survey) async {
    // Implement CSV export
    final List<List<String>> csvData = [
      ['Survey ID', 'Collector ID', ...survey.questions.map((q) => q.title)],
      ...survey.submissions.map((submission) => [
            submission.surveyId,
            submission.collectorId,
            ...submission.answers
                .map((answer) => answer.plutoCell.value.toString()),
          ]),
    ];

    final csvString = const ListToCsvConverter().convert(csvData);
    await SharePlus.instance.share(
      ShareParams(
        text: csvString,
        subject: '${survey.name} - ${'analysis.responses'.tr()}',
      ),
    );
  }

  void _showAllQuestionAnalytics(SurveyEntity survey) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxHeight: context.height * 0.9),
      builder: (context) => _AllQuestionAnalyticsModal(survey: survey),
    );
  }

  // Build method implementations for tabs
}
