part of 'manage_my_surveys_view.dart';

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
              context.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.shadow.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: context.colorScheme.primary.withValues(alpha: 0.02),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: context.colorScheme.outline.withValues(alpha: 0.08),
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
                    color: survey.status.color.withValues(alpha: 0.05),
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
            color: survey.status.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: survey.status.color.withValues(alpha: 0.2),
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
          .replaceFirst(
              '{}',
              survey.questions.length == 1
                  ? 'manage.question'.tr()
                  : 'manage.questions'.tr()),
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
            value:
                DateFormat('MMM dd').format(survey.updatedAt ?? DateTime.now()),
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
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.15),
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
              color: color.withValues(alpha: 0.8),
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

  Future<void> _handleSurveyTap(
      BuildContext context, SurveyEntity survey) async {
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
              context.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.shadow.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: survey.status.color.withValues(alpha: 0.03),
              blurRadius: 24,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: context.colorScheme.outline.withValues(alpha: 0.08),
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
                    color: survey.status.color.withValues(alpha: 0.03),
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
            color: survey.status.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: survey.status.color.withValues(alpha: 0.2),
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
        Expanded(
          child: Text(
            DateFormat('MMM dd, yyyy').format(survey.updatedAt ?? DateTime.now()),
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
          .replaceFirst(
              '{}',
              survey.questions.length == 1
                  ? 'manage.question'.tr()
                  : 'manage.questions'.tr()),
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.colorScheme.onSurfaceVariant,
        height: 1.3,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMetrics(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildMetricChip(
          context,
          icon: Icons.bar_chart_rounded,
          value: '${survey.responseCount}',
          label: 'responses',
          color: context.colorScheme.primary,
        ),
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
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
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
                    color: color.withValues(alpha: 0.8),
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
            color: context.colorScheme.primaryContainer.withValues(alpha: 0.3),
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

  Future<void> _handleSurveyTap(
      BuildContext context, SurveyEntity survey) async {
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
