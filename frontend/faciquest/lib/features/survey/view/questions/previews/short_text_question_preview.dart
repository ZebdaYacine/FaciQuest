import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class ShortTextQuestionPreview extends StatelessWidget {
  const ShortTextQuestionPreview({
    required this.question,
    super.key,
  });
  final ShortAnswerQuestion question;

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
