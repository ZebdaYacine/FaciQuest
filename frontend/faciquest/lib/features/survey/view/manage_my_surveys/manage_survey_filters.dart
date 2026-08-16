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
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    _cubit.clearSearch();
                  },
                  tooltip: 'manage.clear_search'.tr(),
                  icon: Icon(
                    Icons.clear_rounded,
                    color: context.colorScheme.onSurfaceVariant,
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
          padding: AppSpacing.spacing_2.horizontalPadding,
          child: Row(
            spacing: AppSpacing.spacing_1,
            children: FilterOption.values.map((filter) {
              final isSelected = state.selectedFilter == filter;
              return FilterChip(
                selected: isSelected,
                onSelected: (_) => _cubit.updateFilter(filter),
                avatar: Icon(filter.icon, size: 18),
                label: Text(filter.labelKey.tr()),
                showCheckmark: false,
                visualDensity: VisualDensity.standard,
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
    return SegmentedButton<ViewStyle>(
      segments: ViewStyle.values
          .map(
            (style) => ButtonSegment(
              value: style,
              icon: Icon(style.icon),
              tooltip: style == ViewStyle.grid
                  ? 'manage.grid_view'.tr()
                  : 'manage.list_view'.tr(),
            ),
          )
          .toList(),
      selected: {_viewStyle},
      showSelectedIcon: false,
      onSelectionChanged: _handleViewStyleChange,
    );
  }
}
