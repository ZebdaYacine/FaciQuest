import 'package:awesome_extensions/awesome_extensions.dart';
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

class _CheckboxesQuestionBuilderState extends State<CheckboxesQuestionBuilder> {
  String? selectedType;
  late var question = widget.question as CheckboxesQuestion;
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      question.choices.length,
      (index) => TextEditingController(text: question.choices[index]),
    );
  }

  @override
  void didUpdateWidget(covariant CheckboxesQuestionBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    question = widget.question as CheckboxesQuestion;
    if (controllers.length != question.choices.length) {
      for (var controller in controllers) {
        controller.dispose();
      }
      controllers = List.generate(
        question.choices.length,
        (index) => TextEditingController(text: question.choices[index]),
      );
    } else {
      for (var i = 0; i < controllers.length; i++) {
        controllers[i].text = question.choices[i];
      }
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

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
                    controller: controllers[index],
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
        )
      ],
    );
  }
}
