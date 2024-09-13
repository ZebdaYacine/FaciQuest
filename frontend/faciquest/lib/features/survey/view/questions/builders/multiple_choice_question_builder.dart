import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:faciquest/core/core.dart';

import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class MultipleChoiceQuestionBuilder extends QuestionBuilder {
  const MultipleChoiceQuestionBuilder({
    required super.question,
    super.onChanged,
    this.likertScale,
    super.key,
  });
  final LikertScale? likertScale;

  @override
  State<MultipleChoiceQuestionBuilder> createState() =>
      _MultipleChoiceQuestionBuilderState();
}

class _MultipleChoiceQuestionBuilderState
    extends State<MultipleChoiceQuestionBuilder>  {
  String? selectedType;

  onChange({
    List<String>? choices,
  }) {
    widget.onChanged?.call(
      (widget.question as MultipleChoiceQuestion).copyWith(
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
                optionSizes.contains((widget.question as MultipleChoiceQuestion)
                    .choices
                    .length)) ...[
              Expanded(
                child: DropdownButton<int?>(
                  isExpanded: true,
                  value: optionSizes.contains(
                          (widget.question as MultipleChoiceQuestion)
                              .choices
                              .length)
                      ? (widget.question as MultipleChoiceQuestion)
                          .choices
                          .length
                      : null,
                  items: [
                    const DropdownMenuItem(
                      // value:  ,
                      child: Text('select a scale'),
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
                        choices: getScaleOptions(
                          selectedType,
                          widget.likertScale?.getScale(),
                        ),
                      );
                    }
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
                    ),
                  );
                },
              ),
            )
          ],
        ),
        AppSpacing.spacing_1.heightBox,
        ...(widget.question as MultipleChoiceQuestion)
            .choices
            .mapIndexed((index, item) {
          return Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  Radio(
                    value: item,
                    groupValue: null,
                    onChanged: null,
                  ),
                  Expanded(
                      child: TextFormField(
                    initialValue: item,
                    onChanged: (value) {
                      var temp = [
                        ...(widget.question as MultipleChoiceQuestion).choices
                      ];
                      temp[index] = value;
                      onChange(choices: temp);
                    },
                  )),
                ],
              )),
              AppSpacing.spacing_1.widthBox,
              IconButton.filled(
                onPressed: () {
                  final temp = [
                    ...(widget.question as MultipleChoiceQuestion).choices
                  ];
                  temp.insert(index + 1, '');
                  onChange(choices: temp);
                },
                icon: const Icon(Icons.add),
              ),
              IconButton.outlined(
                onPressed: () {
                  onChange(
                      choices:
                          (widget.question as MultipleChoiceQuestion).choices
                            ..removeAt(index));
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
