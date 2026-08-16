import 'package:faciquest/features/features.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CommentBoxQuestionPreview extends StatelessWidget {
  const CommentBoxQuestionPreview({
    required this.question,
    required this.answer,
    required this.onAnswerChanged,
    super.key,
  });
  final CommentBoxQuestion question;
  final CommentBoxAnswer? answer;
  final ValueChanged<CommentBoxAnswer>? onAnswerChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: answer?.value,
      maxLength: question.maxLength,
      maxLines: question.maxLines,
      textInputAction: TextInputAction.newline,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) =>
          question.isRequired && (value == null || value.trim().isEmpty)
              ? 'survey.validation.required_question'.tr()
              : null,
      onChanged: (value) {
        onAnswerChanged?.call(
          CommentBoxAnswer(
            questionId: question.id,
            value: value,
          ),
        );
      },
    );
  }
}
