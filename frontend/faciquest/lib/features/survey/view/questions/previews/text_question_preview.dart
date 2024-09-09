import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class TextQuestionPreview extends StatelessWidget {
  const TextQuestionPreview({
    required this.question,
    super.key,
  });
  final TextQuestion question;

  @override
  Widget build(BuildContext context) {
    return Text(question.title);
  }
}
