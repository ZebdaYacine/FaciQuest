part of 'home_view.dart';

class HomeSurveyListSliver extends StatelessWidget {
  const HomeSurveyListSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.status.isFailure) {
          return const SliverFillRemaining(
            child: _FailureState(),
          );
        }
        if (state.status.isSuccess && state.surveys.isEmpty) {
          return const SliverFillRemaining(
            child: _EmptyState(),
          );
        }
        return AdaptiveSliverPadding(
          top: AppSpacing.spacing_3,
          bottom: AppSpacing.spacing_3,
          sliver: SliverList.builder(
            itemCount: state.surveys.isEmpty ? 10 : state.surveys.length,
            itemBuilder: (context, index) {
              SurveyEntity? surveyEntity;
              if (state.surveys.isEmpty) {
                surveyEntity = null;
              } else {
                surveyEntity = state.surveys[index];
              }

              if (state.status.isLoading) {
                return SlideInAnimation(
                  delay: Duration(milliseconds: index * 100),
                  direction: SlideDirection.bottom,
                  child: SkeletonCard(
                    padding: AppSpacing.spacing_4.padding,
                    isLoading: true,
                  ),
                );
              } else {
                return SlideInAnimation(
                  delay: Duration(milliseconds: index * 100),
                  direction: SlideDirection.bottom,
                  child: BouncyButton(
                    onTap: () {
                      AppRoutes.survey.push(
                        context,
                        pathParameters: {
                          'id': surveyEntity?.id ?? '-1',
                        },
                      );
                    },
                    child: _SurveyCard(
                      surveyEntity: surveyEntity,
                      index: index,
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
