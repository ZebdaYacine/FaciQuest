import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:faciquest/core/core.dart';

import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class CheckboxesQuestionBuilder extends QuestionBuilder {
  const CheckboxesQuestionBuilder({
    required super.question,
    super.onChanged,
    this.likertScale,
    super.key,
  });
  final LikertScale? likertScale;

  @override
  State<CheckboxesQuestionBuilder> createState() =>
      _CheckboxesQuestionBuilderState();
}

class _CheckboxesQuestionBuilderState extends State<CheckboxesQuestionBuilder>
    with BuildFormMixin {
  String? selectedType;
  onChange({
    List<String>? choices,
  }) {
    widget.onChanged?.call(
      (widget.question as CheckboxesQuestion).copyWith(
        choices: [...choices ?? []],
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
            if (optionSizes.isNotEmpty &&
                optionSizes.contains((widget.question as CheckboxesQuestion)
                    .choices
                    .length)) ...[
              Expanded(
                child: DropdownButton<int?>(
                  isExpanded: true,
                  value: optionSizes.contains(
                          (widget.question as CheckboxesQuestion)
                              .choices
                              .length)
                      ? (widget.question as CheckboxesQuestion).choices.length
                      : null,
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('select a scale'),
                    ),
                    ...getScaleOptionsSize(selectedType)
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.toString()),
                            ))
                  ],
                  onChanged: (e) {
                    onChange(choices: getScaleOptions(selectedType, e));
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
                  const DropdownMenuItem(
                    value: null,
                    child: Text('select a type'),
                  ),
                  ...scaleOptions.keys.map(
                    (e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      );
                    },
                  ),
                ],
                onChanged: (e) {
                  selectedType = e ?? '';
                  onChange(
                      choices: getScaleOptions(
                    selectedType,
                    widget.likertScale?.getScale(),
                  ));
                },
              ),
            )
          ],
        ),
        AppSpacing.spacing_1.heightBox,
        ...(widget.question as CheckboxesQuestion)
            .choices
            .mapIndexed((index, item) {
          return Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  const Checkbox(
                    value: false,
                    onChanged: null,
                  ),
                  Expanded(
                    child: buildInputForm(
                      '',
                      initialValue: item,
                      onChange: (value) {
                        var temp = [
                          ...(widget.question as CheckboxesQuestion).choices
                        ];
                        temp[index] = value;
                        onChange(choices: temp);
                      },
                    ),
                  ),
                ],
              )),
              AppSpacing.spacing_1.widthBox,
              IconButton.filled(
                onPressed: () {
                  final temp = [
                    ...(widget.question as CheckboxesQuestion).choices
                  ];
                  temp.insert(index + 1, '');
                  onChange(choices: temp);
                },
                icon: const Icon(Icons.add),
              ),
              IconButton.outlined(
                onPressed: () {
                  final temp = [
                    ...(widget.question as CheckboxesQuestion).choices
                  ];
                  temp.removeAt(index);
                  if (temp.isEmpty) temp.add('');
                  onChange(choices: temp);
                },
                icon: const Icon(
                  Icons.delete,
                ),
              )
            ],
          );
        }),
      ],
    );
  }
}
