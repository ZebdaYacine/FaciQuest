import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trina_grid/trina_grid.dart';

import 'package:csv/csv.dart';

class AnalyseResultsPage extends StatefulWidget {
  const AnalyseResultsPage({super.key});

  @override
  State<AnalyseResultsPage> createState() => _AnalyseResultsPageState();
}

class _AnalyseResultsPageState extends State<AnalyseResultsPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewSurveyCubit, NewSurveyState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildHeader(context, state.survey),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(state.survey),
                  _buildResponsesTab(state.survey),
                  _buildAnalyticsTab(state.survey),
                ],
              ),
            ),
            _buildBottomActions(state.survey),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, SurveyEntity survey) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_rounded,
                color: context.colorScheme.primary,
                size: 28,
              ),
              12.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'analysis.survey_analysis'.tr(),
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${'analysis.detailed_insights'.tr()} "${survey.name}"',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              _buildExportButton(survey),
            ],
          ),
          16.heightBox,
          // _buildQuickStats(survey),
        ],
      ),
    );
  }

  Widget _buildExportButton(SurveyEntity survey) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: context.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.file_download_outlined,
          color: context.colorScheme.primary,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'csv',
          child: Row(
            children: [
              Icon(Icons.table_chart_outlined, color: Colors.green),
              12.widthBox,
              Text('actions.export_as_csv'.tr()),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'pdf',
          child: Row(
            children: [
              Icon(Icons.picture_as_pdf_outlined, color: Colors.red),
              12.widthBox,
              Text('actions.export_as_pdf'.tr()),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'excel',
          child: Row(
            children: [
              Icon(Icons.grid_on_outlined, color: Colors.blue),
              12.widthBox,
              Text('actions.export_as_excel'.tr()),
            ],
          ),
        ),
      ],
      onSelected: (value) => _handleExport(value, survey),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: context.colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        labelColor: context.colorScheme.onPrimary,
        unselectedLabelColor: context.colorScheme.onSurfaceVariant,
        tabs: [
          Tab(text: 'analysis.overview'.tr()),
          Tab(text: 'analysis.responses'.tr()),
          Tab(text: 'analysis.analytics'.tr()),
        ],
      ),
    );
  }

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
                onPressed: survey.submissions.isNotEmpty ? () => _showAdvancedAnalytics(survey) : null,
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('error.export_data_success'.tr(args: [format.toUpperCase()])),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
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
            ...submission.answers.map((answer) => answer.plutoCell.value.toString()),
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
      constraints: BoxConstraints(maxHeight: context.height * 0.9),
      builder: (context) => _AdvancedAnalyticsModal(survey: survey),
    );
  }

  void _showAllQuestionAnalytics(SurveyEntity survey) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: context.height * 0.9),
      builder: (context) => _AllQuestionAnalyticsModal(survey: survey),
    );
  }

  // Build method implementations for tabs
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
                final distribution = ResponseDistributionAnalyzer.analyzeQuestion(
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
                  color: context.colorScheme.surfaceContainerHighest.withOpacity(0.3),
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
                            : 'analysis.distributions_appear_when_responses_collected'.tr(),
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
                      title: Text('${'analysis.response'.tr()} ${response.surveyId}'),
                      subtitle: Text('${'analysis.collector'.tr()} ${response.collectorId}'),
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
              child: Center(child: Text('analysis.trends_chart_placeholder'.tr())),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
              ],
            ),
            16.heightBox,
            if (survey.questions.isNotEmpty && survey.submissions.isNotEmpty)
              ...survey.questions.take(2).map((question) {
                final distribution = ResponseDistributionAnalyzer.analyzeQuestion(
                  question,
                  survey.submissions,
                );
                final completionRate = survey.submissions.isNotEmpty
                    ? (distribution.totalResponses / survey.submissions.length * 100)
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
                          child: ResponseDistributionChart(distribution: distribution),
                        ),
                      ],
                    ),
                    if (survey.questions.indexOf(question) < survey.questions.take(2).length - 1) const Divider(),
                  ],
                );
              })
            else if (survey.questions.isEmpty)
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHighest.withOpacity(0.3),
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
                  color: context.colorScheme.surfaceContainerHighest.withOpacity(0.3),
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
                        'analysis.question_analytics_appear_when_responses_collected'.tr(),
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
                    Text('analysis.detailed_statistical_analysis_description'.tr()),
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
                  final distribution = ResponseDistributionAnalyzer.analyzeQuestion(
                    question,
                    survey.submissions,
                  );
                  final completionRate = survey.submissions.isNotEmpty
                      ? (distribution.totalResponses / survey.submissions.length * 100)
                      : 0.0;

                  return Column(
                    children: [
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          question.title,
                                          style: context.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        4.heightBox,
                                        Row(
                                          children: [
                                            Text(
                                              question.type.name,
                                              style: context.textTheme.bodySmall?.copyWith(
                                                color: context.colorScheme.primary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            8.widthBox,
                                            Text(
                                              '•',
                                              style: context.textTheme.bodySmall?.copyWith(
                                                color: context.colorScheme.onSurfaceVariant,
                                              ),
                                            ),
                                            8.widthBox,
                                            Text(
                                              '${completionRate.toStringAsFixed(1)}% completion',
                                              style: context.textTheme.bodySmall?.copyWith(
                                                color: context.colorScheme.onSurfaceVariant,
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
                                      color: context.colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${distribution.totalResponses}',
                                      style: context.textTheme.labelSmall?.copyWith(
                                        color: context.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              20.heightBox,
                              ResponseDistributionChart(distribution: distribution),
                            ],
                          ),
                        ),
                      ),
                      if (survey.questions.indexOf(question) < survey.questions.length - 1) 20.heightBox,
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

class _ResultsTable extends StatelessWidget {
  const _ResultsTable();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.spacing_2.horizontalPadding,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: AppSpacing.spacing_2.padding,
              child: Text(
                'analysis.survey_results'.tr(),
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            const Expanded(child: _AnswersGrid()),
          ],
        ),
      ),
    );
  }
}

class _AnswersGrid extends StatefulWidget {
  const _AnswersGrid();

  @override
  State<_AnswersGrid> createState() => _AnswersGridState();
}

class _AnswersGridState extends State<_AnswersGrid> {
  TrinaGridStateManager? stateManager;
  late final survey = context.read<NewSurveyCubit>().state.survey;

  Future<TrinaLazyPaginationResponse> fetch(
    TrinaLazyPaginationRequest request,
  ) async {
    try {
      final cubit = context.read<NewSurveyCubit>();
      final result = await cubit.fetchSubmissionPage(
        page: request.page,
        pageSize: 10,
      );

      final paginatedRows = result
          .map(
            (submission) => TrinaRow(
              cells: {
                for (final answer in submission.answers) answer.questionId: answer.plutoCell,
              },
            ),
          )
          .toList();

      return TrinaLazyPaginationResponse(
        rows: paginatedRows,
        totalPage: result.length + 1,
      );
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return TrinaLazyPaginationResponse(
        rows: [],
        totalPage: 1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (survey.questions.isEmpty) {
      return Center(
        child: Text(
          'analysis.no_questions'.tr(),
          style: context.textTheme.titleMedium,
        ),
      );
    }

    // if (survey.submissions.isEmpty) {
    //   return Center(
    //     child: Text(
    //       'analysis.no_responses'.tr(),
    //       style: context.textTheme.titleMedium,
    //     ),
    //   );
    // }

    return TrinaGrid(
      key: const ValueKey('TrinaGrid'),
      columns: buildColumns(),
      configuration: buildConfiguration(context),
      rows: buildRows(),
      createFooter: (stateManager) {
        return TrinaLazyPagination(
          initialPage: 1,
          initialFetch: true,
          fetchWithSorting: true,
          fetchWithFiltering: true,
          pageSizeToMove: null,
          fetch: fetch,
          stateManager: stateManager,
        );
      },
      onLoaded: (event) {
        stateManager = event.stateManager;
      },
    );
  }

  List<TrinaColumn> buildColumns() {
    return survey.questions.map((question) {
      return TrinaColumn(
        title: question.title,
        field: question.id,
        type: TrinaColumnType.text(),
        titleTextAlign: TrinaColumnTextAlign.center,
        textAlign: TrinaColumnTextAlign.center,
        backgroundColor: context.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        titleSpan: TextSpan(
          text: question.title,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        frozen: TrinaColumnFrozen.none,
        width: 200,
        minWidth: 150,
        enableContextMenu: false,
        enableDropToResize: true,
        enableAutoEditing: false,
        enableEditingMode: false,
      );
    }).toList();
  }

  TrinaGridConfiguration buildConfiguration(BuildContext context) {
    return TrinaGridConfiguration(
      style: TrinaGridStyleConfig(
        borderColor: context.colorScheme.outlineVariant,
        gridBackgroundColor: context.colorScheme.surface,
        rowColor: context.colorScheme.surface,
        columnTextStyle: context.textTheme.bodyMedium!,
        cellTextStyle: context.textTheme.bodyMedium!,
        iconColor: context.colorScheme.primary,
        activatedColor: context.colorScheme.primaryContainer,
      ),
      scrollbar: const TrinaGridScrollbarConfig(
        isAlwaysShown: true,
      ),
      columnSize: const TrinaGridColumnSizeConfig(
        autoSizeMode: TrinaAutoSizeMode.scale,
      ),
    );
  }

  List<TrinaRow> buildRows() {
    return survey.submissions
        .map(
          (submission) => TrinaRow(
            cells: {
              for (final answer in submission.answers) answer.questionId: answer.plutoCell,
            },
          ),
        )
        .toList();
  }
}
