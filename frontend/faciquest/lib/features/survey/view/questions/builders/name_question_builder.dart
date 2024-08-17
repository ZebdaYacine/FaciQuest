import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class NameQuestionBuilder extends StatefulWidget {
  final NameQuestion question;
  final ValueChanged<QuestionEntity>? onChanged;
  const NameQuestionBuilder({
    required this.question,
    this.onChanged,
    super.key,
  });

  @override
  State<NameQuestionBuilder> createState() => _NameQuestionBuilderState();
}

class _NameQuestionBuilderState extends State<NameQuestionBuilder>
    with BuildFormMixin {
  onChange({
    String? firstNameLabel,
    String? lastNameLabel,
    String? firstNameHint,
    String? lastNameHint,
    String? middleNameLabel,
    String? middleNameHint,
    bool? showFirstName,
    bool? showLastName,
    bool? showMiddleName,
    bool? showFullName,
  }) {
    widget.onChanged?.call(widget.question.copyWith(
      firstNameLabel: firstNameLabel,
      lastNameLabel: lastNameLabel,
      firstNameHint: firstNameHint,
      lastNameHint: lastNameHint,
      middleNameLabel: middleNameLabel,
      middleNameHint: middleNameHint,
      showFirstName: showFirstName,
      showLastName: showLastName,
      showMiddleName: showMiddleName,
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
              value: widget.question.showFirstName,
              onChanged: (value) {
                onChange(showFirstName: value);
              },
            ),
          ],
        ),
        buildInputForm(
          'Label :',
          key: UniqueKey(),
          initialValue: widget.question.firstNameLabel,
          onChange: (value) {
            onChange(firstNameLabel: value);
          },
        ),
        buildInputForm(
          'Placeholder :',
          key: UniqueKey(),
          initialValue: widget.question.firstNameHint,
          onChange: (value) {
            onChange(firstNameHint: value);
          },
        ),
        AppSpacing.spacing_1.heightBox,
        Row(
          children: [
            Text(
              'Last Name ',
              style: context.textTheme.bodyLarge,
            ),
            Spacer(),
            Text('Show'),
            Checkbox(
              value: widget.question.showLastName,
              onChanged: (value) {
                onChange(showLastName: value);
              },
            ),
          ],
        ),
        buildInputForm(
          'Label :',
          key: UniqueKey(),
          initialValue: widget.question.lastNameLabel,
          onChange: (value) {
            onChange(lastNameLabel: value);
          },
        ),
        buildInputForm(
          'Placeholder :',
          key: UniqueKey(),
          initialValue: widget.question.lastNameHint,
          onChange: (value) {
            onChange(lastNameHint: value);
          },
        ),
        AppSpacing.spacing_1.heightBox,
        Row(
          children: [
            Text(
              'Middle Name ',
              style: context.textTheme.bodyLarge,
            ),
            Spacer(),
            Text('Show'),
            Checkbox(
              value: widget.question.showMiddleName,
              onChanged: (value) {
                onChange(showMiddleName: value);
              },
            ),
          ],
        ),
        buildInputForm(
          'Label :',
          key: UniqueKey(),
          initialValue: widget.question.middleNameLabel,
          onChange: (value) {
            onChange(middleNameLabel: value);
          },
        ),
        buildInputForm(
          'Placeholder :',
          key: UniqueKey(),
          initialValue: widget.question.middleNameHint,
          onChange: (value) {
            onChange(middleNameHint: value);
          },
        ),
      ],
    );
  }
}
