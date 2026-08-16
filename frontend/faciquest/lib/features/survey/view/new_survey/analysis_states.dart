part of 'analyse_results_page.dart';

class AnalysisEmptyStateView extends StatelessWidget {
  const AnalysisEmptyStateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AdaptivePageBody(
        maxWidth: 480,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 64,
              color: context.colorScheme.primary,
            ),
            AppSpacing.spacing_3.heightBox,
            Text(
              'analysis.no_responses'.tr(),
              textAlign: TextAlign.center,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.spacing_1.heightBox,
            Text(
              'analysis.distributions_appear_when_responses_collected'.tr(),
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnalysisFailureStateView extends StatelessWidget {
  const AnalysisFailureStateView({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AdaptivePageBody(
        maxWidth: 480,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 64,
              color: context.colorScheme.error,
            ),
            AppSpacing.spacing_3.heightBox,
            Text(
              'survey.error.title'.tr(),
              textAlign: TextAlign.center,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.spacing_1.heightBox,
            Text(
              'survey.error.message'.tr(),
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.spacing_3.heightBox,
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text('survey.error.button.retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
