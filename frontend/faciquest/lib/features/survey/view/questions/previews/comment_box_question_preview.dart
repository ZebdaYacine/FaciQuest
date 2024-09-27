import 'package:faciquest/features/features.dart';
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
