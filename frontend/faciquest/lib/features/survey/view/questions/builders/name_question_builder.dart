import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
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
              'survey.question.name.first_name'.tr(),
              style: context.textTheme.bodyLarge,
            ),
            const Spacer(),
            Text('survey.question.name.show'.tr()),
            Checkbox(
              value: (widget.question as NameQuestion).showFirstName,
              onChanged: (value) {
                onChange(showFirstName: value);
              },
            ),
          ],
        ),
        buildInputForm(
          'survey.question.name.label'.tr(),
          key: UniqueKey(),
          initialValue: (widget.question as NameQuestion).firstNameLabel,
          onChange: (value) {
            onChange(firstNameLabel: value);
          },
        ),
        buildInputForm(
          'survey.question.name.placeholder'.tr(),
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
              'survey.question.name.last_name'.tr(),
              style: context.textTheme.bodyLarge,
            ),
            const Spacer(),
            Text('survey.question.name.show'.tr()),
            Checkbox(
              value: (widget.question as NameQuestion).showLastName,
              onChanged: (value) {
                onChange(showLastName: value);
              },
            ),
          ],
        ),
        buildInputForm(
          'survey.question.name.label'.tr(),
          key: UniqueKey(),
          initialValue: (widget.question as NameQuestion).lastNameLabel,
          onChange: (value) {
            onChange(lastNameLabel: value);
          },
        ),
        buildInputForm(
          'survey.question.name.placeholder'.tr(),
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
              'survey.question.name.middle_name'.tr(),
              style: context.textTheme.bodyLarge,
            ),
            const Spacer(),
            Text('survey.question.name.show'.tr()),
            Checkbox(
              value: (widget.question as NameQuestion).showMiddleName,
              onChanged: (value) {
                onChange(showMiddleName: value);
              },
            ),
          ],
        ),
        buildInputForm(
          'survey.question.name.label'.tr(),
          key: UniqueKey(),
          initialValue: (widget.question as NameQuestion).middleNameLabel,
          onChange: (value) {
            onChange(middleNameLabel: value);
          },
        ),
        buildInputForm(
          'survey.question.name.placeholder'.tr(),
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
