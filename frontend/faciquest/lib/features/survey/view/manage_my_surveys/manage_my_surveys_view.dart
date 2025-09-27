import 'package:awesome_extensions/awesome_extensions.dart' hide NavigatorExt;
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ManageMySurveysView extends StatefulWidget {
  const ManageMySurveysView({super.key});

  @override
  State<ManageMySurveysView> createState() => _ManageMySurveysViewState();
}

class _ManageMySurveysViewState extends State<ManageMySurveysView> with TickerProviderStateMixin {
  final _cubit = ManageMySurveysCubit(getIt<SurveyRepository>());
  var _viewStyle = ViewStyle.grid;
  final _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _cubit.fetchSurveys();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateSurvey(BuildContext context) async {
    HapticFeedback.lightImpact();
    await context.pushNamed(
      AppRoutes.newSurvey.name,
      pathParameters: {'id': '-1'},
    );
    _cubit.fetchSurveys();
  }

  void _handleViewStyleChange(Set<ViewStyle> styles) {
    if (styles.isNotEmpty) {
      setState(() => _viewStyle = styles.first);
      HapticFeedback.selectionClick();
    }
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();
    await _cubit.refreshSurveys();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: Scaffold(
        backgroundColor: context.colorScheme.surfaceContainerLowest,
        appBar: _buildAppBar(context),
        floatingActionButton: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 800),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Opacity(
                opacity: value,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    AppRoutes.newSurvey.push(
                      context,
                      pathParameters: {
                        'id': '-1',
                      },
                    );
                  },
                  backgroundColor: context.colorScheme.primaryContainer,
                  foregroundColor: context.colorScheme.onPrimaryContainer,
                  elevation: 6,
                  extendedPadding: const EdgeInsets.symmetric(horizontal: 20),
                  icon: const Icon(Icons.add_circle_outline_rounded),
                  label: Text(
                    'home.new_survey'.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            color: context.colorScheme.primary,
            backgroundColor: context.colorScheme.surfaceContainerHighest,
            child: Column(
              children: [
                _buildSearchAndFilters(context),
                _buildSurveyList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

  Widget _buildSearchAndFilters(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: context.colorScheme.outline.withOpacity(0.1),
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
                    color:
                        isSelected ? context.colorScheme.primaryContainer : context.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? context.colorScheme.primary : context.colorScheme.outline.withOpacity(0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        filter.icon,
                        size: 16,
                        color: isSelected ? context.colorScheme.primary : context.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        filter.name.tr(),
                        style: context.textTheme.bodySmall?.copyWith(
                          color: isSelected ? context.colorScheme.primary : context.colorScheme.onSurfaceVariant,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
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

  void _showTemplateSelector(BuildContext context) {
    // TODO: Implement template selector
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('manage.template_selector_coming_soon'.tr()),
        backgroundColor: context.colorScheme.secondaryContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
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
          color: context.colorScheme.outline.withOpacity(0.5),
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
                color: isSelected ? context.colorScheme.primary : context.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSurveyList() {
    return BlocBuilder<ManageMySurveysCubit, ManageMySurveysState>(
      builder: (context, state) {
        if (state.status.isFailure) {
          return Expanded(
            child: EnhancedErrorWidget(
              message: state.msg ?? 'An error occurred',
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
            duration: const Duration(milliseconds: 300),
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

  Widget _buildEnhancedEmptyState(BuildContext context, ManageMySurveysState state) {
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
                color: context.colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                hasSearch || hasFilters ? Icons.search_off_rounded : Icons.quiz_outlined,
                size: 64,
                color: context.colorScheme.primary,
              ),
            ),
            AppSpacing.spacing_4.heightBox,
            Text(
              hasSearch || hasFilters ? 'manage.no_surveys_match_criteria'.tr() : 'manage.no_surveys_yet'.tr(),
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

enum ViewStyle {
  grid,
  list;

  IconData get icon {
    switch (this) {
      case ViewStyle.grid:
        return Icons.grid_view_rounded;
      case ViewStyle.list:
        return Icons.view_list_rounded;
    }
  }
}

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
              color: context.colorScheme.shadow.withOpacity(0.1),
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

  Future<void> _handleSurveyTap(BuildContext context, SurveyEntity survey) async {
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
        color: Colors.green.withOpacity(0.2),
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
            style: (large ? context.textTheme.titleMedium : context.textTheme.bodyMedium)?.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class SurveyActions extends StatelessWidget {
  const SurveyActions({
    super.key,
    required this.surveyId,
  });
  final String surveyId;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert_rounded,
        color: context.colorScheme.onSurfaceVariant,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      itemBuilder: _buildMenuItems,
      onSelected: (value) => _handleActionSelected(context, value),
    );
  }

  List<PopupMenuItem> _buildMenuItems(BuildContext context) {
    return [
      _buildMenuItem(
        context,
        SurveyAction.edit,
        Icons.edit_rounded,
        'actions.edit_survey'.tr(),
      ),
      _buildMenuItem(
        context,
        SurveyAction.preview,
        Icons.visibility_rounded,
        'actions.preview_survey'.tr(),
      ),
      _buildMenuItem(
        context,
        SurveyAction.analyze,
        Icons.analytics_rounded,
        'actions.analyze_results'.tr(),
      ),
      _buildMenuItem(
        context,
        SurveyAction.delete,
        Icons.delete_rounded,
        'actions.delete'.tr(),
        isDestructive: true,
      ),
    ];
  }

  PopupMenuItem _buildMenuItem(
    BuildContext context,
    SurveyAction action,
    IconData icon,
    String text, {
    bool isDestructive = false,
  }) {
    final color = isDestructive ? context.colorScheme.error : context.colorScheme.primary;

    return PopupMenuItem(
      value: action,
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          AppSpacing.spacing_2.widthBox,
          Text(
            text,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }

  Future<void> _handleActionSelected(
    BuildContext context,
    SurveyAction action,
  ) async {
    if (action == SurveyAction.delete) {
      await _showDeleteConfirmation(context);
    } else {
      await _handleNonDeleteAction(context, action);
    }

    if (context.mounted) {
      context.read<ManageMySurveysCubit>().fetchSurveys();
    }
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_rounded,
              color: context.colorScheme.error,
            ),
            AppSpacing.spacing_2.widthBox,
            Text('delete_dialog.delete_survey_title'.tr()),
          ],
        ),
        content: Text(
          'delete_dialog.delete_survey_confirmation'.tr(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'actions.cancel'.tr(),
              style: TextStyle(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: context.colorScheme.error,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<ManageMySurveysCubit>().deleteSurvey(surveyId);
            },
            child: Text('actions.delete_button'.tr()),
          ),
        ],
      ),
    );
  }

  Future<void> _handleNonDeleteAction(
    BuildContext context,
    SurveyAction action,
  ) async {
    await context.pushNamed(
      AppRoutes.newSurvey.name,
      extra: action,
      pathParameters: {'id': surveyId},
    );
  }
}

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
            color: context.colorScheme.shadow.withOpacity(0.1),
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

  Future<void> _handleSurveyTap(BuildContext context, SurveyEntity survey) async {
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
class SortOptionsBottomSheet extends StatelessWidget {
  const SortOptionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageMySurveysCubit, ManageMySurveysState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'manage.sort_by'.tr(),
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  BouncyButton(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close_rounded,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              AppSpacing.spacing_3.heightBox,
              ...SortOption.values.map((option) {
                final isSelected = state.sortOption == option;
                return BouncyButton(
                  onTap: () {
                    context.read<ManageMySurveysCubit>().updateSortOption(option);
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.colorScheme.primaryContainer
                          : context.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? context.colorScheme.primary : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          option.icon,
                          color: isSelected ? context.colorScheme.primary : context.colorScheme.onSurfaceVariant,
                        ),
                        AppSpacing.spacing_3.widthBox,
                        Expanded(
                          child: Text(
                            option.name.tr(),
                            style: context.textTheme.titleMedium?.copyWith(
                              color: isSelected ? context.colorScheme.primary : context.colorScheme.onSurface,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            state.isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                            color: context.colorScheme.primary,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

// Enhanced Grid View with Animations
class EnhancedGridSurveys extends StatelessWidget {
  const EnhancedGridSurveys({
    super.key,
    required this.surveys,
  });

  final List<SurveyEntity> surveys;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: AppSpacing.spacing_3.padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getGridCrossAxisCount(context),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: surveys.length,
      itemBuilder: (context, index) {
        return SlideInAnimation(
          delay: Duration(milliseconds: index * 50),
          direction: SlideDirection.bottom,
          child: EnhancedSurveyCard(survey: surveys[index]),
        );
      },
    );
  }

  int _getGridCrossAxisCount(BuildContext context) {
    if (context.isPhone) return 1;
    if (context.isTablet) return 3;
    return 4;
  }
}

// Enhanced List View with Animations
class EnhancedListSurveys extends StatelessWidget {
  const EnhancedListSurveys({
    super.key,
    required this.surveys,
  });

  final List<SurveyEntity> surveys;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: AppSpacing.spacing_3.padding,
      itemCount: surveys.length,
      separatorBuilder: (_, __) => AppSpacing.spacing_3.heightBox,
      itemBuilder: (context, index) {
        return SlideInAnimation(
          delay: Duration(milliseconds: index * 50),
          direction: SlideDirection.left,
          child: EnhancedSurveyListItem(survey: surveys[index]),
        );
      },
    );
  }
}

// Enhanced Survey Card
class EnhancedSurveyCard extends StatelessWidget {
  const EnhancedSurveyCard({
    super.key,
    required this.survey,
  });

  final SurveyEntity survey;

  @override
  Widget build(BuildContext context) {
    return BouncyButton(
      onTap: () => _handleSurveyTap(context, survey),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.colorScheme.surface,
              context.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.shadow.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: context.colorScheme.primary.withOpacity(0.02),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: context.colorScheme.outline.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Background pattern
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: survey.status.color.withOpacity(0.05),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 16),
                    _buildTitle(context),
                    const SizedBox(height: 12),
                    _buildDescription(context),
                    const Spacer(),
                    _buildMetricsAndDate(context),
                    const SizedBox(height: 16),
                    _buildActionButtons(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: survey.status.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: survey.status.color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: survey.status.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                _getStatusText(),
                style: context.textTheme.bodySmall?.copyWith(
                  color: survey.status.color,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        SurveyActions(surveyId: survey.id),
      ],
    );
  }

  String _getStatusText() {
    switch (survey.status) {
      case SurveyStatus.active:
        return 'Active';
      case SurveyStatus.draft:
        return 'Draft';
      case SurveyStatus.published:
        return 'Published';
      case SurveyStatus.deleted:
        return 'Deleted';
    }
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      survey.name,
      style: context.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: context.colorScheme.onSurface,
        height: 1.2,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      'manage.survey_with_questions'
          .tr()
          .replaceFirst('{}', '${survey.questions.length}')
          .replaceFirst('{}', survey.questions.length == 1 ? 'manage.question'.tr() : 'manage.questions'.tr()),
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.colorScheme.onSurfaceVariant,
        height: 1.3,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMetricsAndDate(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricItem(
            context,
            icon: Icons.bar_chart_rounded,
            value: '${survey.responseCount}',
            label: 'Responses',
            color: context.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricItem(
            context,
            icon: Icons.schedule_rounded,
            value: DateFormat('MMM dd').format(survey.updatedAt ?? DateTime.now()),
            label: 'Updated',
            color: context.colorScheme.tertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 16,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  value,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: color.withOpacity(0.8),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: EnhancedButton(
            onPressed: () => _handleAnalyzeResults(context),
            variant: ButtonVariant.outline,
            size: ButtonSize.small,
            icon: Icon(
              Icons.analytics_rounded,
              size: 16,
              color: context.colorScheme.primary,
            ),
            child: Text(
              'Analyze',
              style: TextStyle(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        EnhancedButton(
          onPressed: () => _handlePreview(context),
          variant: ButtonVariant.ghost,
          size: ButtonSize.small,
          icon: Icon(
            Icons.visibility_rounded,
            size: 16,
            color: context.colorScheme.onSurfaceVariant,
          ),
          child: const Text(''),
        ),
      ],
    );
  }

  Future<void> _handleSurveyTap(BuildContext context, SurveyEntity survey) async {
    HapticFeedback.lightImpact();
    await context.pushNamed(
      AppRoutes.newSurvey.name,
      extra: SurveyAction.edit,
      pathParameters: {'id': survey.id},
    );
    if (context.mounted) {
      context.read<ManageMySurveysCubit>().fetchSurveys();
    }
  }

  void _handleAnalyzeResults(BuildContext context) {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('manage.analytics_coming_soon'.tr()),
        backgroundColor: context.colorScheme.secondaryContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _handlePreview(BuildContext context) {
    HapticFeedback.selectionClick();
    // TODO: Navigate to preview
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('manage.preview_coming_soon'.tr()),
        backgroundColor: context.colorScheme.secondaryContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// Enhanced Survey List Item
class EnhancedSurveyListItem extends StatelessWidget {
  const EnhancedSurveyListItem({
    super.key,
    required this.survey,
  });

  final SurveyEntity survey;

  @override
  Widget build(BuildContext context) {
    return BouncyButton(
      onTap: () => _handleSurveyTap(context, survey),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              context.colorScheme.surface,
              context.colorScheme.surfaceContainerHighest.withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.shadow.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: survey.status.color.withOpacity(0.03),
              blurRadius: 24,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: context.colorScheme.outline.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Status color indicator
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: survey.status.color,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                ),
              ),
              // Background pattern
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: survey.status.color.withOpacity(0.03),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(context),
                          const SizedBox(height: 12),
                          _buildTitle(context),
                          const SizedBox(height: 8),
                          _buildDescription(context),
                          const SizedBox(height: 12),
                          _buildMetrics(context),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildActions(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: survey.status.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: survey.status.color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: survey.status.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                _getStatusText(),
                style: context.textTheme.bodySmall?.copyWith(
                  color: survey.status.color,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Text(
          DateFormat('MMM dd, yyyy').format(survey.updatedAt ?? DateTime.now()),
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _getStatusText() {
    switch (survey.status) {
      case SurveyStatus.active:
        return 'Active';
      case SurveyStatus.draft:
        return 'Draft';
      case SurveyStatus.published:
        return 'Published';
      case SurveyStatus.deleted:
        return 'Deleted';
    }
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      survey.name,
      style: context.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: context.colorScheme.onSurface,
        height: 1.2,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      'manage.survey_with_questions'
          .tr()
          .replaceFirst('{}', '${survey.questions.length}')
          .replaceFirst('{}', survey.questions.length == 1 ? 'manage.question'.tr() : 'manage.questions'.tr()),
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.colorScheme.onSurfaceVariant,
        height: 1.3,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMetrics(BuildContext context) {
    return Row(
      children: [
        _buildMetricChip(
          context,
          icon: Icons.bar_chart_rounded,
          value: '${survey.responseCount}',
          label: 'responses',
          color: context.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        _buildMetricChip(
          context,
          icon: Icons.quiz_rounded,
          value: '${survey.questions.length}',
          label: 'questions',
          color: context.colorScheme.secondary,
        ),
      ],
    );
  }

  Widget _buildMetricChip(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 14,
          ),
          const SizedBox(width: 4),
          RichText(
            text: TextSpan(
              text: value,
              style: context.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: ' $label',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: color.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SurveyActions(surveyId: survey.id),
        const SizedBox(height: 8),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: context.colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: BouncyButton(
            onTap: () => _handleQuickAction(context),
            child: Icon(
              Icons.arrow_forward_rounded,
              color: context.colorScheme.primary,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSurveyTap(BuildContext context, SurveyEntity survey) async {
    HapticFeedback.lightImpact();
    await context.pushNamed(
      AppRoutes.newSurvey.name,
      extra: SurveyAction.edit,
      pathParameters: {'id': survey.id},
    );
    if (context.mounted) {
      context.read<ManageMySurveysCubit>().fetchSurveys();
    }
  }

  void _handleQuickAction(BuildContext context) {
    HapticFeedback.selectionClick();
    // Quick access to edit
    _handleSurveyTap(context, survey);
  }
}

// Enhanced Error Widget
class EnhancedErrorWidget extends StatelessWidget {
  const EnhancedErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.spacing_4.padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: context.colorScheme.errorContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: context.colorScheme.error,
              ),
            ),
            AppSpacing.spacing_3.heightBox,
            Text(
              'manage.oops_something_went_wrong'.tr(),
              style: context.textTheme.titleLarge?.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.spacing_2.heightBox,
            Text(
              message,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.spacing_4.heightBox,
            PrimaryButton(
              onPressed: onRetry,
              size: ButtonSize.medium,
              fullWidth: false,
              icon: const Icon(Icons.refresh_rounded),
              child: Text('manage.try_again'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
