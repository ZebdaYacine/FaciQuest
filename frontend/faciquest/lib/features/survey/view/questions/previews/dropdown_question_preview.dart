import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class DropdownQuestionPreview extends StatelessWidget {
  const DropdownQuestionPreview({
    required this.question,
    this.onAnswerChanged,
    this.answer,
    super.key,
  });
  final DropdownQuestion question;
  final DropdownAnswer? answer;
  final ValueChanged<DropdownAnswer>? onAnswerChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.spacing_2.horizontalPadding,
      child: DropdownButton(
        value: answer?.selectedChoice,
        isExpanded: true,
        items: question.choices.map(
          (e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e),
            );
          },
        ).toList(),
        onChanged: (value) {
          onAnswerChanged?.call(
            DropdownAnswer(
              questionId: question.id,
              selectedChoice: value,
            ),
          );
        },
      ),
    );
  }
}
