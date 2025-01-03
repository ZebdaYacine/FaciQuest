import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class EmailAddressQuestionBuilder extends QuestionBuilder {
  const EmailAddressQuestionBuilder({
    required super.question,
    super.onChanged,
    super.key,
  });

  @override
  State<EmailAddressQuestionBuilder> createState() =>
      _EmailAddressQuestionBuilderState();
}

class _EmailAddressQuestionBuilderState
    extends State<EmailAddressQuestionBuilder> with BuildFormMixin {
  onChange({
    String? emailAddressLabel,
    String? emailAddressHint,
    bool? showEmailAddress,
  }) {
    widget.onChanged?.call((widget.question as EmailAddressQuestion).copyWith(
      emailAddressLabel: emailAddressLabel,
      emailAddressHint: emailAddressHint,
      showEmailAddress: showEmailAddress,
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
              'survey.question.email.title'.tr(),
              style: context.textTheme.bodyLarge,
            ),
            const Spacer(),
            Text('survey.question.email.show'.tr()),
            Checkbox(
              value: (widget.question as EmailAddressQuestion).showEmailAddress,
              onChanged: null,
              // (value) {
              //   onChange(showEmailAddress: value);
              // },
            ),
          ],
        ),
        buildInputForm(
          'survey.question.email.label'.tr(),
          key: UniqueKey(),
          initialValue:
              (widget.question as EmailAddressQuestion).emailAddressLabel,
          onChange: (value) {
            onChange(emailAddressLabel: value);
          },
        ),
        buildInputForm(
          'survey.question.email.placeholder'.tr(),
          key: UniqueKey(),
          initialValue:
              (widget.question as EmailAddressQuestion).emailAddressHint,
          onChange: (value) {
            onChange(emailAddressHint: value);
          },
        ),
      ],
    );
  }
}
