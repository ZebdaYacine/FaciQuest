part of 'manage_my_surveys_view.dart';

class GridSurveys extends StatelessWidget {
  const GridSurveys({
    super.key,
    required this.surveys,
  });

  final List<SurveyEntity> surveys;

  @override
  Widget build(BuildContext context) {
    if (surveys.isEmpty) {
      return _buildEmptyState(context);
    }

    return GridView.builder(
      padding: AppSpacing.spacing_2.padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getGridCrossAxisCount(context),
        childAspectRatio: 0.7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: surveys.length,
      itemBuilder: (context, index) => _buildGridItem(context, surveys[index]),
    );
  }

  int _getGridCrossAxisCount(BuildContext context) {
    if (context.isPhone) return 2;
    if (context.isTablet) return 3;
    return 4;
  }

  Widget _buildGridItem(BuildContext context, SurveyEntity survey) {
    return InkWell(
      onTap: () => _handleSurveyTap(context, survey),
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: AppSpacing.spacing_2.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, survey),
              AppSpacing.spacing_1.heightBox,
              _buildTitle(context, survey),
              AppSpacing.spacing_1.heightBox,
              _buildDate(context, survey),
              const Spacer(),
              _buildResponseCount(context, survey),
              AppSpacing.spacing_1.heightBox,
              _buildAnalyzeButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, SurveyEntity survey) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SurveyBadge(status: survey.status),
        SurveyActions(surveyId: survey.id),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, SurveyEntity survey) {
    return Text(
      survey.name,
      style: context.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: context.colorScheme.onSurface,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDate(BuildContext context, SurveyEntity survey) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today_rounded,
          color: context.colorScheme.primary,
          size: 16,
        ),
        AppSpacing.spacing_1.widthBox,
        Text(
          survey.updatedAt.toString().substring(0, 10),
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildResponseCount(BuildContext context, SurveyEntity survey) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bar_chart_rounded,
            color: context.colorScheme.primary,
            size: 20,
          ),
          AppSpacing.spacing_1.widthBox,
          Text(
            '${survey.responseCount} ${survey.responseCount == 1 ? 'survey_details.response_count_singular'.tr() : 'survey_details.response_count_plural'.tr()}',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyzeButton(BuildContext context) {
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {},
      icon: const Icon(Icons.analytics_rounded),
      label: Text('actions.analyze_results'.tr()),
    );
  }

  Future<void> _handleSurveyTap(
      BuildContext context, SurveyEntity survey) async {
    await context.pushNamed(
      AppRoutes.newSurvey.name,
      extra: SurveyAction.edit,
      pathParameters: {'id': survey.id},
    );
    if (context.mounted) {
      context.read<ManageMySurveysCubit>().fetchSurveys();
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: context.colorScheme.primary,
          ),
          AppSpacing.spacing_2.heightBox,
          Text(
            'manage.no_surveys_found'.tr(),
            style: context.textTheme.titleLarge?.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class SurveyBadge extends StatelessWidget {
  const SurveyBadge({
    super.key,
    required this.status,
    this.large = false,
  });
  final SurveyStatus status;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 12 : 8,
        vertical: large ? 6 : 4,
      ),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: large ? 8 : 6,
            height: large ? 8 : 6,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: large ? 8 : 4),
          Text(
            'status.open_status'.tr(),
            style: (large
                    ? context.textTheme.titleMedium
                    : context.textTheme.bodyMedium)
                ?.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
