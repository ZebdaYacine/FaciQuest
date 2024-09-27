import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class CheckboxesQuestionPreview extends StatelessWidget {
  const CheckboxesQuestionPreview({
    required this.question,
    required this.answer,
    required this.onAnswerChanged,
    super.key,
  });
  final CheckboxesQuestion question;
  final CheckboxesAnswer? answer;
  final ValueChanged<CheckboxesAnswer>? onAnswerChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...question.choices.map(
          (choice) {
            return CheckboxListTile(
              value: answer?.selectedChoices.contains(choice) ?? false,
              onChanged: (value) {
                if (value == null) return;

                final temp = {...answer?.selectedChoices ?? {}};
                if (value) {
                  temp.add(choice);
                } else {
                  temp.remove(choice);
                }
                onAnswerChanged?.call(
                  CheckboxesAnswer(
                    questionId: question.id,
                    selectedChoices: temp,
                  ),
                );
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
