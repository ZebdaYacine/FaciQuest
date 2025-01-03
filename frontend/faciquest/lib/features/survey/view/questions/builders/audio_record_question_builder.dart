import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class AudioRecordQuestionBuilder extends QuestionBuilder {
  const AudioRecordQuestionBuilder({
    required super.question,
    super.onChanged,
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
        Text('survey.audio_record.coming_soon'.tr()),
      ],
    );
  }
}
