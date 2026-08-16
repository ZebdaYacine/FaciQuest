import 'package:faciquest/features/features.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ShortTextQuestionPreview extends StatelessWidget {
  const ShortTextQuestionPreview({
    required this.question,
    required this.answer,
    required this.onAnswerChanged,
    super.key,
  });
  final ShortAnswerQuestion question;
  final ShortAnswerAnswer? answer;
  final ValueChanged<ShortAnswerAnswer>? onAnswerChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: answer?.value,
      decoration: const InputDecoration(
          // hintText: question.hint,
          ),
      maxLength: question.maxLength,
      textInputAction: TextInputAction.done,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) =>
          question.isRequired && (value == null || value.trim().isEmpty)
              ? 'survey.validation.required_question'.tr()
              : null,
      onChanged: (value) {
        onAnswerChanged?.call(
          ShortAnswerAnswer(
            questionId: question.id,
            value: value,
          ),
        );
      },
    );
  }
}
