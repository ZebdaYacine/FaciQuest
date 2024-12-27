import 'package:awesome_extensions/awesome_extensions.dart' hide NavigatorExt;
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({
    super.key,
    required this.survey,
  });
  final SurveyEntity survey;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NewSurveyCubit>();
    return SingleChildScrollView(
      child: Padding(
        padding: AppSpacing.spacing_2.horizontalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            AppSpacing.spacing_3.heightBox,
            if (survey.description != null && survey.description!.isNotEmpty)
              _buildDescription(context),
            _buildStatCards(context),
            AppSpacing.spacing_3.heightBox,
            _buildSurveyActions(context, cubit),
            AppSpacing.spacing_3.heightBox,
            _buildCollectors(context),
            AppSpacing.spacing_3.heightBox,
            _buildQuestionsSummary(context),
            AppSpacing.spacing_3.heightBox,
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: 'survey-title-${survey.id}',
          child: Text(
            survey.name,
            style: context.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.primary,
            ),
          ),
        ),
        AppSpacing.spacing_1.heightBox,
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 16,
              color: context.colorScheme.onSurfaceVariant,
            ),
            AppSpacing.spacing_1.widthBox,
            Text(
              DateFormat('dd MMMM yyyy').format(survey.createdAt),
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.spacing_2.widthBox,
            Icon(
              Icons.question_answer_outlined,
              size: 16,
              color: context.colorScheme.onSurfaceVariant,
            ),
            AppSpacing.spacing_1.widthBox,
            Text(
              '${survey.questions.length} questions',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: AppSpacing.spacing_3.padding,
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.colorScheme.outlineVariant,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.primary,
                ),
              ),
              AppSpacing.spacing_2.heightBox,
              Text(
                survey.description!,
                style: context.textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                  color: context.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        AppSpacing.spacing_3.heightBox,
      ],
    );
  }

  Widget _buildStatCards(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.5,
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.bar_chart_rounded,
              title: 'Total responses',
              value: '${survey.responseCount}',
              color: context.colorScheme.primary,
            ),
          ),
          AppSpacing.spacing_2.widthBox,
          Expanded(
            child: _StatCard(
              icon: Icons.radio_button_checked,
              title: 'Status',
              value: survey.status.name.capitalizeFirst,
              color: survey.status.color,
              backgroundColor: survey.status.color.withOpacity(0.15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurveyActions(BuildContext context, NewSurveyCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Survey Actions',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpacing.spacing_2.heightBox,
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: AppSpacing.spacing_2.padding,
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _ActionButton(
                  icon: Icons.edit_rounded,
                  label: 'Edit Survey'.tr(),
                  onPressed: cubit.editSurvey,
                  primary: true,
                ),
                _ActionButton(
                  icon: Icons.send_rounded,
                  label: 'Send Survey'.tr(),
                  onPressed: cubit.sendSurvey,
                  primary: true,
                ),
                _ActionButton(
                  icon: Icons.analytics_rounded,
                  label: 'Analyze Results'.tr(),
                  onPressed: cubit.analyzeSurvey,
                ),
                _ActionButton(
                  icon: Icons.delete_rounded,
                  label: 'Delete'.tr(),
                  onPressed: cubit.deleteSurvey,
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCollectors(BuildContext context) {
    if (survey.collectors.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Collectors',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add New'),
            ),
          ],
        ),
        AppSpacing.spacing_2.heightBox,
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: AppSpacing.spacing_1.padding,
            itemBuilder: (context, index) {
              final collector = survey.collectors[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: context.colorScheme.primaryContainer,
                  child: Icon(
                    collector.type.icon,
                    color: context.colorScheme.primary,
                  ),
                ),
                title: Text(
                  collector.name,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: collector.webUrl != null
                    ? Text(
                        collector.webUrl!,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      )
                    : null,
                trailing: _CollectorStatusBadge(status: collector.status),
                onTap: () {},
              );
            },
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemCount: survey.collectors.length,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionsSummary(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Questions Overview',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpacing.spacing_2.heightBox,
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: AppSpacing.spacing_2.padding,
            itemBuilder: (context, index) {
              final question = survey.questions[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: context.colorScheme.primaryContainer,
                  child: Text(
                    '${index + 1}',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(question.title),
                subtitle: Text(
                  question.type.name.capitalizeFirst,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => AppSpacing.spacing_1.heightBox,
            itemCount: survey.questions.length,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    this.backgroundColor,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: AppSpacing.spacing_2.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                AppSpacing.spacing_1.widthBox,
                Expanded(
                  child: Text(
                    title,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: context.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.primary = false,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool primary;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    if (isDestructive) {
      return FilledButton.tonalIcon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: FilledButton.styleFrom(
          foregroundColor: context.colorScheme.error,
          backgroundColor: context.colorScheme.errorContainer,
        ),
      );
    }

    if (primary) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class _CollectorStatusBadge extends StatelessWidget {
  const _CollectorStatusBadge({required this.status});

  final CollectorStatus status;

  @override
  Widget build(BuildContext context) {
    final isOpen = status == CollectorStatus.open;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: (isOpen ? Colors.green : Colors.orange).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.name,
        style: context.textTheme.labelMedium?.copyWith(
          color: isOpen ? Colors.green : Colors.orange,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
