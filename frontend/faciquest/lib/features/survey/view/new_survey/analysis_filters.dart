part of 'analyse_results_page.dart';

extension _AnalysisHeaderAndFilters on _AnalyseResultsPageState {
  Widget _buildHeader(BuildContext context, SurveyEntity survey) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      survey.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'analysis.results_subtitle'.tr(),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              _buildExportButton(survey),
            ],
          ),
          12.heightBox,
          _buildQuickStats(survey),
        ],
      ),
    );
  }

  Widget _buildExportButton(SurveyEntity survey) {
    return IconButton.filledTonal(
      tooltip: 'actions.export_results'.tr(),
      onPressed: survey.submissions.isEmpty
          ? null
          : () => _handleExport('csv', survey),
      icon: const Icon(Icons.ios_share_rounded),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: context.colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        labelColor: context.colorScheme.onPrimary,
        unselectedLabelColor: context.colorScheme.onSurfaceVariant,
        tabs: [
          _AnalysisTabLabel(label: 'analysis.overview'.tr()),
          _AnalysisTabLabel(label: 'analysis.responses'.tr()),
          _AnalysisTabLabel(label: 'analysis.analytics'.tr()),
        ],
      ),
    );
  }

  Widget _buildQuickStats(SurveyEntity survey) {
    final responses = survey.responseCount > survey.submissions.length
        ? survey.responseCount
        : survey.submissions.length;
    final items = [
      (Icons.forum_outlined, '$responses', 'analysis.responses'.tr()),
      (
        Icons.quiz_outlined,
        '${survey.questions.length}',
        'summary.questions'.tr()
      ),
      (
        Icons.campaign_outlined,
        '${survey.collectors.length}',
        'summary.collectors'.tr()
      ),
      (Icons.visibility_outlined, '${survey.viewCount}', 'summary.views'.tr()),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 8,
          children: items.map((item) {
            return SizedBox(
              width: itemWidth,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.$1,
                        size: 20,
                        color: context.colorScheme.primary,
                      ),
                      10.widthBox,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.$2,
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              item.$3,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.labelSmall?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _AnalysisTabLabel extends StatelessWidget {
  const _AnalysisTabLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(label),
        ),
      ),
    );
  }
}
