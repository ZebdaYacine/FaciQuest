import 'package:awesome_extensions/awesome_extensions.dart' hide NavigatorExt;
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'survey_actions_menu.dart';
part 'survey_sort_sheet.dart';
part 'enhanced_survey_collections.dart';
part 'enhanced_survey_cards.dart';
part 'manage_survey_states.dart';
part 'manage_survey_toolbar.dart';
part 'manage_survey_filters.dart';
part 'manage_survey_content.dart';

class ManageMySurveysView extends StatefulWidget {
  const ManageMySurveysView({super.key});

  @override
  State<ManageMySurveysView> createState() => _ManageMySurveysViewState();
}

class _ManageMySurveysViewState extends State<ManageMySurveysView>
    with TickerProviderStateMixin {
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
      duration: const Duration(milliseconds: 240),
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
          duration: context.prefersReducedMotion
              ? Duration.zero
              : const Duration(milliseconds: 240),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Opacity(
                opacity: value,
                child: FloatingActionButton.extended(
                  onPressed: () => _handleCreateSurvey(context),
                  backgroundColor: context.colorScheme.primary,
                  foregroundColor: context.colorScheme.onPrimary,
                  elevation: 2,
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
          opacity: context.prefersReducedMotion
              ? const AlwaysStoppedAnimation(1)
              : _fadeAnimation,
          child: SafeArea(
            top: false,
            child: AdaptiveContentWidth(
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
        ),
      ),
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
