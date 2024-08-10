import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:faciquest/core/core.dart';

import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class MultipleChoiceQuestionBuilder extends StatefulWidget {
  final MultipleChoiceQuestion question;
  final ValueChanged<QuestionEntity>? onChanged;
  const MultipleChoiceQuestionBuilder({
    required this.question,
    this.onChanged,
    super.key,
  });

  @override
  State<MultipleChoiceQuestionBuilder> createState() =>
      _MultipleChoiceQuestionBuilderState();
}

class _MultipleChoiceQuestionBuilderState
    extends State<MultipleChoiceQuestionBuilder> with BuildFormMixin {
  String? selectedType;
  onChange({
    List<String>? choices,
  }) {
    widget.onChanged?.call(
      widget.question.copyWith(
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
                optionSizes.contains(widget.question.choices.length)) ...[
              Expanded(
                child: DropdownButton<int?>(
                  isExpanded: true,
                  value: optionSizes.contains(widget.question.choices.length)
                      ? widget.question.choices.length
                      : null,
                  items: [
                    DropdownMenuItem(
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
                  DropdownMenuItem(
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
                  ).toList(),
                ],
                onChanged: (e) {
                  selectedType = e ?? '';
                  onChange(choices: getScaleOptions(selectedType, null));
                },
              ),
            )
          ],
        ),
        AppSpacing.spacing_1.heightBox,
        ...widget.question.choices.mapIndexed((index, item) {
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
                    child: buildInputForm(
                      '',
                      key: UniqueKey(),
                      initialValue: item,
                      onChange: (value) {
                        onChange(
                          choices: widget.question.choices
                            ..replaceRange(index, index + 1, [value]),
                        );
                      },
                    ),
                  ),
                ],
              )),
              AppSpacing.spacing_1.widthBox,
              IconButton.filled(
                onPressed: () {
                  final temp = [...widget.question.choices];
                  temp.insert(index + 1, '');
                  onChange(choices: temp);
                },
                icon: const Icon(Icons.add),
              ),
              IconButton.outlined(
                onPressed: () {
                  onChange(choices: widget.question.choices..removeAt(index));
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
