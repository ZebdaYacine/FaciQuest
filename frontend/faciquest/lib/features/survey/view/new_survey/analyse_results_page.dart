import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_grid/pluto_grid.dart';

class AnalyseResultsPage extends StatelessWidget {
  const AnalyseResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSpacing.spacing_2.heightBox,
        const _ResultsTable(),
        const _BottomActions(),
      ],
    );
  }
}

class _ResultsTable extends StatelessWidget {
  const _ResultsTable();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
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
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.spacing_3.padding,
      child: Column(
        children: [
          const _ResponsesCard(),
          AppSpacing.spacing_2.heightBox,
          const _ActionButtons(),
        ],
      ),
    );
  }
}

class _ResponsesCard extends StatelessWidget {
  const _ResponsesCard();

  @override
  Widget build(BuildContext context) {
    final survey = context.watch<NewSurveyCubit>().state.survey;
    final responsesCount = survey.submissions.length;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: AppSpacing.spacing_2.padding,
        child: Row(
          children: [
            Icon(
              Icons.analytics_rounded,
              color: context.colorScheme.primary,
            ),
            AppSpacing.spacing_2.widthBox,
            Text(
              'analysis.total_responses'.tr(),
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: context.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                responsesCount.toString(),
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  @override
  Widget build(BuildContext context) {
    final survey = context.watch<NewSurveyCubit>().state.survey;
    final hasResponses = survey.submissions.isNotEmpty;

    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: () {
            context.read<NewSurveyCubit>().back();
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: context.colorScheme.error,
          ),
          label: Text('actions.back'.tr()),
          style: OutlinedButton.styleFrom(
            foregroundColor: context.colorScheme.error,
            side: BorderSide(color: context.colorScheme.error),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
        ),
        AppSpacing.spacing_2.widthBox,
        Expanded(
          child: FilledButton.icon(
            onPressed: hasResponses ? () {} : null,
            icon: const Icon(Icons.download_rounded),
            label: Text('actions.export_results'.tr()),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
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
  PlutoGridStateManager? stateManager;
  late final survey = context.read<NewSurveyCubit>().state.survey;

  Future<PlutoLazyPaginationResponse> fetch(
    PlutoLazyPaginationRequest request,
  ) async {
    try {
      final cubit = context.read<NewSurveyCubit>();
      final result = await cubit.fetchSubmissionPage(
        page: request.page,
        pageSize: 10,
      );

      final paginatedRows = result.submissions
          .map(
            (submission) => PlutoRow(
              cells: {
                for (final answer in submission.answers)
                  answer.questionId: answer.plutoCell,
              },
            ),
          )
          .toList();

      return PlutoLazyPaginationResponse(
        rows: paginatedRows,
        totalPage: result.totalPages,
      );
    } catch (e) {
      debugPrint('Error fetching data: $e');
      return PlutoLazyPaginationResponse(
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

    return PlutoGrid(
      key: const ValueKey('PlutoGrid'),
      columns: _buildColumns(),
      configuration: _buildConfiguration(context),
      rows: _buildRows(),
      createFooter: (stateManager) {
        return PlutoLazyPagination(
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

  List<PlutoColumn> _buildColumns() {
    return survey.questions.map((question) {
      return PlutoColumn(
        title: question.title,
        field: question.id,
        type: PlutoColumnType.text(),
        titleTextAlign: PlutoColumnTextAlign.center,
        textAlign: PlutoColumnTextAlign.center,
        backgroundColor:
            context.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        titleSpan: TextSpan(
          text: question.title,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        frozen: PlutoColumnFrozen.none,
        width: 200,
        minWidth: 150,
        enableContextMenu: false,
        enableDropToResize: true,
        enableAutoEditing: false,
        enableEditingMode: false,
      );
    }).toList();
  }

  PlutoGridConfiguration _buildConfiguration(BuildContext context) {
    return PlutoGridConfiguration(
      style: PlutoGridStyleConfig(
        borderColor: context.colorScheme.outlineVariant,
        gridBackgroundColor: context.colorScheme.surface,
        rowColor: context.colorScheme.surface,
        columnTextStyle: context.textTheme.bodyMedium!,
        cellTextStyle: context.textTheme.bodyMedium!,
        iconColor: context.colorScheme.primary,
        activatedColor: context.colorScheme.primaryContainer,
      ),
      scrollbar: const PlutoGridScrollbarConfig(
        isAlwaysShown: true,
      ),
      columnSize: const PlutoGridColumnSizeConfig(
        autoSizeMode: PlutoAutoSizeMode.scale,
      ),
    );
  }

  List<PlutoRow> _buildRows() {
    return survey.submissions
        .map(
          (submission) => PlutoRow(
            cells: {
              for (final answer in submission.answers)
                answer.questionId: answer.plutoCell,
            },
          ),
        )
        .toList();
  }
}
