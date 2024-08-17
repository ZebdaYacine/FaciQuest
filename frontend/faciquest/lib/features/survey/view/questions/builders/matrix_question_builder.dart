import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:faciquest/core/core.dart';

import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class MatrixQuestionBuilder extends QuestionBuilder {
  const MatrixQuestionBuilder({
    required super.question,
    super.onChanged,
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
      (widget.question as MatrixQuestion).copyWith(
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
        ...(widget.question as MatrixQuestion).rows.mapIndexed((index, item) {
          return Row(
            children: [
              Expanded(
                child: buildInputForm(
                  '',
                  key: UniqueKey(),
                  initialValue: item,
                  onChange: (value) {
                    onChange(
                      rows: (widget.question as MatrixQuestion).rows
                        ..replaceRange(index, index + 1, [value]),
                    );
                  },
                ),
              ),
              AppSpacing.spacing_1.widthBox,
              IconButton.filled(
                onPressed: () {
                  final temp = [...(widget.question as MatrixQuestion).rows];
                  temp.insert(index + 1, '');
                  onChange(rows: temp);
                },
                icon: const Icon(Icons.add),
              ),
              IconButton.outlined(
                onPressed: () {
                  onChange(
                      rows: (widget.question as MatrixQuestion).rows
                        ..removeAt(index));
                },
                icon: const Icon(
                  Icons.delete,
                ),
              )
            ],
          );
        }).toList(),
        AppSpacing.spacing_1.heightBox,
        CheckboxListTile(
          value: (widget.question as MatrixQuestion).useCheckbox,
          title:
              const Text('Allow multiple responses per row (use checkboxes)'),
          onChanged: (value) {
            onChange(
              useCheckbox: value,
            );
          },
        ),
        Text('Columns :', style: context.textTheme.headlineSmall),
        AppSpacing.spacing_1.heightBox,
        ...(widget.question as MatrixQuestion).cols.mapIndexed((index, item) {
          return Row(
            children: [
              Expanded(
                child: buildInputForm(
                  '',
                  key: UniqueKey(),
                  initialValue: item,
                  onChange: (value) {
                    onChange(
                      cols: (widget.question as MatrixQuestion).cols
                        ..replaceRange(index, index + 1, [value]),
                    );
                  },
                ),
              ),
              AppSpacing.spacing_1.widthBox,
              IconButton.filled(
                onPressed: () {
                  final temp = [...(widget.question as MatrixQuestion).cols];
                  temp.insert(index + 1, '');
                  onChange(cols: temp);
                },
                icon: const Icon(Icons.add),
              ),
              IconButton.outlined(
                onPressed: () {
                  onChange(
                      cols: (widget.question as MatrixQuestion).cols
                        ..removeAt(index));
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
