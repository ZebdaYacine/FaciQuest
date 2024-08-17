import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class EmailAddressQuestionBuilder extends StatefulWidget {
  final EmailAddressQuestion question;
  final ValueChanged<QuestionEntity>? onChanged;
  const EmailAddressQuestionBuilder({
    required this.question,
    this.onChanged,
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
    widget.onChanged?.call(widget.question.copyWith(
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
              'First Name ',
              style: context.textTheme.bodyLarge,
            ),
            Spacer(),
            Text('Show'),
            Checkbox(
              value: widget.question.showEmailAddress, onChanged: null,
              // (value) {
              //   onChange(showEmailAddress: value);
              // },
            ),
          ],
        ),
        buildInputForm(
          'Label :',
          key: UniqueKey(),
          initialValue: widget.question.emailAddressLabel,
          onChange: (value) {
            onChange(emailAddressLabel: value);
          },
        ),
        buildInputForm(
          'Placeholder :',
          key: UniqueKey(),
          initialValue: widget.question.emailAddressHint,
          onChange: (value) {
            onChange(emailAddressHint: value);
          },
        ),
      ],
    );
  }
}
