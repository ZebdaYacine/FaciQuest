part of 'collect_responses_page.dart';

class EmptyCollectorsStateView extends StatelessWidget {
  const EmptyCollectorsStateView({super.key});

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
                  color: context.colorScheme.primaryContainer
                      .withValues(alpha: 0.3),
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
                    useSafeArea: true,
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

class CollectorsLoadingStateView extends StatelessWidget {
  const CollectorsLoadingStateView({super.key});

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
                      const _ShimmerBox(
                          width: 48, height: 48, borderRadius: 12),
                      16.widthBox,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _ShimmerBox(
                                width: double.infinity, height: 16),
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
                      const _ShimmerBox(
                          width: 60, height: 24, borderRadius: 12),
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
        color:
            context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

// Modal Functions for Different Collector Types
