import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:faciquest/core/core.dart';

import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class MatrixQuestionBuilder extends StatefulWidget {
  final MatrixQuestion question;
  final ValueChanged<QuestionEntity>? onChanged;
  const MatrixQuestionBuilder({
    required this.question,
    this.onChanged,
    super.key,
  });

  @override
  State<MatrixQuestionBuilder> createState() => _MatrixQuestionBuilderState();
}

class _MatrixQuestionBuilderState extends State<MatrixQuestionBuilder>
    with BuildFormMixin {
  String? selectedType;
  onChange({
    List<String>? rows,
    List<String>? cols,
    bool? useCheckbox,
  }) {
    widget.onChanged?.call(
      widget.question.copyWith(
        rows: rows,
        cols: cols,
        useCheckbox: useCheckbox,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Rows :', style: context.textTheme.headlineSmall),
        AppSpacing.spacing_1.heightBox,
        ...widget.question.rows.mapIndexed((index, item) {
          return Row(
            children: [
              Expanded(
                child: buildInputForm(
                  '',
                  key: UniqueKey(),
                  initialValue: item,
                  onChange: (value) {
                    onChange(
                      rows: widget.question.rows
                        ..replaceRange(index, index + 1, [value]),
                    );
                  },
                ),
              ),
              AppSpacing.spacing_1.widthBox,
              IconButton.filled(
                onPressed: () {
                  final temp = [...widget.question.rows];
                  temp.insert(index + 1, '');
                  onChange(rows: temp);
                },
                icon: const Icon(Icons.add),
              ),
              IconButton.outlined(
                onPressed: () {
                  onChange(rows: widget.question.rows..removeAt(index));
                },
                icon: const Icon(
                  Icons.delete,
                ),
              )
            ],
          );
        }).toList(),
        AppSpacing.spacing_1.heightBox,
        RadioListTile(
          value: true,
          groupValue: widget.question.useCheckbox,
          toggleable: true,
          title:
              const Text('Allow multiple responses per row (use checkboxes)'),
          onChanged: (value) {
            onChange(
              useCheckbox: !widget.question.useCheckbox,
            );
          },
        ),
        Text('Columns :', style: context.textTheme.headlineSmall),
        AppSpacing.spacing_1.heightBox,
        ...widget.question.cols.mapIndexed((index, item) {
          return Row(
            children: [
              Expanded(
                child: buildInputForm(
                  '',
                  key: UniqueKey(),
                  initialValue: item,
                  onChange: (value) {
                    onChange(
                      cols: widget.question.cols
                        ..replaceRange(index, index + 1, [value]),
                    );
                  },
                ),
              ),
              AppSpacing.spacing_1.widthBox,
              IconButton.filled(
                onPressed: () {
                  final temp = [...widget.question.cols];
                  temp.insert(index + 1, '');
                  onChange(cols: temp);
                },
                icon: const Icon(Icons.add),
              ),
              IconButton.outlined(
                onPressed: () {
                  onChange(cols: widget.question.cols..removeAt(index));
                },
                icon: const Icon(
                  Icons.delete,
                ),
              )
            ],
          );
        }).toList(),
      ],
    );
  }
}
