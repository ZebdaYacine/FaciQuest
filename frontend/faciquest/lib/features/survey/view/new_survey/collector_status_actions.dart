part of 'collect_responses_page.dart';

extension _CollectorStatusActions on _CollectorListTile {
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
              Icon(Icons.edit_outlined,
                  size: 20, color: context.colorScheme.primary),
              12.widthBox,
              Text('survey.collectors.edit'.tr()),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'share',
          child: Row(
            children: [
              Icon(Icons.share_outlined,
                  size: 20, color: context.colorScheme.secondary),
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
                collector.status == CollectorStatus.open
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline,
                size: 20,
                color: collector.status == CollectorStatus.open
                    ? Colors.orange
                    : Colors.green,
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
              Icon(Icons.delete_outline,
                  size: 20, color: context.colorScheme.error),
              12.widthBox,
              Text('survey.collectors.delete'.tr(),
                  style: TextStyle(color: context.colorScheme.error)),
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
      await SharePlus.instance.share(ShareParams(text: collector.webUrl!));
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
