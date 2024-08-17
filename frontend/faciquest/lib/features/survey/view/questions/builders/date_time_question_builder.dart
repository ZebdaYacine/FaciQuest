import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class DateTimeQuestionBuilder extends QuestionBuilder {
  const DateTimeQuestionBuilder({
    required super.question,
    super.onChanged,
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
    widget.onChanged?.call((widget.question as DateTimeQuestion).copyWith(
      collectDateInfo: collectDateInfo,
      collectTimeInfo: collectTimeInfo,
    ));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          value: (widget.question as DateTimeQuestion).collectDateInfo,
          title: const Text('Collect Date Info'),
          onChanged: (value) {
            onChange(
              collectDateInfo: value,
            );
          },
        ),
        CheckboxListTile(
          value: (widget.question as DateTimeQuestion).collectTimeInfo,
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
