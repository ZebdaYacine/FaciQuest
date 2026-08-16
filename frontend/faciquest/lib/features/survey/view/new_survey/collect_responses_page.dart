import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

part 'collect_response_stats.dart';
part 'collect_response_actions.dart';
part 'collector_list.dart';
part 'collector_states.dart';
part 'collector_share_modals.dart';
part 'collector_status_actions.dart';

class CollectResponsesPage extends StatefulWidget {
  const CollectResponsesPage({super.key});

  @override
  State<CollectResponsesPage> createState() => _CollectResponsesPageState();
}

class _CollectResponsesPageState extends State<CollectResponsesPage> {
  @override
  void initState() {
    super.initState();
    _refreshCollectors();
  }

  Future<void> _refreshCollectors() async {
    try {
      if (mounted) {
        context.read<NewSurveyCubit>().fetchCollectors();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading collectors: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NewSurveyCubit, NewSurveyState>(
      listener: (context, state) {
        if (state.status == Status.failure && state.msg != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.msg!),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }

        // Auto-show collector modal for new surveys with no collectors
        if (state.shouldShowCollectorModal &&
            state.survey.collectors.isEmpty &&
            state.status == Status.success &&
            mounted) {
          // Use post frame callback to ensure the widget is built
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _showFirstCollectorModal(context);
            }
          });
        }
      },
      child: RefreshIndicator(
        onRefresh: _refreshCollectors,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SurveyStatsCard(),
                    const CollectorsTable(),
                    SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 200),
                  ],
                ),
              ),
            ),
            const _BottomNavigationSection(),
          ],
        ),
      ),
    );
  }

  void _showFirstCollectorModal(BuildContext context) {
    if (!mounted) return;

    // Reset the flag first to prevent showing again
    context.read<NewSurveyCubit>().resetCollectorModalFlag();

    // Show the collector creation modal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => BlocProvider.value(
        value: context.read<NewSurveyCubit>(),
        child: const _AddCollectorBottomSheet(),
      ),
    );
  }
}

// Survey Stats Card Component
