import 'package:awesome_extensions/awesome_extensions.dart' hide NavigatorExt;
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ManageMySurveysView extends StatefulWidget {
  const ManageMySurveysView({super.key});

  @override
  State<ManageMySurveysView> createState() => _ManageMySurveysViewState();
}

class _ManageMySurveysViewState extends State<ManageMySurveysView> {
  final _cubit = ManageMySurveysCubit(getIt<SurveyRepository>());
  var _viewStyle = ViewStyle.grid;

  @override
  void initState() {
    super.initState();
    _cubit.fetchSurveys();
  }

  Future<void> _handleCreateSurvey(BuildContext context) async {
    await context.pushNamed(
      AppRoutes.newSurvey.name,
      pathParameters: {'id': '-1'},
    );
    _cubit.fetchSurveys();
  }

  void _handleViewStyleChange(Set<ViewStyle> styles) {
    if (styles.isNotEmpty) {
      setState(() => _viewStyle = styles.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: Scaffold(
        appBar: _buildAppBar(context),
        floatingActionButton: _buildFAB(context),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                context.colorScheme.surface,
                context.colorScheme.surface.withOpacity(0.95),
              ],
            ),
          ),
          child: Column(
            children: [
              _buildSearchBar(context),
              AppSpacing.spacing_2.heightBox,
              _buildSurveyList(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'manage.manage_my_surveys_title'.tr(),
        style: context.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: context.colorScheme.primary,
        ),
      ),
      elevation: 0,
      backgroundColor: context.colorScheme.surface,
    );
  }

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _handleCreateSurvey(context),
      icon: const Icon(Icons.add_rounded),
      label: Text(
        'manage.create_survey_button'.tr(),
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      backgroundColor: context.colorScheme.primary,
      foregroundColor: context.colorScheme.onPrimary,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      margin: AppSpacing.spacing_2.padding,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: _cubit.onSearchChanged,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                hintText: 'manage.search_surveys_hint'.tr(),
                prefixIcon: Icon(
                  Icons.search,
                  color: context.colorScheme.primary,
                ),
                border: _buildTextFieldBorder(context),
                enabledBorder: _buildTextFieldBorder(context),
                focusedBorder: _buildTextFieldBorder(
                  context,
                  width: 2,
                  color: context.colorScheme.primary,
                ),
              ),
            ),
          ),
          AppSpacing.spacing_2.widthBox,
          _buildViewStyleToggle(context),
        ],
      ),
    );
  }

  OutlineInputBorder _buildTextFieldBorder(
    BuildContext context, {
    double width = 1,
    Color? color,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: color ?? context.colorScheme.outline,
        width: width,
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

  Widget _buildSurveyList() {
    return BlocBuilder<ManageMySurveysCubit, ManageMySurveysState>(
      builder: (context, state) {
        if (state.status.isFailure) {
          return KErrorWidget(message: state.msg);
        }

        final surveys = state.status.isLoading
            ? SurveyEntity.dummyList()
            : state.filteredSurveys;

        return Expanded(
          child: Skeletonizer(
            enabled: state.status.isLoading,
            child: _viewStyle == ViewStyle.grid
                ? GridSurveys(surveys: surveys)
                : ListSurveys(surveys: surveys),
          ),
        );
      },
    );
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
    final color =
        isDestructive ? context.colorScheme.error : context.colorScheme.primary;

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
                  'survey_details.updated_label'.tr() +
                      '${survey.updatedAt.toString().substring(0, 10)}',
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
