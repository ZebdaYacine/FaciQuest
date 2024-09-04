
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class CheckboxesQuestionPreview extends StatelessWidget {
  const CheckboxesQuestionPreview({
    required this.question,
    super.key,
  });
  final CheckboxesQuestion question;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...question.choices.map(
          (choice) {
            return CheckboxListTile(
              value: true,
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
