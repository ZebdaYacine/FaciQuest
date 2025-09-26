import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

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
                    const _SurveyStatsCard(),
                    const CollectorsTable(),
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 200),
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
      backgroundColor: Colors.transparent,
      builder: (modalContext) => BlocProvider.value(
        value: context.read<NewSurveyCubit>(),
        child: const _AddCollectorBottomSheet(),
      ),
    );
  }
}

// Survey Stats Card Component
class _SurveyStatsCard extends StatelessWidget {
  const _SurveyStatsCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewSurveyCubit, NewSurveyState>(
      builder: (context, state) {
        final survey = state.survey;
        final totalResponses = survey.submissions.length;
        final totalCollectors = survey.collectors.length;
        final activeCollectors = survey.collectors.where((c) => c.status == CollectorStatus.open).length;

        return Container(
          margin: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.analytics_outlined,
                        color: context.colorScheme.primary,
                        size: 28,
                      ),
                      12.widthBox,
                      Text(
                        'survey.stats.performance'.tr(),
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  20.heightBox,
                  Row(
                    children: [
                      Expanded(
                        child: _StatItem(
                          icon: Icons.people_outline,
                          label: 'survey.stats.total_responses'.tr(),
                          value: totalResponses.toString(),
                          color: context.colorScheme.primary,
                        ),
                      ),
                      Expanded(
                        child: _StatItem(
                          icon: Icons.campaign_outlined,
                          label: 'survey.stats.active_collectors'.tr(),
                          value: '$activeCollectors/$totalCollectors',
                          color: context.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  if (totalCollectors > 0) ...[
                    16.heightBox,
                    LinearProgressIndicator(
                      value: totalCollectors > 0 ? activeCollectors / totalCollectors : 0,
                      backgroundColor: context.colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation(context.colorScheme.primary),
                    ),
                    8.heightBox,
                    Text(
                      'survey.stats.collector_activity_rate'.tr(),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        8.heightBox,
        Text(
          value,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        4.heightBox,
        Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// Collector Options Section
class _AddCollectorBottomSheet extends StatelessWidget {
  const _AddCollectorBottomSheet();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colorScheme.onSurfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: context.colorScheme.primary,
                      size: 28,
                    ),
                    12.widthBox,
                    Expanded(
                      child: Text(
                        'collectors.add_new'.tr(),
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close_rounded,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: _CollectorOptionsGrid(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CollectorOptionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1,
      children: [
        _CollectorOptionCard(
          icon: Icons.person_search_rounded,
          title: 'collectors.targeted_responses'.tr(),
          description: 'collectors.targeted_description'.tr(),
          color: context.colorScheme.primary,
          onTap: () async {
            Navigator.of(context).pop(); // Close bottom sheet
            await showBuyTargetedResponsesModal(context);
            if (context.mounted) {
              context.read<NewSurveyCubit>().fetchCollectors();
            }
          },
        ),
        // _CollectorOptionCard(
        //   icon: Icons.link_rounded,
        //   title: 'survey.collectors.web_link'.tr(),
        //   description: 'survey.collectors.web_link_description'.tr(),
        //   color: context.colorScheme.secondary,
        //   onTap: () {
        //     Navigator.of(context).pop(); // Close bottom sheet
        //     _showWebLinkModal(context);
        //   },
        // ),
        // _CollectorOptionCard(
        //   icon: Icons.qr_code_rounded,
        //   title: 'survey.collectors.qr_code'.tr(),
        //   description: 'survey.collectors.qr_code_description'.tr(),
        //   color: context.colorScheme.tertiary,
        //   onTap: () {
        //     Navigator.of(context).pop(); // Close bottom sheet
        //     _showQRCodeModal(context);
        //   },
        // ),
        _CollectorOptionCard(
          icon: Icons.email_outlined,
          title: 'survey.collectors.email_invitation'.tr(),
          description: 'survey.collectors.email_invitation_description'.tr(),
          color: Colors.orange,
          onTap: () {
            Navigator.of(context).pop(); // Close bottom sheet
            _showEmailModal(context);
          },
        ),
      ],
    );
  }

  void _showWebLinkModal(BuildContext context) async {
    if (!context.mounted) return;
    await showWebLinkModal(context);
    if (context.mounted) {
      context.read<NewSurveyCubit>().fetchCollectors();
    }
  }

  void _showQRCodeModal(BuildContext context) async {
    if (!context.mounted) return;
    await showQRCodeModal(context);
    if (context.mounted) {
      context.read<NewSurveyCubit>().fetchCollectors();
    }
  }

  void _showEmailModal(BuildContext context) async {
    if (!context.mounted) return;
    await showEmailInvitationModal(context);
    if (context.mounted) {
      context.read<NewSurveyCubit>().fetchCollectors();
    }
  }
}

class _CollectorOptionCard extends StatelessWidget {
  const _CollectorOptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              12.heightBox,
              Text(
                title,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              4.heightBox,
              Text(
                description,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Bottom Navigation Section
class _BottomNavigationSection extends StatelessWidget {
  const _BottomNavigationSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: context.colorScheme.outlineVariant,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            OutlinedButton.icon(
              onPressed: () {
                context.read<NewSurveyCubit>().back();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: context.colorScheme.error,
                side: BorderSide(color: context.colorScheme.error),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              icon: Icon(
                Icons.arrow_back_rounded,
                color: context.colorScheme.error,
              ),
              label: Text('actions.back'.tr()),
            ),
            16.widthBox,
            Expanded(
              child: FilledButton.icon(
                onPressed: () {
                  context.read<NewSurveyCubit>().next();
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.analytics_rounded),
                label: Text('actions.analyze_results'.tr()),
              ),
            ),
          ],
        ),
      ),
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
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              16.heightBox,
              Text(
                title,
                style: context.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              8.heightBox,
              Text(
                description,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}

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
        if (state.status == Status.showLoading && state.survey.collectors.isEmpty) {
          return const _LoadingCollectorsState();
        }

        if (state.survey.collectors.isEmpty) {
          return const _EmptyCollectorsState();
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
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
          Text(
            'survey.collectors.active_collectors'.tr(),
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
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

  Widget _buildCollectorsList(BuildContext context, List<CollectorEntity> collectors) {
    final displayCollectors = _showAllCollectors ? collectors : collectors.take(2).toList();

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
            'survey.collectors.show_more'.tr(args: [(totalCount - 2).toString()]),
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
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: _buildCollectorIcon(context),
      title: Text(
        collector.name.isNotEmpty ? collector.name : 'survey.collectors.unnamed'.tr(),
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          4.heightBox,
          Row(
            children: [
              _buildStatusBadge(context),
              12.widthBox,
              Icon(
                Icons.visibility_outlined,
                size: 16,
                color: context.colorScheme.onSurfaceVariant,
              ),
              4.widthBox,
              Text(
                '${collector.viewsCount} ${'survey.collectors.views'.tr()}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (collector.webUrl != null) ...[
            4.heightBox,
            Row(
              children: [
                Icon(
                  Icons.link,
                  size: 16,
                  color: context.colorScheme.onSurfaceVariant,
                ),
                4.widthBox,
                Expanded(
                  child: Text(
                    collector.webUrl!,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => _copyToClipboard(context, collector.webUrl!),
                  icon: Icon(
                    Icons.copy_rounded,
                    size: 16,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ],
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildResponsesChip(context),
          8.widthBox,
          _buildActionMenu(context),
        ],
      ),
    );
  }

  Widget _buildCollectorIcon(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: collector.type.color.withOpacity(0.1),
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
        color: (isActive ? Colors.green : Colors.orange).withOpacity(0.1),
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
            collector.status.displayName,
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

  Widget _buildActionMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert_rounded,
        color: context.colorScheme.onSurfaceVariant,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 20, color: context.colorScheme.primary),
              12.widthBox,
              Text('survey.collectors.edit'.tr()),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'share',
          child: Row(
            children: [
              Icon(Icons.share_outlined, size: 20, color: context.colorScheme.secondary),
              12.widthBox,
              Text('survey.collectors.share'.tr()),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'toggle',
          child: Row(
            children: [
              Icon(
                collector.status == CollectorStatus.open ? Icons.pause_circle_outline : Icons.play_circle_outline,
                size: 20,
                color: collector.status == CollectorStatus.open ? Colors.orange : Colors.green,
              ),
              12.widthBox,
              Text(collector.status == CollectorStatus.open
                  ? 'survey.collectors.pause'.tr()
                  : 'survey.collectors.activate'.tr()),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 20, color: context.colorScheme.error),
              12.widthBox,
              Text('survey.collectors.delete'.tr(), style: TextStyle(color: context.colorScheme.error)),
            ],
          ),
        ),
      ],
      onSelected: (value) => _handleMenuAction(context, value),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('survey.collectors.link_copied_to_clipboard'.tr()),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) async {
    switch (action) {
      case 'edit':
        await _editCollector(context);
        break;
      case 'share':
        await _shareCollector(context);
        break;
      case 'toggle':
        await _toggleCollectorStatus(context);
        break;
      case 'delete':
        await _deleteCollector(context);
        break;
    }
  }

  Future<void> _editCollector(BuildContext context) async {
    await showBuyTargetedResponsesModal(context, collector: collector);
    if (context.mounted) {
      context.read<NewSurveyCubit>().fetchCollectors();
    }
  }

  Future<void> _shareCollector(BuildContext context) async {
    if (collector.webUrl != null) {
      await Share.share(collector.webUrl!);
    }
  }

  Future<void> _toggleCollectorStatus(BuildContext context) async {
    // Implement toggle status functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${collector.status == CollectorStatus.open ? 'survey.collectors.paused'.tr() : 'survey.collectors.activated'.tr()} ${'survey.collectors.collector'.tr()}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _deleteCollector(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: context.colorScheme.error),
            12.widthBox,
            Text('delete_dialog.delete_collector'.tr()),
          ],
        ),
        content: Text('delete_dialog.delete_collector_confirmation'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('actions.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: context.colorScheme.error,
            ),
            child: Text('actions.delete'.tr()),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<NewSurveyCubit>().deleteCollector(collector.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('survey.collectors.deleted_successfully'.tr()),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _EmptyCollectorsState extends StatelessWidget {
  const _EmptyCollectorsState();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.colorScheme.primaryContainer.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.campaign_outlined,
                  size: 48,
                  color: context.colorScheme.primary,
                ),
              ),
              24.heightBox,
              Text(
                'survey.collectors.no_collectors'.tr(),
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              12.heightBox,
              Text(
                'survey.collectors.create_your_first_collector'.tr(),
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              24.heightBox,
              FilledButton.icon(
                onPressed: () {
                  if (!context.mounted) return;

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (modalContext) => BlocProvider.value(
                      value: context.read<NewSurveyCubit>(),
                      child: const _AddCollectorBottomSheet(),
                    ),
                  );
                },
                icon: const Icon(Icons.add_rounded),
                label: Text('survey.collectors.create_first_collector'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingCollectorsState extends StatelessWidget {
  const _LoadingCollectorsState();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  const _ShimmerBox(width: 24, height: 24),
                  12.widthBox,
                  const _ShimmerBox(width: 120, height: 20),
                  const Spacer(),
                  const _ShimmerBox(width: 24, height: 24),
                ],
              ),
              20.heightBox,
              ...List.generate(
                3,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const _ShimmerBox(width: 48, height: 48, borderRadius: 12),
                      16.widthBox,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _ShimmerBox(width: double.infinity, height: 16),
                            8.heightBox,
                            Row(
                              children: [
                                const _ShimmerBox(width: 60, height: 12),
                                12.widthBox,
                                const _ShimmerBox(width: 80, height: 12),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const _ShimmerBox(width: 60, height: 24, borderRadius: 12),
                      8.widthBox,
                      const _ShimmerBox(width: 24, height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    this.borderRadius = 4,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

// Modal Functions for Different Collector Types
Future<void> showQRCodeModal(BuildContext context) async {
  final cubit = context.read<NewSurveyCubit>();
  final surveyUrl = 'https://survey.faciquest.com/s/${cubit.state.survey.id}';

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    constraints: BoxConstraints(maxHeight: context.height * 0.9),
    builder: (BuildContext _) {
      return AppBackDrop(
        headerActions: BackdropHeaderActions.none,
        title: Row(
          children: [
            Icon(
              Icons.qr_code_rounded,
              color: context.colorScheme.primary,
            ),
            12.widthBox,
            Text(
              'survey.collectors.qr_code'.tr(),
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'survey.collectors.generate_qr_code_for_easy_survey_access'.tr(),
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              24.heightBox,
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: QrImageView(
                  data: surveyUrl,
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: Colors.white,
                ),
              ),
              24.heightBox,
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.link,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    12.widthBox,
                    Expanded(
                      child: Text(
                        surveyUrl,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: surveyUrl));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('survey.collectors.link_copied_to_clipboard'.tr()),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.copy_rounded,
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Download QR code functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('survey.collectors.qr_code_download_feature_coming_soon'.tr()),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.download_rounded),
                label: Text('survey.collectors.download'.tr()),
              ),
            ),
            16.widthBox,
            Expanded(
              child: FilledButton.icon(
                onPressed: () {
                  Share.share(surveyUrl);
                },
                icon: const Icon(Icons.share_rounded),
                label: Text('survey.collectors.share_qr'.tr()),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> showEmailInvitationModal(BuildContext context) async {
  final cubit = context.read<NewSurveyCubit>();
  final emailController = TextEditingController();
  final subjectController = TextEditingController(
    text: 'survey.collectors.you_are_invited_to_participate_in_our_survey'.tr(),
  );
  final messageController = TextEditingController(
    text: 'survey.collectors.hi_there'.tr(),
  );

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    constraints: BoxConstraints(maxHeight: context.height * 0.9),
    builder: (BuildContext _) {
      return BlocProvider.value(
        value: cubit,
        child: AppBackDrop(
          headerActions: BackdropHeaderActions.none,
          title: Row(
            children: [
              Icon(
                Icons.email_outlined,
                color: Colors.orange,
              ),
              12.widthBox,
              Text(
                'survey.collectors.email_invitation'.tr(),
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'survey.collectors.send_personalized_email_invitations_to_your_target_audience'.tr(),
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                24.heightBox,
                Text(
                  'survey.collectors.email_addresses'.tr(),
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                8.heightBox,
                TextField(
                  controller: emailController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'survey.collectors.enter_email_addresses_separated_by_commas'.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                ),
                20.heightBox,
                Text(
                  'survey.collectors.subject'.tr(),
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                8.heightBox,
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.subject_rounded),
                  ),
                ),
                20.heightBox,
                Text(
                  'survey.collectors.message'.tr(),
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                8.heightBox,
                TextField(
                  controller: messageController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.message_outlined),
                  ),
                ),
                20.heightBox,
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.orange,
                      ),
                      12.widthBox,
                      Expanded(
                        child: Text(
                          'survey.collectors.survey_link_will_be_automatically_included_in_the_email'.tr(),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  label: Text('actions.cancel'.tr()),
                ),
              ),
              16.widthBox,
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    // Send email invitations
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('survey.collectors.email_invitations_sent_successfully'.tr()),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.send_rounded),
                  label: Text('survey.collectors.send_invites'.tr()),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
