import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class FileUploadQuestionBuilder extends QuestionBuilder {
  const FileUploadQuestionBuilder({
    required super.question,
    super.onChanged,
    super.key,
  });

  @override
  State<FileUploadQuestionBuilder> createState() =>
      _FileUploadQuestionBuilderState();
}

class _FileUploadQuestionBuilderState extends State<FileUploadQuestionBuilder>
    with BuildFormMixin {
  onChange({
    String? instructions,
    List<FileUploadType>? allowedExtensions,
  }) {
    widget.onChanged?.call((widget.question as FileUploadQuestion).copyWith(
      instructions: instructions,
      allowedExtensions: allowedExtensions,
    ));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('survey.question.file_upload.instructions'.tr()),
        buildInputForm(
          'survey.question.file_upload.enter_instructions'.tr(),
          onChange: (value) {
            onChange(instructions: value);
          },
        ),
        AppSpacing.spacing_1.heightBox,
        Text('survey.question.file_upload.allowed_types'.tr()),
        Wrap(
          spacing: 8,
          children: [
            ...FileUploadType.values.map(
              (e) => ChoiceChip(
                label: Text(e.name),
                selected: (widget.question as FileUploadQuestion)
                    .allowedExtensions
                    .contains(e),
                onSelected: (value) {
                  onChange(
                    allowedExtensions: value
                        ? [
                            ...(widget.question as FileUploadQuestion)
                                .allowedExtensions,
                            e
                          ]
                        : (widget.question as FileUploadQuestion)
                            .allowedExtensions
                            .where((element) => element != e)
                            .toList(),
                  );
                },
              ),
            )
          ],
        )
      ],
    );
  }
}
