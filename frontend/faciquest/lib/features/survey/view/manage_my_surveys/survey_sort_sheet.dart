part of 'manage_my_surveys_view.dart';

class SortOptionsBottomSheet extends StatelessWidget {
  const SortOptionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageMySurveysCubit, ManageMySurveysState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'manage.sort_by'.tr(),
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  BouncyButton(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close_rounded,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              AppSpacing.spacing_3.heightBox,
              ...SortOption.values.map((option) {
                final isSelected = state.sortOption == option;
                return BouncyButton(
                  onTap: () {
                    context
                        .read<ManageMySurveysCubit>()
                        .updateSortOption(option);
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.colorScheme.primaryContainer
                          : context.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? context.colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          option.icon,
                          color: isSelected
                              ? context.colorScheme.primary
                              : context.colorScheme.onSurfaceVariant,
                        ),
                        AppSpacing.spacing_3.widthBox,
                        Expanded(
                          child: Text(
                            option.name.tr(),
                            style: context.textTheme.titleMedium?.copyWith(
                              color: isSelected
                                  ? context.colorScheme.primary
                                  : context.colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            state.isAscending
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: context.colorScheme.primary,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

// Enhanced Grid View with Animations
