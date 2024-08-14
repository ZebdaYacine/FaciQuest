import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class DateTimeQuestionBuilder extends StatefulWidget {
  final DateTimeQuestion question;
  final ValueChanged<QuestionEntity>? onChanged;
  const DateTimeQuestionBuilder({
    required this.question,
    this.onChanged,
    super.key,
  });

  @override
  State<DateTimeQuestionBuilder> createState() =>
      _DateTimeQuestionBuilderState();
}

class _DateTimeQuestionBuilderState extends State<DateTimeQuestionBuilder>
    with BuildFormMixin {
  onChange({
    bool? collectDateInfo,
    bool? collectTimeInfo,
  }) {
    widget.onChanged?.call(widget.question.copyWith());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RadioListTile(
          value: true,
          groupValue: widget.question.collectDateInfo,
          title: const Text('Collect Date Info'),
          onChanged: (value) {
            onChange(
              collectDateInfo: value,
            );
          },
        ),
        RadioListTile(
          value: true,
          groupValue: widget.question.collectTimeInfo,
          title: const Text('Collect Time Info'),
          onChanged: (value) {
            onChange(
              collectTimeInfo: value,
            );
          },
        ),
      ],
    );
  }
}
