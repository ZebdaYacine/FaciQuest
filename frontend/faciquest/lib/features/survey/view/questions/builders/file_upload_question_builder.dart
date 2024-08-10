import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class FileUploadQuestionBuilder extends StatefulWidget {
  final FileUploadQuestion question;
  final ValueChanged<QuestionEntity>? onChanged;
  const FileUploadQuestionBuilder({
    required this.question,
    this.onChanged,
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
    widget.onChanged?.call(widget.question.copyWith(
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
        Text('Instractions for respondents :'),
        buildInputForm(
          'Enter Instractions for the respondents (optional)',
          onChange: (value) {
            onChange(instructions: value);
          },
        ),
        AppSpacing.spacing_1.heightBox,
        Text('Allowable file types :'),
        Wrap(
          spacing: 8,
          children: [
            ...FileUploadType.values
                .map(
                  (e) => ChoiceChip(
                    label: Text(e.name),
                    selected: widget.question.allowedExtensions.contains(e),
                    onSelected: (value) {
                      onChange(
                        allowedExtensions: value
                            ? [...widget.question.allowedExtensions, e]
                            : widget.question.allowedExtensions
                                .where((element) => element != e)
                                .toList(),
                      );
                    },
                  ),
                )
                .toList()
          ],
        )
      ],
    );
  }
}
