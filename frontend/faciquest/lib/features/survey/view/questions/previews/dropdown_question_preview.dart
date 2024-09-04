import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class DropdownQuestionPreview extends StatelessWidget {
  const DropdownQuestionPreview({
    required this.question,
    super.key,
  });
  final DropdownQuestion question;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${question.order}. ${question.title}'),
        AppSpacing.spacing_1.heightBox,
        Padding(
          padding: AppSpacing.spacing_2.horizontalPadding,
          child: DropdownButton(
            value: null,
            isExpanded: true,
            items: question.choices.map(
              (e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e),
                );
              },
            ).toList(),
            onChanged: (value) {},
          ),
        ),
      ],
    );
  }
}
