import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class PhoneQuestionBuilder extends QuestionBuilder {
  const PhoneQuestionBuilder({
    required super.question,
    super.onChanged,
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
    widget.onChanged?.call((widget.question as PhoneQuestion).copyWith(
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
              'survey.question.phone.title'.tr(),
              style: context.textTheme.bodyLarge,
            ),
            const Spacer(),
            Text('survey.question.phone.show'.tr()),
            Checkbox(
              value: (widget.question as PhoneQuestion).showPhone,
              onChanged: null,
              // (value) {
              //   onChange(showPhone: value);
              // },
            ),
          ],
        ),
        buildInputForm(
          'survey.question.phone.label'.tr(),
          key: UniqueKey(),
          initialValue: (widget.question as PhoneQuestion).phoneLabel,
          onChange: (value) {
            onChange(phoneLabel: value);
          },
        ),
        buildInputForm(
          'survey.question.phone.placeholder'.tr(),
          key: UniqueKey(),
          initialValue: (widget.question as PhoneQuestion).phoneHint,
          onChange: (value) {
            onChange(phoneHint: value);
          },
        ),
      ],
    );
  }
}
