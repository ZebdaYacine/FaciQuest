import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class AudioRecordQuestionPreview extends StatelessWidget {
  const AudioRecordQuestionPreview({
    required this.question,
    this.answer,
    this.onAnswerChanged,
    super.key,
  });
  final AudioRecordQuestion question;
  final AudioRecordAnswer? answer;
  final ValueChanged<AudioRecordAnswer>? onAnswerChanged;

  @override
  Widget build(BuildContext context) {
    return const Text('Coming soon');
  }
}
