import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:csv/csv.dart';

part 'analysis_modals.dart';
part 'analysis_tables.dart';
part 'analysis_filters.dart';
part 'analysis_summaries.dart';
part 'analysis_export.dart';
part 'analysis_charts.dart';
part 'analysis_states.dart';

class AnalyseResultsPage extends StatefulWidget {
  const AnalyseResultsPage({super.key});

  @override
  State<AnalyseResultsPage> createState() => _AnalyseResultsPageState();
}

class _AnalyseResultsPageState extends State<AnalyseResultsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewSurveyCubit, NewSurveyState>(
      builder: (context, state) {
        if (state.status.isFailure && state.survey.isEmpty) {
          return AnalysisFailureStateView(
            onRetry: context.read<NewSurveyCubit>().fetchSurvey,
          );
        }
        if (state.survey.isEmpty) {
          return const AnalysisEmptyStateView();
        }

        return Column(
          children: [
            _buildHeader(context, state.survey),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(state.survey),
                  _buildResponsesTab(state.survey),
                  _buildAnalyticsTab(state.survey),
                ],
              ),
            ),
            _buildBottomActions(state.survey),
          ],
        );
      },
    );
  }
}
