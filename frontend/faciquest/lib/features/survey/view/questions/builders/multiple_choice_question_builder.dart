import 'package:awesome_extensions/awesome_extensions.dart';
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
    extends State<MultipleChoiceQuestionBuilder> {
  String? selectedType;
  late var question = widget.question as MultipleChoiceQuestion;

  @override
  void didUpdateWidget(MultipleChoiceQuestionBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    question = widget.question as MultipleChoiceQuestion;
  }

  // Synchronize choices with TextEditingControllers
  onChange({
    List<String>? choices,
  }) {
    widget.onChanged?.call(
      question.copyWith(
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
            if (optionSizes.isNotEmpty) ...[
              Expanded(
                child: DropdownButton<int?>(
                  isExpanded: true,
                  value: optionSizes.contains(question.choices.length)
                      ? question.choices.length
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
        ListView.builder(
          shrinkWrap: true,
          itemCount: question.choices.length,
          itemBuilder: (context, index) {
            final item = question.choices[index];
            return Row(
              children: [
                Radio(
                  value: item,
                  groupValue: null,
                  onChanged: null,
                ),
                Expanded(
                  child: TextFormField(
                    // controller: controllers[index],
                    initialValue: item,
                    onChanged: (value) {
                      var temp = List<String>.from(question.choices);
                      temp[index] = value;
                      onChange(choices: temp);
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      // question.choices.insert(index + 1, '');
                      var temp = List<String>.from(question.choices);
                      temp.insert(index + 1, '');
                      onChange(choices: temp);
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
                if (question.choices.length > 1)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        // question.choices.removeAt(index);
                        var temp = List<String>.from(question.choices);
                        temp.removeAt(index);
                        onChange(choices: temp);
                      });
                    },
                    icon: const Icon(Icons.delete),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
