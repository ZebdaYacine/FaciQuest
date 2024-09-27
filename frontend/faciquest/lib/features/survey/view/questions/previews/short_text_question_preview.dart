import 'package:faciquest/features/features.dart';
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
    return TextField(
      decoration: const InputDecoration(
          // hintText: question.hint,
          ),
      maxLength: question.maxLength,
    );
  }
}
