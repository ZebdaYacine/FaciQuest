part of 'manage_my_surveys_view.dart';

extension _ManageSurveyContent on _ManageMySurveysViewState {
  Widget _buildSurveyList() {
    return BlocBuilder<ManageMySurveysCubit, ManageMySurveysState>(
      builder: (context, state) {
        if (state.status.isFailure) {
          return Expanded(
            child: EnhancedErrorWidget(
              message: state.msg ?? 'error.generic'.tr(),
              onRetry: () => _cubit.fetchSurveys(),
            ),
          );
        }

        if (state.status.isLoading) {
          return Expanded(
            child: _buildLoadingSkeleton(context),
          );
        }

        final surveys = state.filteredSurveys;

        if (surveys.isEmpty) {
          return Expanded(
            child: _buildEnhancedEmptyState(context, state),
          );
        }

        return Expanded(
          child: AnimatedSwitcher(
            duration: context.prefersReducedMotion
                ? Duration.zero
                : const Duration(milliseconds: 200),
            child: _viewStyle == ViewStyle.grid
                ? EnhancedGridSurveys(
                    key: const ValueKey('grid'),
                    surveys: surveys,
                  )
                : EnhancedListSurveys(
                    key: const ValueKey('list'),
                    surveys: surveys,
                  ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingSkeleton(BuildContext context) {
    return _viewStyle == ViewStyle.grid
        ? GridView.builder(
            padding: AppSpacing.spacing_3.padding,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getGridCrossAxisCount(context),
              childAspectRatio: 0.85,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
            ),
            itemCount: 6,
            itemBuilder: (context, index) => const SkeletonCard(),
          )
        : ListView.separated(
            padding: AppSpacing.spacing_3.padding,
            itemCount: 5,
            separatorBuilder: (_, __) => AppSpacing.spacing_3.heightBox,
            itemBuilder: (context, index) => const SkeletonCard(),
          );
  }

  Widget _buildEnhancedEmptyState(
      BuildContext context, ManageMySurveysState state) {
    final hasSearch = state.searchQuery?.isNotEmpty == true;
    final hasFilters = state.selectedFilter != FilterOption.all;

    return Center(
      child: Padding(
        padding: AppSpacing.spacing_4.padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color:
                    context.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                hasSearch || hasFilters
                    ? Icons.search_off_rounded
                    : Icons.quiz_outlined,
                size: 64,
                color: context.colorScheme.primary,
              ),
            ),
            AppSpacing.spacing_4.heightBox,
            Text(
              hasSearch || hasFilters
                  ? 'manage.no_surveys_match_criteria'.tr()
                  : 'manage.no_surveys_yet'.tr(),
              style: context.textTheme.headlineSmall?.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.spacing_2.heightBox,
            Text(
              hasSearch || hasFilters
                  ? 'manage.try_adjusting_search_filters'.tr()
                  : 'manage.create_first_survey_to_start'.tr(),
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.spacing_4.heightBox,
            if (hasSearch || hasFilters) ...[
              PrimaryButton(
                onPressed: () {
                  _searchController.clear();
                  _cubit.clearSearch();
                  _cubit.updateFilter(FilterOption.all);
                },
                size: ButtonSize.medium,
                fullWidth: false,
                child: Text('manage.clear_filters'.tr()),
              ),
            ] else ...[
              PrimaryButton(
                onPressed: () => _handleCreateSurvey(context),
                size: ButtonSize.large,
                fullWidth: false,
                icon: const Icon(Icons.add_rounded),
                child: Text('manage.create_survey_button'.tr()),
              ),
            ],
          ],
        ),
      ),
    );
  }

  int _getGridCrossAxisCount(BuildContext context) {
    if (context.isPhone) return 2;
    if (context.isTablet) return 3;
    return 4;
  }
}
