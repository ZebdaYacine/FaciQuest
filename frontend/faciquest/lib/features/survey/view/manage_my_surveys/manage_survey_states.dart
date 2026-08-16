part of 'manage_my_surveys_view.dart';

class EnhancedErrorWidget extends StatelessWidget {
  const EnhancedErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.spacing_4.padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color:
                    context.colorScheme.errorContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: context.colorScheme.error,
              ),
            ),
            AppSpacing.spacing_3.heightBox,
            Text(
              'manage.oops_something_went_wrong'.tr(),
              style: context.textTheme.titleLarge?.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.spacing_2.heightBox,
            Text(
              message,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.spacing_4.heightBox,
            PrimaryButton(
              onPressed: onRetry,
              size: ButtonSize.medium,
              fullWidth: false,
              icon: const Icon(Icons.refresh_rounded),
              child: Text('manage.try_again'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
