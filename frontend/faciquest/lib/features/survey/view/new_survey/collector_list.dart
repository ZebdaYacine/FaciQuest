part of 'collect_responses_page.dart';

class CollectorsTable extends StatefulWidget {
  const CollectorsTable({
    super.key,
  });

  @override
  State<CollectorsTable> createState() => _CollectorsTableState();
}

class _CollectorsTableState extends State<CollectorsTable> {
  bool _showAllCollectors = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewSurveyCubit, NewSurveyState>(
      builder: (context, state) {
        if (state.status == Status.showLoading &&
            state.survey.collectors.isEmpty) {
          return const CollectorsLoadingStateView();
        }

        if (state.status == Status.failure && state.survey.collectors.isEmpty) {
          return CollectorsFailureStateView(
            onRetry: context.read<NewSurveyCubit>().fetchCollectors,
          );
        }

        if (state.survey.collectors.isEmpty) {
          return const EmptyCollectorsStateView();
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: context.colorScheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const Divider(height: 1),
                _buildCollectorsList(context, state.survey.collectors),
                if (state.survey.collectors.length > 2 && !_showAllCollectors)
                  _buildShowMoreButton(context, state.survey.collectors.length),
                _buildAddCollectorButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(
            Icons.campaign_outlined,
            color: context.colorScheme.primary,
            size: 24,
          ),
          12.widthBox,
          Expanded(
            child: Text(
              'survey.collectors.active_collectors'.tr(),
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () => context.read<NewSurveyCubit>().fetchCollectors(),
            icon: Icon(
              Icons.refresh_rounded,
              color: context.colorScheme.primary,
            ),
            tooltip: 'actions.refresh'.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectorsList(
      BuildContext context, List<CollectorEntity> collectors) {
    final displayCollectors =
        _showAllCollectors ? collectors : collectors.take(2).toList();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayCollectors.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final collector = displayCollectors[index];
        return _CollectorListTile(collector: collector);
      },
    );
  }

  Widget _buildShowMoreButton(BuildContext context, int totalCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: TextButton.icon(
          onPressed: () {
            setState(() {
              _showAllCollectors = true;
            });
          },
          icon: Icon(
            Icons.expand_more_rounded,
            color: context.colorScheme.primary,
          ),
          label: Text(
            'survey.collectors.show_more'
                .tr(args: [(totalCount - 2).toString()]),
            style: TextStyle(color: context.colorScheme.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildAddCollectorButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _showAddCollectorSheet(context),
          icon: Icon(
            Icons.add_rounded,
            color: context.colorScheme.primary,
          ),
          label: Text(
            'survey.collectors.add_new'.tr(),
            style: TextStyle(color: context.colorScheme.primary),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: context.colorScheme.primary),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  void _showAddCollectorSheet(BuildContext context) {
    if (!context.mounted) return;

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

class _CollectorListTile extends StatelessWidget {
  const _CollectorListTile({required this.collector});

  final CollectorEntity collector;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildCollectorIcon(context),
              12.widthBox,
              Expanded(
                child: Text(
                  collector.name.isNotEmpty
                      ? collector.name
                      : 'survey.collectors.unnamed'.tr(),
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildActionMenu(context),
            ],
          ),
          12.heightBox,
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _buildStatusBadge(context),
              _buildResponsesChip(context),
              _CollectorMetric(
                icon: Icons.visibility_outlined,
                label:
                    '${collector.viewsCount} ${'survey.collectors.views'.tr()}',
              ),
            ],
          ),
          if (collector.webUrl?.isNotEmpty == true) ...[
            8.heightBox,
            Container(
              padding: const EdgeInsetsDirectional.only(start: 12),
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.link_rounded,
                      size: 18, color: context.colorScheme.primary),
                  8.widthBox,
                  Expanded(
                    child: Text(
                      collector.webUrl!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        _copyToClipboard(context, collector.webUrl!),
                    icon: const Icon(Icons.copy_rounded),
                    tooltip: 'actions.copy'.tr(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCollectorIcon(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: collector.type.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        collector.type.icon,
        color: collector.type.color,
        size: 24,
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final isActive = collector.status == CollectorStatus.open;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isActive ? Colors.green : Colors.orange).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          6.widthBox,
          Text(
            collector.status.labelKey.tr(),
            style: context.textTheme.bodySmall?.copyWith(
              color: isActive ? Colors.green : Colors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsesChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_outline,
            size: 16,
            color: context.colorScheme.primary,
          ),
          4.widthBox,
          Text(
            '${collector.responsesCount}',
            style: context.textTheme.titleSmall?.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectorMetric extends StatelessWidget {
  const _CollectorMetric({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: context.colorScheme.onSurfaceVariant),
        4.widthBox,
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
