part of 'manage_my_surveys_view.dart';

class ListSurveys extends StatelessWidget {
  const ListSurveys({super.key, required this.surveys});
  final List<SurveyEntity> surveys;

  @override
  Widget build(BuildContext context) {
    if (surveys.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.separated(
      padding: AppSpacing.spacing_2.padding,
      itemCount: surveys.length,
      separatorBuilder: (_, __) => AppSpacing.spacing_2.heightBox,
      itemBuilder: (context, index) => _buildListItem(context, surveys[index]),
    );
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

  Widget _buildListItem(BuildContext context, SurveyEntity survey) {
    return Container(
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
      child: ListTile(
        contentPadding: AppSpacing.spacing_2.padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        trailing: SurveyActions(surveyId: survey.id),
        leading: SurveyBadge(
          status: survey.status,
          large: true,
        ),
        onTap: () => _handleSurveyTap(context, survey),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              survey.name,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            AppSpacing.spacing_1.heightBox,
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: context.colorScheme.primary,
                  size: 16,
                ),
                AppSpacing.spacing_1.widthBox,
                Text(
                  '${'survey_details.updated_label'.tr()}${survey.updatedAt.toString().substring(0, 10)}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                _buildResponseCount(context, survey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponseCount(BuildContext context, SurveyEntity survey) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
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
}

// Sort Options Bottom Sheet
