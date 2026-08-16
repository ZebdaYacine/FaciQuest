part of 'home_view.dart';

class HomeSurveySectionHeader extends StatelessWidget {
  const HomeSurveySectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveSliverPadding(
      top: AppSpacing.spacing_2,
      bottom: AppSpacing.spacing_1,
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Icon(
              Icons.explore_rounded,
              color: context.colorScheme.primary,
              size: 24,
            ),
            AppSpacing.spacing_2.widthBox,
            Expanded(
              child: Text(
                'home.available_surveys'.tr(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.onSurface,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
