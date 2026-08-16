part of 'manage_my_surveys_view.dart';

extension _ManageSurveyToolbar on _ManageMySurveysViewState {
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: BlocBuilder<ManageMySurveysCubit, ManageMySurveysState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'manage.manage_my_surveys_title'.tr(),
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.onSurface,
                ),
              ),
              if (state.surveys.isNotEmpty)
                Text(
                  '${state.filteredSurveys.length} ${state.filteredSurveys.length == 1 ? 'survey '.tr() : 'surveys'.tr()}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          );
        },
      ),
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: context.colorScheme.surface,
      surfaceTintColor: context.colorScheme.surfaceTint,
      actions: [
        BlocBuilder<ManageMySurveysCubit, ManageMySurveysState>(
          builder: (context, state) {
            return IconButton(
              onPressed: () => _showSortOptions(context),
              icon: Icon(
                Icons.sort_rounded,
                color: context.colorScheme.onSurfaceVariant,
              ),
              tooltip: 'Sort options'.tr(),
            );
          },
        ),
      ],
    );
  }
}
