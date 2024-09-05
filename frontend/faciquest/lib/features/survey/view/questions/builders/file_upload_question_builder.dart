import 'package:awesome_extensions/awesome_extensions.dart';
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
        const Text('Instractions for respondents :'),
        buildInputForm(
          'Enter Instractions for the respondents (optional)',
          onChange: (value) {
            onChange(instructions: value);
          },
        ),
        AppSpacing.spacing_1.heightBox,
        const Text('Allowable file types :'),
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
