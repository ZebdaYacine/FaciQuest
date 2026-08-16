part of 'manage_my_surveys_view.dart';

class EnhancedGridSurveys extends StatelessWidget {
  const EnhancedGridSurveys({
    super.key,
    required this.surveys,
  });

  final List<SurveyEntity> surveys;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => GridView.builder(
        padding: AppSpacing.spacing_3.padding,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getGridCrossAxisCount(constraints.maxWidth),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          mainAxisExtent: 330,
        ),
        itemCount: surveys.length,
        itemBuilder: (context, index) {
          final card = EnhancedSurveyCard(survey: surveys[index]);
          if (context.prefersReducedMotion || index > 5) return card;
          return SlideInAnimation(
            delay: Duration(milliseconds: index * 35),
            direction: SlideDirection.bottom,
            child: card,
          );
        },
      ),
    );
  }

  int _getGridCrossAxisCount(double width) {
    if (width < 680) return 1;
    if (width < 1040) return 2;
    if (width < 1360) return 3;
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
        final item = EnhancedSurveyListItem(survey: surveys[index]);
        if (context.prefersReducedMotion || index > 5) return item;
        return SlideInAnimation(
          delay: Duration(milliseconds: index * 35),
          direction: SlideDirection.left,
          child: item,
        );
      },
    );
  }
}

// Enhanced Survey Card
