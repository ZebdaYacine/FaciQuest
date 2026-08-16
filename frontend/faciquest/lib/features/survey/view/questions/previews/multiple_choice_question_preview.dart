import 'package:easy_localization/easy_localization.dart';
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
    return RadioGroup<String>(
      groupValue: answer?.selectedChoice,
      onChanged: (value) {
        if (value == null) return;
        onAnswerChanged?.call(
          MultipleChoiceAnswer(
            questionId: question.id,
            selectedChoice: value,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...question.choices.map(
            (choice) => Material(
              color: Colors.transparent,
              child: RadioListTile<String>(
                value: choice,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(choice).tr(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
