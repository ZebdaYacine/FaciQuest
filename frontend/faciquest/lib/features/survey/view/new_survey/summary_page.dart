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
            Text(
              'created at ${DateFormat('dd MMMM yyyy').format(survey.createdAt)} • '
              '${survey.questions.length} questions',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.spacing_3.heightBox,
            if (survey.description != null && survey.description!.isNotEmpty) ...[
              Container(
                padding: AppSpacing.spacing_2.padding,
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  survey.description!,
                  style: context.textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                  ),
                ),
              ),
              AppSpacing.spacing_3.heightBox,
            ],
            AspectRatio(
              aspectRatio: 16 / 5,
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: AppSpacing.spacing_2.padding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.bar_chart_rounded,
                                  color: context.colorScheme.primary,
                                ),
                                AppSpacing.spacing_1.widthBox,
                                Text(
                                  'Total responses',
                                  style: context.textTheme.titleMedium?.copyWith(
                                    color: context.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              '${survey.responseCount}',
                              style: context.textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.colorScheme.primary,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.spacing_2.widthBox,
                  Expanded(
                    child: Card(
                      elevation: 2,
                      color: survey.status.color.withOpacity(0.15),
                      child: Padding(
                        padding: AppSpacing.spacing_2.padding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.radio_button_checked,
                                  color: survey.status.color,
                                ),
                                AppSpacing.spacing_1.widthBox,
                                Text(
                                  'Status',
                                  style: context.textTheme.titleMedium?.copyWith(
                                    color: context.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Center(
                              child: Text(
                                survey.status.name.capitalizeFirst,
                                style: context.textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: survey.status.color,
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.spacing_3.heightBox,
            Text(
              'Survey Actions',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.spacing_1.heightBox,
            Card(
              elevation: 2,
              child: Padding(
                padding: AppSpacing.spacing_2.padding,
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton.icon(
                      onPressed: cubit.editSurvey,
                      icon: const Icon(Icons.edit_rounded),
                      label: Text('Edit Survey'.tr()),
                    ),
                    FilledButton.icon(
                      onPressed: cubit.sendSurvey,
                      icon: const Icon(Icons.send_rounded),
                      label: Text('Send Survey'.tr()),
                    ),
                    OutlinedButton.icon(
                      onPressed: cubit.analyzeSurvey,
                      icon: const Icon(Icons.analytics_rounded),
                      label: Text('Analyze Results'.tr()),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: cubit.deleteSurvey,
                      icon: const Icon(Icons.delete_rounded),
                      label: Text('Delete'.tr()),
                      style: FilledButton.styleFrom(
                        foregroundColor: context.colorScheme.error,
                        backgroundColor: context.colorScheme.errorContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (survey.collectors.isNotEmpty) ...[
              AppSpacing.spacing_3.heightBox,
              Text(
                'Collectors',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSpacing.spacing_1.heightBox,
              Card(
                elevation: 2,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: AppSpacing.spacing_1.padding,
                  itemBuilder: (context, index) {
                    final collector = survey.collectors[index];
                    return ListTile(
                      leading: Icon(
                        collector.type.icon,
                        color: context.colorScheme.primary,
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
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: collector.status == CollectorStatus.open
                              ? Colors.green.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          collector.status.name,
                          style: context.textTheme.labelMedium?.copyWith(
                            color: collector.status == CollectorStatus.open
                                ? Colors.green
                                : Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      onTap: () {},
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemCount: survey.collectors.length,
                ),
              ),
            ],
            AppSpacing.spacing_3.heightBox,
          ],
        ),
      ),
    );
  }
}
