import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class TextQuestionPreview extends StatelessWidget {
  const TextQuestionPreview({
    required this.question,
    this.answer,
    this.onAnswerChanged,
    super.key,
  });
  final TextQuestion question;
  final TextAnswer? answer;
  final ValueChanged<TextAnswer>? onAnswerChanged;

  @override
  Widget build(BuildContext context) {
    return Text(question.title);
  }
}
