part of 'analyse_results_page.dart';

extension _AnalysisHeaderAndFilters on _AnalyseResultsPageState {
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
        color:
            context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
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
}
