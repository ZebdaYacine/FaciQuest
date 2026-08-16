part of 'manage_my_surveys_view.dart';

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
