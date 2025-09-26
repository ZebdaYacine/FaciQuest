import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';

import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class MatrixQuestionBuilder extends QuestionBuilder {
  const MatrixQuestionBuilder({
    required super.question,
    super.onChanged,
    this.likertScale,
    super.key,
  });
  final LikertScale? likertScale;

  @override
  State<MatrixQuestionBuilder> createState() => _MatrixQuestionBuilderState();
}

class _MatrixQuestionBuilderState extends State<MatrixQuestionBuilder> {
  String? selectedType;
  late var question = widget.question as MatrixQuestion;
  late List<TextEditingController> rowControllers;
  late List<TextEditingController> colControllers;

  @override
  void initState() {
    super.initState();
    rowControllers = List.generate(
      question.rows.length,
      (index) => TextEditingController(text: question.rows[index]),
    );
    colControllers = List.generate(
      question.cols.length,
      (index) => TextEditingController(text: question.cols[index]),
    );
  }

  @override
  void didUpdateWidget(covariant MatrixQuestionBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    question = widget.question as MatrixQuestion;
    if (rowControllers.length != question.rows.length) {
      for (var controller in rowControllers) {
        controller.dispose();
      }
      rowControllers = List.generate(
        question.rows.length,
        (index) => TextEditingController(text: question.rows[index]),
      );
    } else {
      for (var i = 0; i < rowControllers.length; i++) {
        rowControllers[i].text = question.rows[i];
      }
    }

    if (colControllers.length != question.cols.length) {
      for (var controller in colControllers) {
        controller.dispose();
      }
      colControllers = List.generate(
        question.cols.length,
        (index) => TextEditingController(text: question.cols[index]),
      );
    } else {
      for (var i = 0; i < colControllers.length; i++) {
        colControllers[i].text = question.cols[i];
      }
    }
  }

  @override
  void dispose() {
    for (var controller in rowControllers) {
      controller.dispose();
    }
    for (var controller in colControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  onChange({
    List<String>? rows,
    List<String>? cols,
    bool? useCheckbox,
  }) {
    widget.onChanged?.call(
      question.copyWith(
        rows: rows,
        cols: cols,
        useCheckbox: useCheckbox,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final optionSizes = getScaleOptionsSize(selectedType);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (optionSizes.isNotEmpty) ...[
              Expanded(
                child: DropdownButton<int?>(
                  isExpanded: true,
                  value: optionSizes.contains(question.cols.length)
                      ? question.cols.length
                      : null,
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text('survey.question.matrix.select_scale'.tr()),
                    ),
                    ...getScaleOptionsSize(selectedType)
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.toString()),
                            ))
                  ],
                  onChanged: (e) {
                    if (e == null) {
                      onChange(
                        cols: getScaleOptions(
                          selectedType,
                          widget.likertScale?.getScale(),
                        ),
                      );
                    }
                    onChange(cols: getScaleOptions(selectedType, e));
                  },
                ),
              ),
              AppSpacing.spacing_1.widthBox,
            ],
            Expanded(
              flex: 3,
              child: DropdownButton(
                isExpanded: true,
                value: selectedType,
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text('survey.question.matrix.select_type'.tr()),
                  ),
                  ...scaleOptions.keys.map(
                    (e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e.tr()),
                      );
                    },
                  ),
                ],
                onChanged: (e) {
                  selectedType = e ?? '';
                  onChange(
                    cols: getScaleOptions(
                      selectedType,
                      widget.likertScale?.getScale(),
                    ),
                  );
                },
              ),
            )
          ],
        ),
        AppSpacing.spacing_1.heightBox,
        Text('survey.question.matrix.rows'.tr(),
            style: context.textTheme.headlineSmall),
        AppSpacing.spacing_1.heightBox,
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: question.rows.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: rowControllers[index],
                    onChanged: (value) {
                      var temp = List<String>.from(question.rows);
                      temp[index] = value;
                      onChange(rows: temp);
                    },
                  ),
                ),
                AppSpacing.spacing_1.widthBox,
                IconButton.filled(
                  onPressed: () {
                    final temp = List<String>.from(question.rows);
                    temp.insert(index + 1, '');
                    onChange(rows: temp);
                  },
                  icon: const Icon(Icons.add),
                ),
                IconButton.outlined(
                  onPressed: () {
                    var temp = List<String>.from(question.rows);
                    temp.removeAt(index);
                    if (temp.isEmpty) temp.add('');
                    onChange(rows: temp);
                  },
                  icon: const Icon(Icons.delete),
                )
              ],
            );
          },
        ),
        AppSpacing.spacing_1.heightBox,
        CheckboxListTile(
          value: question.useCheckbox,
          controlAffinity: ListTileControlAffinity.leading,
          title: Text('survey.question.matrix.use_checkboxes'.tr()),
          onChanged: (value) {
            onChange(useCheckbox: value);
          },
        ),
        Text('survey.question.matrix.columns'.tr(),
            style: context.textTheme.headlineSmall),
        AppSpacing.spacing_1.heightBox,
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: question.cols.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: colControllers[index],
                    onChanged: (value) {
                      var temp = List<String>.from(question.cols);
                      temp[index] = value;
                      onChange(cols: temp);
                    },
                  ),
                ),
                AppSpacing.spacing_1.widthBox,
                IconButton.filled(
                  onPressed: () {
                    final temp = List<String>.from(question.cols);
                    temp.insert(index + 1, '');
                    onChange(cols: temp);
                  },
                  icon: const Icon(Icons.add),
                ),
                IconButton.outlined(
                  onPressed: () {
                    var temp = List<String>.from(question.cols);
                    temp.removeAt(index);
                    if (temp.isEmpty) temp.add('');
                    onChange(cols: temp);
                  },
                  icon: const Icon(Icons.delete),
                )
              ],
            );
          },
        ),
      ],
    );
  }
}
