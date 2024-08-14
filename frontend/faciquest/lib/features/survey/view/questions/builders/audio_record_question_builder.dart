import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class AudioRecordQuestionBuilder extends StatefulWidget {
  final AudioRecordQuestion question;
  final ValueChanged<QuestionEntity>? onChanged;
  const AudioRecordQuestionBuilder({
    required this.question,
    this.onChanged,
    super.key,
  });

  @override
  State<AudioRecordQuestionBuilder> createState() =>
      _AudioRecordQuestionBuilderState();
}

class _AudioRecordQuestionBuilderState extends State<AudioRecordQuestionBuilder>
    with BuildFormMixin {
  onChange() {
    widget.onChanged?.call(widget.question.copyWith());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Coming soon'),
      ],
    );
  }
}
