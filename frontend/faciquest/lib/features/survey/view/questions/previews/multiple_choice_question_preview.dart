import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class MultipleChoiceQuestionPreview extends StatelessWidget {
  const MultipleChoiceQuestionPreview({
    required this.question,
    super.key,
  });
  final MultipleChoiceQuestion question;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...question.choices.map(
          (choice) {
            return RadioListTile(
              value: choice,
              groupValue: null,
              onChanged: (value) {},
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(choice),
            );
          },
        )
      ],
    );
  }
}
