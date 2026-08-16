part of 'manage_my_surveys_view.dart';

class EnhancedGridSurveys extends StatelessWidget {
  const EnhancedGridSurveys({
    super.key,
    required this.surveys,
  });

  final List<SurveyEntity> surveys;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: AppSpacing.spacing_3.padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getGridCrossAxisCount(context),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: surveys.length,
      itemBuilder: (context, index) {
        return SlideInAnimation(
          delay: Duration(milliseconds: index * 50),
          direction: SlideDirection.bottom,
          child: EnhancedSurveyCard(survey: surveys[index]),
        );
      },
    );
  }

  int _getGridCrossAxisCount(BuildContext context) {
    if (context.isPhone) return 1;
    if (context.isTablet) return 3;
    return 4;
  }
}

// Enhanced List View with Animations
class EnhancedListSurveys extends StatelessWidget {
  const EnhancedListSurveys({
    super.key,
    required this.surveys,
  });

  final List<SurveyEntity> surveys;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: AppSpacing.spacing_3.padding,
      itemCount: surveys.length,
      separatorBuilder: (_, __) => AppSpacing.spacing_3.heightBox,
      itemBuilder: (context, index) {
        return SlideInAnimation(
          delay: Duration(milliseconds: index * 50),
          direction: SlideDirection.left,
          child: EnhancedSurveyListItem(survey: surveys[index]),
        );
      },
    );
  }
}

// Enhanced Survey Card
