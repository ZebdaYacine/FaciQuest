part of 'manage_my_surveys_view.dart';

extension _ManageSurveyFilters on _ManageMySurveysViewState {
  Widget _buildSearchAndFilters(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: context.colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: AppSpacing.spacing_2.horizontalPadding,
            child: Row(
              children: [
                Expanded(child: _buildEnhancedSearchField(context)),
                AppSpacing.spacing_2.widthBox,
                _buildViewStyleToggle(context),
              ],
            ),
          ),
          AppSpacing.spacing_2.heightBox,
          _buildFilterChips(context),
          AppSpacing.spacing_2.heightBox,
        ],
      ),
    );
  }

  Widget _buildEnhancedSearchField(BuildContext context) {
    return BlocBuilder<ManageMySurveysCubit, ManageMySurveysState>(
      builder: (context, state) {
        return EnhancedTextField(
          controller: _searchController,
          onChanged: _cubit.onSearchChanged,
          hintText: 'manage.search_surveys_hint'.tr(),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: context.colorScheme.primary,
          ),
          suffixIcon: state.searchQuery?.isNotEmpty == true
              ? BouncyButton(
                  onTap: () {
                    _searchController.clear();
                    _cubit.clearSearch();
                  },
                  child: Icon(
                    Icons.clear_rounded,
                    color: context.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                )
              : null,
          borderRadius: BorderRadius.circular(16),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        );
      },
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return BlocBuilder<ManageMySurveysCubit, ManageMySurveysState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: AppSpacing.spacing_2,
            children: FilterOption.values.map((filter) {
              final isSelected = state.selectedFilter == filter;
              return BouncyButton(
                onTap: () => _cubit.updateFilter(filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.colorScheme.primaryContainer
                        : context.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? context.colorScheme.primary
                          : context.colorScheme.outline.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        filter.icon,
                        size: 16,
                        color: isSelected
                            ? context.colorScheme.primary
                            : context.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        filter.name.tr(),
                        style: context.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? context.colorScheme.primary
                              : context.colorScheme.onSurfaceVariant,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: context.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BlocProvider.value(
        value: _cubit,
        child: const SortOptionsBottomSheet(),
      ),
    );
  }

  Widget _buildViewStyleToggle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.colorScheme.outline.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ViewStyle.values.map((style) {
          final isSelected = style == _viewStyle;
          return InkWell(
            onTap: () => _handleViewStyleChange({style}),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isSelected ? context.colorScheme.primaryContainer : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                style.icon,
                color: isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
