part of 'collect_responses_page.dart';

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
                color: Colors.black.withValues(alpha: 0.1),
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
                  color: context.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.4),
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
        // _CollectorOptionCard(
        //   icon: Icons.email_outlined,
        //   title: 'survey.collectors.email_invitation'.tr(),
        //   description: 'survey.collectors.email_invitation_description'.tr(),
        //   color: Colors.orange,
        //   onTap: () {
        //     Navigator.of(context).pop(); // Close bottom sheet
        //     _showEmailModal(context);
        //   },
        // ),
      ],
    );
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
                  color: color.withValues(alpha: 0.1),
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
