part of 'home_view.dart';

class HomeNewSurveyFab extends StatelessWidget {
  const HomeNewSurveyFab({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: context.prefersReducedMotion
          ? Duration.zero
          : const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: FloatingActionButton.extended(
              onPressed: () {
                AppRoutes.newSurvey.push(
                  context,
                  pathParameters: {
                    'id': '-1',
                  },
                );
              },
              backgroundColor: context.colorScheme.primaryContainer,
              foregroundColor: context.colorScheme.onPrimaryContainer,
              elevation: 6,
              extendedPadding: const EdgeInsets.symmetric(horizontal: 20),
              icon: const Icon(Icons.add_circle_outline_rounded),
              label: Text(
                'home.new_survey'.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
