part of 'analyse_results_page.dart';

extension _AnalysisExport on _AnalyseResultsPageState {
  void _handleExport(String format, SurveyEntity survey) async {
    try {
      switch (format) {
        case 'csv':
          await _exportToCSV(survey);
          break;
        case 'pdf':
          await _exportToPDF(survey);
          break;
        case 'excel':
          await _exportToExcel(survey);
          break;
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'error.export_data_success'.tr(args: [format.toUpperCase()])),
          backgroundColor: Colors.green,
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
    // TODO: Save and share the CSV file
    debugPrint('CSV export prepared: ${csvString.length} characters');
  }

  Future<void> _exportToPDF(SurveyEntity survey) async {
    // Implement PDF export
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('error.pdf_export_coming_soon'.tr()),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _exportToExcel(SurveyEntity survey) async {
    // Implement Excel export
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('error.excel_export_coming_soon'.tr()),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAdvancedAnalytics(SurveyEntity survey) {
    // Show advanced analytics modal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(maxHeight: context.height * 0.9),
      builder: (context) => _AdvancedAnalyticsModal(survey: survey),
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
