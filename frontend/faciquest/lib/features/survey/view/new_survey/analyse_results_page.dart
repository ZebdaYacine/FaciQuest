import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_grid/pluto_grid.dart';

class AnalyseResultsPage extends StatefulWidget {
  const AnalyseResultsPage({super.key});

  @override
  State<AnalyseResultsPage> createState() => _AnalyseResultsPageState();
}

class _AnalyseResultsPageState extends State<AnalyseResultsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(child: _AnswersGrid()),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Total Responses:',
                    style: context.titleMedium,
                  ),
                  const Spacer(),
                  Text(
                    '10',
                    style: context.titleMedium,
                  ),
                ],
              ),
              AppSpacing.spacing_1.heightBox,
              Row(
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
                      onPressed: () {},
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('Export'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnswersGrid extends StatefulWidget {
  const _AnswersGrid({
    super.key,
  });

  @override
  State<_AnswersGrid> createState() => _AnswersGridState();
}

class _AnswersGridState extends State<_AnswersGrid> {
  late final PlutoGridStateManager stateManager;
  Future<PlutoLazyPaginationResponse> fetch(
    PlutoLazyPaginationRequest request,
  ) async {
    await Future.delayed(const Duration(seconds: 3));
    return PlutoLazyPaginationResponse(
      rows: [],
      totalPage: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewSurveyCubit, NewSurveyState>(
      builder: (context, state) {
        return PlutoGrid(
          onLoaded: (event) {
            stateManager = event.stateManager;
          },
          columns: state.survey.questions.map((question) {
            return PlutoColumn(
              title: question.title,
              field: question.id,
              type: PlutoColumnType.text(),
            );
          }).toList(),
          configuration: const PlutoGridConfiguration(),
          rows: state.survey.submissions
              .map(
                (submission) => PlutoRow(
                  cells: {
                    for (final answer in submission.answers)
                      answer.questionId: answer.plutoCell,
                  },
                ),
              )
              .toList(),
          createFooter: (stateManager) {
            return PlutoLazyPagination(
              // Determine the first page.
              // Default is 1.
              initialPage: 1,

              // First call the fetch function to determine whether to load the page.
              // Default is true.
              initialFetch: true,

              // Decide whether sorting will be handled by the server.
              // If false, handle sorting on the client side.
              // Default is true.
              fetchWithSorting: true,

              // Decide whether filtering is handled by the server.
              // If false, handle filtering on the client side.
              // Default is true.
              fetchWithFiltering: true,

              // Determines the page size to move to the previous and next page buttons.
              // Default value is null. In this case,
              // it moves as many as the number of page buttons visible on the screen.
              pageSizeToMove: null,
              fetch: fetch,
              stateManager: stateManager,
            );
          },
        );
      },
    );
  }
}
