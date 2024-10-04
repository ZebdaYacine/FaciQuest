import 'package:awesome_extensions/awesome_extensions.dart';

import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:faciquest/features/survey/view/new_survey/collectors_modals/buy_targeted_responses_modal.dart';
import 'package:faciquest/features/survey/view/new_survey/collectors_modals/web_link_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectResponsesPage extends StatefulWidget {
  const CollectResponsesPage({super.key});

  @override
  State<CollectResponsesPage> createState() => _CollectResponsesPageState();
}

class _CollectResponsesPageState extends State<CollectResponsesPage> {
  @override
  void initState() {
    super.initState();
    context.read<SurveyCubit>().fetchCollectors();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(child: CollectorsTable()),
        const Divider(
          thickness: 2,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              AppSpacing.spacing_2.heightBox,
              Text(
                'Add a new collector',
                style: context.textTheme.titleLarge,
              ),
              AppSpacing.spacing_2.heightBox,
              Row(
                children: [
                  Expanded(
                    child: _CollectorWidget(
                      icon: Icons.link,
                      title: 'Web Link',
                      onTap: () async {
                        await showWebLinkModal(context);
                        if (context.mounted) {
                          context.read<NewSurveyCubit>().fetchCollectors();
                        }
                      },
                      description:
                          'Ideal for sharing via email, social media, etc.',
                    ),
                  ),
                  AppSpacing.spacing_2.widthBox,
                  Expanded(
                    child: _CollectorWidget(
                      icon: Icons.person_search_rounded,
                      onTap: () async {
                        await showBuyTargetedResponsesModal(context);
                        if (context.mounted) {
                          context.read<NewSurveyCubit>().fetchCollectors();
                        }
                      },
                      title: 'Targeted Responses',
                      description: 'Find people who fit your criteria',
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  context.read<NewSurveyCubit>().back();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  side: const BorderSide(color: Colors.red),
                ),
                child: const Text('Back'),
              ),
              8.widthBox,
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<NewSurveyCubit>().next();
                  },
                  icon: const Icon(Icons.bar_chart),
                  label: const Text('Analyze Results'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CollectorWidget extends StatelessWidget {
  const _CollectorWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
            ),
            AppSpacing.spacing_1.heightBox,
            Text(
              description,
              style: context.textTheme.bodySmall,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

class CollectorsTable extends StatelessWidget {
  const CollectorsTable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewSurveyCubit, NewSurveyState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16).copyWith(top: 0),
              child: Text(
                'Total Responses: ${state.survey.responseCount}',
                style: context.textTheme.titleMedium,
              ),
            ),
            if (state.survey.collectors.isEmpty) ...[
              const Spacer(),
              Center(
                child: Text(
                  'please create a collector',
                  style: context.textTheme.titleLarge,
                ),
              ),
              const Spacer(),
            ] else
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(5),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(3),
                  4: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      children: [
                        '',
                        'Nickname',
                        'Status',
                        'Responses',
                        '',
                      ]
                          .map((e) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 4,
                                ),
                                child: Center(child: Text(e)),
                              ))
                          .toList()),
                  ...state.survey.collectors.map(
                    (e) => TableRow(
                      children: [
                        Icon(
                          e.type.icon,
                        ),
                        Text(e.name),
                        Text(e.status.name),
                        Text('${e.responsesCount}'),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
