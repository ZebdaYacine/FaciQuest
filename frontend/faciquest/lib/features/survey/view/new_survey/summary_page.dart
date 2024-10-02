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
            Text(
              survey.name,
              style: context.textTheme.headlineLarge,
            ),
            Text(
              'created at ${DateFormat('dd-MM-yy').format(survey.createdAt)} | '
              '${survey.questions.length} questions',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurface,
              ),
            ),
            AppSpacing.spacing_2.heightBox,
            Text(
              survey.description ?? '',
              style: context.textTheme.bodyLarge,
            ),
            AppSpacing.spacing_2.heightBox,
            AspectRatio(
              aspectRatio: 16 / 6,
              child: Row(
                children: [
                  Expanded(
                      child: Card(
                    child: Padding(
                      padding: AppSpacing.spacing_2.padding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total responses',
                            style: context.textTheme.titleMedium,
                          ),
                          const Spacer(),
                          Text(
                            '${survey.questions.length}',
                            style: context.textTheme.headlineMedium,
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  )),
                  AppSpacing.spacing_2.widthBox,
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: AppSpacing.spacing_2.padding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Status',
                              style: context.textTheme.titleMedium,
                            ),
                            AppSpacing.spacing_0_5.heightBox,
                            const Spacer(),
                            SurveyBadge(
                              status: survey.status,
                              large: true,
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
            AppSpacing.spacing_2.heightBox,
            Text('Survey Actions', style: context.textTheme.titleLarge),
            AppSpacing.spacing_1.heightBox,
            Card(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: context.colorScheme.onPrimary,
                          backgroundColor: context.colorScheme.primary,
                        ),
                        onPressed: cubit.editSurvey,
                        label: Text('Edit Survey'.tr()),
                        icon: const Icon(Icons.edit),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: context.colorScheme.onPrimary,
                          backgroundColor: context.colorScheme.primary,
                        ),
                        onPressed: cubit.sendSurvey,
                        label: Text('Send Survey'.tr()),
                        icon: const Icon(Icons.send),
                      ),
                      OutlinedButton.icon(
                        onPressed: cubit.analyzeSurvey,
                        label: Text('Analyze Results'.tr()),
                        icon: const Icon(Icons.bar_chart),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: context.colorScheme.error,
                          backgroundColor: context.colorScheme.errorContainer,
                        ),
                        onPressed: cubit.deleteSurvey,
                        label: Text('Delete'.tr()),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (survey.collectors.isNotEmpty) ...[
              AppSpacing.spacing_2.heightBox,
              Text('Collectors', style: context.textTheme.titleLarge),
              AppSpacing.spacing_1.heightBox,
              Card(
                child: SizedBox(
                  width: double.infinity,
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      final collector = survey.collectors[index];
                      return ListTile(
                        leading: Badge(
                          child: Text(
                            collector.status.name,
                          ),
                        ),
                        title: Text(collector.name),
                        subtitle: collector.webUrl != null
                            ? Text(collector.webUrl!)
                            : null,
                        onTap: () {},
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: survey.collectors.length,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
