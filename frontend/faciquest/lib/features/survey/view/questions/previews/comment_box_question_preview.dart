import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class CommentBoxQuestionPreview extends StatelessWidget {
  const CommentBoxQuestionPreview({
    required this.question,
    super.key,
  });
  final CommentBoxQuestion question;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: question.maxLength,
      maxLines: question.maxLines,
    );
  }
}
