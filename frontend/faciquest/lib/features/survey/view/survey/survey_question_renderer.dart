part of 'survey_view.dart';

class SurveyQuestionRenderer extends StatelessWidget {
  const SurveyQuestionRenderer({
    required this.question,
    required this.index,
    required this.onAnswerChanged,
    this.answer,
    super.key,
  });

  final QuestionEntity question;
  final AnswerEntity? answer;
  final int index;
  final ValueChanged<AnswerEntity> onAnswerChanged;

  @override
  Widget build(BuildContext context) {
    final colors = [
      context.colorScheme.primary,
      context.colorScheme.secondary,
      context.colorScheme.tertiary,
      context.colorScheme.primaryContainer,
    ];
    final cardColor = colors[index % colors.length];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: cardColor.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? context.colorScheme.surface.withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.08)
                    : cardColor.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -40,
                  right: -40,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          cardColor.withValues(alpha: 0.15),
                          cardColor.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30,
                  left: -30,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          cardColor.withValues(alpha: 0.1),
                          cardColor.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: QuestionPreview(
                    question: question,
                    isPreview: false,
                    index: index + 1,
                    answer: answer,
                    onAnswerChanged: onAnswerChanged,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
