import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class PhoneQuestionBuilder extends StatefulWidget {
  final PhoneQuestion question;
  final ValueChanged<QuestionEntity>? onChanged;
  const PhoneQuestionBuilder({
    required this.question,
    this.onChanged,
    super.key,
  });

  @override
  State<PhoneQuestionBuilder> createState() => _PhoneQuestionBuilderState();
}

class _PhoneQuestionBuilderState extends State<PhoneQuestionBuilder>
    with BuildFormMixin {
  onChange({
    String? phoneLabel,
    String? phoneHint,
    bool? showPhone,
  }) {
    widget.onChanged?.call(widget.question.copyWith(
      phoneLabel: phoneLabel,
      phoneHint: phoneHint,
      showPhone: showPhone,
    ));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Phone',
              style: context.textTheme.bodyLarge,
            ),
            Spacer(),
            Text('Show'),
            Checkbox(
              value: widget.question.showPhone, onChanged: null,
              // (value) {
              //   onChange(showPhone: value);
              // },
            ),
          ],
        ),
        buildInputForm(
          'Label :',
          key: UniqueKey(),
          initialValue: widget.question.phoneLabel,
          onChange: (value) {
            onChange(phoneLabel: value);
          },
        ),
        buildInputForm(
          'Placeholder :',
          key: UniqueKey(),
          initialValue: widget.question.phoneHint,
          onChange: (value) {
            onChange(phoneHint: value);
          },
        ),
      ],
    );
  }
}
