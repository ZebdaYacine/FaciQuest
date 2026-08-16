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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colorScheme.surface,
            context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: context.colorScheme.primary.withValues(alpha: 0.03),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
        border: Border.all(
          color: context.colorScheme.outline.withValues(alpha: 0.08),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colorScheme.primary.withValues(alpha: 0.02),
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
    );
  }
}
