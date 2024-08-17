import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class NameQuestionBuilder extends QuestionBuilder {
  const NameQuestionBuilder({
    required super.question,
    super.onChanged,
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
    widget.onChanged?.call((widget.question as NameQuestion).copyWith(
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
              value: (widget.question as NameQuestion).showFirstName,
              onChanged: (value) {
                onChange(showFirstName: value);
              },
            ),
          ],
        ),
        buildInputForm(
          'Label :',
          key: UniqueKey(),
          initialValue: (widget.question as NameQuestion).firstNameLabel,
          onChange: (value) {
            onChange(firstNameLabel: value);
          },
        ),
        buildInputForm(
          'Placeholder :',
          key: UniqueKey(),
          initialValue: (widget.question as NameQuestion).firstNameHint,
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
              value: (widget.question as NameQuestion).showLastName,
              onChanged: (value) {
                onChange(showLastName: value);
              },
            ),
          ],
        ),
        buildInputForm(
          'Label :',
          key: UniqueKey(),
          initialValue: (widget.question as NameQuestion).lastNameLabel,
          onChange: (value) {
            onChange(lastNameLabel: value);
          },
        ),
        buildInputForm(
          'Placeholder :',
          key: UniqueKey(),
          initialValue: (widget.question as NameQuestion).lastNameHint,
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
              value: (widget.question as NameQuestion).showMiddleName,
              onChanged: (value) {
                onChange(showMiddleName: value);
              },
            ),
          ],
        ),
        buildInputForm(
          'Label :',
          key: UniqueKey(),
          initialValue: (widget.question as NameQuestion).middleNameLabel,
          onChange: (value) {
            onChange(middleNameLabel: value);
          },
        ),
        buildInputForm(
          'Placeholder :',
          key: UniqueKey(),
          initialValue: (widget.question as NameQuestion).middleNameHint,
          onChange: (value) {
            onChange(middleNameHint: value);
          },
        ),
      ],
    );
  }
}
