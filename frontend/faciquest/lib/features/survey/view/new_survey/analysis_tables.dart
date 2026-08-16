part of 'analyse_results_page.dart';

class _ResultsTable extends StatelessWidget {
  const _ResultsTable();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.spacing_2.horizontalPadding,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: AppSpacing.spacing_2.padding,
              child: Text(
                'analysis.survey_results'.tr(),
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            const Expanded(child: _AnswersGrid()),
          ],
        ),
      ),
    );
  }
}

class _AnswersGrid extends StatefulWidget {
  const _AnswersGrid();

  @override
  State<_AnswersGrid> createState() => _AnswersGridState();
}

class _AnswersGridState extends State<_AnswersGrid> {
  TrinaGridStateManager? stateManager;
  late final survey = context.read<NewSurveyCubit>().state.survey;

  Future<TrinaLazyPaginationResponse> fetch(
    TrinaLazyPaginationRequest request,
  ) async {
    try {
      final cubit = context.read<NewSurveyCubit>();
      final result = await cubit.fetchSubmissionPage(
        page: request.page,
        pageSize: 10,
      );

      final paginatedRows = result
          .map(
            (submission) => TrinaRow(
              cells: {
                for (final answer in submission.answers)
                  answer.questionId: answer.plutoCell,
              },
            ),
          )
          .toList();

      return TrinaLazyPaginationResponse(
        rows: paginatedRows,
        totalPage: result.length + 1,
      );
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return TrinaLazyPaginationResponse(
        rows: [],
        totalPage: 1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (survey.questions.isEmpty) {
      return Center(
        child: Text(
          'analysis.no_questions'.tr(),
          style: context.textTheme.titleMedium,
        ),
      );
    }

    // if (survey.submissions.isEmpty) {
    //   return Center(
    //     child: Text(
    //       'analysis.no_responses'.tr(),
    //       style: context.textTheme.titleMedium,
    //     ),
    //   );
    // }

    return TrinaGrid(
      key: const ValueKey('TrinaGrid'),
      columns: buildColumns(),
      configuration: buildConfiguration(context),
      rows: buildRows(),
      createFooter: (stateManager) {
        return TrinaLazyPagination(
          initialPage: 1,
          initialFetch: true,
          fetchWithSorting: true,
          fetchWithFiltering: true,
          pageSizeToMove: null,
          fetch: fetch,
          stateManager: stateManager,
        );
      },
      onLoaded: (event) {
        stateManager = event.stateManager;
      },
    );
  }

  List<TrinaColumn> buildColumns() {
    return survey.questions.map((question) {
      return TrinaColumn(
        title: question.title,
        field: question.id,
        type: TrinaColumnType.text(),
        titleTextAlign: TrinaColumnTextAlign.center,
        textAlign: TrinaColumnTextAlign.center,
        backgroundColor:
            context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        titleSpan: TextSpan(
          text: question.title,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        frozen: TrinaColumnFrozen.none,
        width: 200,
        minWidth: 150,
        enableContextMenu: false,
        enableDropToResize: true,
        enableAutoEditing: false,
        enableEditingMode: false,
      );
    }).toList();
  }

  TrinaGridConfiguration buildConfiguration(BuildContext context) {
    return TrinaGridConfiguration(
      style: TrinaGridStyleConfig(
        borderColor: context.colorScheme.outlineVariant,
        gridBackgroundColor: context.colorScheme.surface,
        rowColor: context.colorScheme.surface,
        columnTextStyle: context.textTheme.bodyMedium!,
        cellTextStyle: context.textTheme.bodyMedium!,
        iconColor: context.colorScheme.primary,
        activatedColor: context.colorScheme.primaryContainer,
      ),
      scrollbar: const TrinaGridScrollbarConfig(
        isAlwaysShown: true,
      ),
      columnSize: const TrinaGridColumnSizeConfig(
        autoSizeMode: TrinaAutoSizeMode.scale,
      ),
    );
  }

  List<TrinaRow> buildRows() {
    return survey.submissions
        .map(
          (submission) => TrinaRow(
            cells: {
              for (final answer in submission.answers)
                answer.questionId: answer.plutoCell,
            },
          ),
        )
        .toList();
  }
}
