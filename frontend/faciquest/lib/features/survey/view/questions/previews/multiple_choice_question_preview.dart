import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class MultipleChoiceQuestionPreview extends StatelessWidget {
  const MultipleChoiceQuestionPreview({
    required this.question,
    this.onAnswerChanged,
    this.answer,
    super.key,
  });
  final MultipleChoiceQuestion question;
  final MultipleChoiceAnswer? answer;
  final ValueChanged<MultipleChoiceAnswer>? onAnswerChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...question.choices.map(
          (choice) {
            return RadioListTile<String>(
              value: choice,
              groupValue: answer?.selectedChoice,
              onChanged: (value) {
                if (value == null) return;
                onAnswerChanged?.call(MultipleChoiceAnswer(
                  questionId: question.id,
                  selectedChoice: value,
                ));
              },
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(choice),
            );
          },
        )
      ],
    );
  }
}
