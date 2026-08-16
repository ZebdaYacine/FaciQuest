import 'package:awesome_extensions/awesome_extensions.dart' hide NavigatorExt;
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key, required this.survey});

  final SurveyEntity survey;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NewSurveyCubit>();
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: AdaptivePageBody(
        maxWidth: 960,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SummaryHeader(survey: survey),
            AppSpacing.spacing_3.heightBox,
            _SummaryStats(survey: survey),
            AppSpacing.spacing_4.heightBox,
            _SectionHeader(
              title: 'sections.survey_actions'.tr(),
              subtitle: 'summary.actions_description'.tr(),
            ),
            AppSpacing.spacing_2.heightBox,
            _SummaryActions(survey: survey, cubit: cubit),
            AppSpacing.spacing_4.heightBox,
            _CollectorsOverview(survey: survey, cubit: cubit),
            AppSpacing.spacing_4.heightBox,
            _QuestionsOverview(survey: survey, cubit: cubit),
            AppSpacing.spacing_4.heightBox,
          ],
        ),
      ),
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({required this.survey});

  final SurveyEntity survey;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SummaryStatusChip(status: survey.status),
          AppSpacing.spacing_2.heightBox,
          Text(
            survey.name,
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          if (survey.description?.trim().isNotEmpty == true) ...[
            AppSpacing.spacing_1.heightBox,
            Text(
              survey.description!.trim(),
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ],
          AppSpacing.spacing_2.heightBox,
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _MetadataItem(
                icon: Icons.calendar_today_outlined,
                label: DateFormat.yMMMd(
                  Localizations.localeOf(context).toString(),
                ).format(survey.createdAt),
              ),
              _MetadataItem(
                icon: Icons.update_rounded,
                label: 'summary.updated'.tr(args: [
                  DateFormat.yMMMd(
                    Localizations.localeOf(context).toString(),
                  ).format(survey.updatedAt ?? survey.createdAt),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryStats extends StatelessWidget {
  const _SummaryStats({required this.survey});

  final SurveyEntity survey;

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatData(
        Icons.forum_outlined,
        '${survey.responseCount}',
        'summary.responses'.tr(),
      ),
      _StatData(
        Icons.visibility_outlined,
        '${survey.viewCount}',
        'summary.views'.tr(),
      ),
      _StatData(
        Icons.campaign_outlined,
        '${survey.collectors.length}',
        'summary.collectors'.tr(),
      ),
      _StatData(
        Icons.quiz_outlined,
        '${survey.questions.length}',
        'summary.questions'.tr(),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 760 ? 4 : 2;
        final width = (constraints.maxWidth - ((columns - 1) * 12)) / columns;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: stats
              .map((stat) => SizedBox(width: width, child: _StatTile(stat)))
              .toList(),
        );
      },
    );
  }
}

class _SummaryActions extends StatelessWidget {
  const _SummaryActions({required this.survey, required this.cubit});

  final SurveyEntity survey;
  final NewSurveyCubit cubit;

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionData(
        Icons.edit_outlined,
        'actions.edit_survey'.tr(),
        'summary.edit_description'.tr(),
        cubit.editSurvey,
      ),
      _ActionData(
        Icons.campaign_outlined,
        'actions.collect_responses'.tr(),
        'summary.collect_description'.tr(),
        cubit.sendSurvey,
      ),
      _ActionData(
        Icons.analytics_outlined,
        'actions.analyze_results'.tr(),
        'summary.analyse_description'.tr(),
        cubit.analyzeSurvey,
      ),
      _ActionData(
        Icons.delete_outline_rounded,
        'actions.delete'.tr(),
        'summary.delete_description'.tr(),
        () => _confirmDelete(context),
        destructive: true,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 760 ? 2 : 1;
        final width = (constraints.maxWidth - ((columns - 1) * 12)) / columns;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: actions
              .map((action) => SizedBox(
                    width: width,
                    child: _SummaryActionTile(action: action),
                  ))
              .toList(),
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon:
            Icon(Icons.warning_amber_rounded, color: context.colorScheme.error),
        title: Text('delete_dialog.delete_survey_title'.tr()),
        content: Text('delete_dialog.delete_survey_confirmation'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('actions.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: context.colorScheme.error,
            ),
            child: Text('actions.delete'.tr()),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final deleted = await cubit.deleteSurvey();
    if (!context.mounted) return;
    if (deleted) {
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('summary.delete_failed'.tr()),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _CollectorsOverview extends StatelessWidget {
  const _CollectorsOverview({required this.survey, required this.cubit});

  final SurveyEntity survey;
  final NewSurveyCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'sections.collectors'.tr(),
          subtitle: 'summary.collectors_description'.tr(),
          action: TextButton.icon(
            onPressed: cubit.sendSurvey,
            icon: Icon(survey.collectors.isEmpty
                ? Icons.add_rounded
                : Icons.arrow_forward_rounded),
            label: Text(survey.collectors.isEmpty
                ? 'actions.add_new'.tr()
                : 'summary.manage_collectors'.tr()),
          ),
        ),
        AppSpacing.spacing_2.heightBox,
        if (survey.collectors.isEmpty)
          _InlineEmptyState(
            icon: Icons.campaign_outlined,
            title: 'survey.collectors.no_collectors'.tr(),
            message: 'survey.collectors.create_your_first_collector'.tr(),
            actionLabel: 'survey.collectors.create_first_collector'.tr(),
            onPressed: cubit.sendSurvey,
          )
        else
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: context.colorScheme.outlineVariant),
            ),
            child: Column(
              children: survey.collectors.take(3).map((collector) {
                return ListTile(
                  minTileHeight: 64,
                  leading: CircleAvatar(
                    backgroundColor: context.colorScheme.primaryContainer,
                    child: Icon(
                      collector.type.icon,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  title: Text(
                    collector.name.isEmpty
                        ? 'survey.collectors.unnamed'.tr()
                        : collector.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    'summary.collector_responses'.plural(
                      collector.responsesCount,
                      args: ['${collector.responsesCount}'],
                    ),
                  ),
                  trailing: _CollectorStatusChip(status: collector.status),
                  onTap: cubit.sendSurvey,
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _QuestionsOverview extends StatelessWidget {
  const _QuestionsOverview({required this.survey, required this.cubit});

  final SurveyEntity survey;
  final NewSurveyCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'sections.questions_overview'.tr(),
          subtitle: 'summary.questions_description'.tr(),
          action: TextButton.icon(
            onPressed: () => cubit.goToPage(NewSurveyPages.questions),
            icon: const Icon(Icons.edit_outlined),
            label: Text('summary.edit_questions'.tr()),
          ),
        ),
        AppSpacing.spacing_2.heightBox,
        if (survey.questions.isEmpty)
          _InlineEmptyState(
            icon: Icons.quiz_outlined,
            title: 'analysis.no_questions_in_survey'.tr(),
            message: 'analysis.add_questions_to_see_distributions'.tr(),
            actionLabel: 'actions.add_new_question'.tr(),
            onPressed: () => cubit.goToPage(NewSurveyPages.questions),
          )
        else
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: context.colorScheme.outlineVariant),
            ),
            child: Column(
              children: survey.questions.asMap().entries.take(5).map((entry) {
                return ListTile(
                  minTileHeight: 64,
                  leading: CircleAvatar(
                    backgroundColor: context.colorScheme.primaryContainer,
                    child: Text(
                      '${entry.key + 1}',
                      style: TextStyle(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  title: Text(
                    entry.value.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    'survey.QuestionType.${entry.value.type.name}'.tr(),
                  ),
                  onTap: () => cubit.goToPage(NewSurveyPages.questions),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.action,
  });

  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        if (action != null && constraints.maxWidth < 520) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              copy,
              const SizedBox(height: 8),
              action!,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: copy),
            if (action != null) ...[const SizedBox(width: 8), action!],
          ],
        );
      },
    );
  }
}

class _SummaryActionTile extends StatelessWidget {
  const _SummaryActionTile({required this.action});

  final _ActionData action;

  @override
  Widget build(BuildContext context) {
    final color = action.destructive
        ? context.colorScheme.error
        : context.colorScheme.primary;
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: action.onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(action.icon, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      action.label,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: action.destructive ? color : null,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      action.description,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class _InlineEmptyState extends StatelessWidget {
  const _InlineEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: context.colorScheme.primary),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.add_rounded),
            label: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}

class _SummaryStatusChip extends StatelessWidget {
  const _SummaryStatusChip({required this.status});

  final SurveyStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.labelKey.tr(),
        style: context.textTheme.labelLarge?.copyWith(
          color: status.color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CollectorStatusChip extends StatelessWidget {
  const _CollectorStatusChip({required this.status});

  final CollectorStatus status;

  @override
  Widget build(BuildContext context) {
    final active = status == CollectorStatus.open;
    final color = active ? Colors.green.shade700 : Colors.orange.shade800;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.labelKey.tr(),
        style: context.textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MetadataItem extends StatelessWidget {
  const _MetadataItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: context.colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile(this.stat);

  final _StatData stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(stat.icon, color: context.colorScheme.primary),
          const SizedBox(height: 12),
          Text(
            stat.value,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatData {
  const _StatData(this.icon, this.value, this.label);

  final IconData icon;
  final String value;
  final String label;
}

class _ActionData {
  const _ActionData(
    this.icon,
    this.label,
    this.description,
    this.onPressed, {
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onPressed;
  final bool destructive;
}

extension on SurveyStatus {
  String get labelKey {
    switch (this) {
      case SurveyStatus.active:
        return 'status.active';
      case SurveyStatus.draft:
        return 'status.draft';
      case SurveyStatus.published:
        return 'status.published';
      case SurveyStatus.deleted:
        return 'status.closed';
    }
  }
}

extension on CollectorStatus {
  String get labelKey {
    switch (this) {
      case CollectorStatus.open:
        return 'status.open';
      case CollectorStatus.draft:
        return 'status.draft';
      case CollectorStatus.deleted:
        return 'status.deleted';
      case CollectorStatus.checkingPayment:
        return 'status.checking_payment';
    }
  }
}
