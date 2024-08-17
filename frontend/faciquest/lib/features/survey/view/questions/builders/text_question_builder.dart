import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class TextQuestionBuilder extends QuestionBuilder {
  const TextQuestionBuilder({
    required super.question,
    super.onChanged,
    super.key,
  });

  @override
  State<TextQuestionBuilder> createState() =>
      _AudioRecordQuestionBuilderState();
}

class _AudioRecordQuestionBuilderState extends State<TextQuestionBuilder>
    with BuildFormMixin {
  onChange({
    String? text,
  }) {
    widget.onChanged?.call((widget.question as TextQuestion).copyWith(
      title: text,
    ));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildInputForm(
          'Enter your text ',
          initialValue: (widget.question as TextQuestion).title,
          onChange: (value) {
            onChange(
              text: value,
            );
          },
        )
      ],
    );
  }
}
