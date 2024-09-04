import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
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
        Text('${question.order}. ${question.title}'),
        AppSpacing.spacing_1.heightBox,
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
