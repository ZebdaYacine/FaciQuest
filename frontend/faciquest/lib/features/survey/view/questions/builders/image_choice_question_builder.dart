import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/core/widgets/widgets.dart';

import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class ImageChoiceQuestionBuilder extends QuestionBuilder {
  const ImageChoiceQuestionBuilder({
    required super.question,
    super.onChanged,
    super.key,
  });

  @override
  State<ImageChoiceQuestionBuilder> createState() =>
      _ImageChoiceQuestionBuilderState();
}

class _ImageChoiceQuestionBuilderState extends State<ImageChoiceQuestionBuilder>
    with BuildFormMixin {
  String? selectedType;
  onChange({
    List<ImageChoice>? choices,
    bool? useCheckbox,
  }) {
    widget.onChanged?.call(
      (widget.question as ImageChoiceQuestion).copyWith(
        choices: choices,
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
        CheckboxListTile(
          value: (widget.question as ImageChoiceQuestion).useCheckbox,
          onChanged: (e) {
            onChange(useCheckbox: e);
          },
          title: const Text('Use Checkbox'),
        ),
        ...(widget.question as ImageChoiceQuestion)
            .choices
            .mapIndexed((index, item) {
          return Row(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (widget.question as ImageChoiceQuestion).useCheckbox
                        ? Checkbox(
                            value: false,
                            onChanged: (value) {},
                          )
                        : Radio(
                            value: item,
                            groupValue: null,
                            onChanged: (value) {},
                          ),
                    Expanded(
                      child: Column(
                        children: [
                          buildInputForm(
                            'Image Caption',
                            initialValue: item.caption,
                            onChange: (value) {
                              var choices = [
                                ...(widget.question as ImageChoiceQuestion)
                                    .choices
                              ];
                              choices[index] = item.copyWith(caption: value);
                              onChange(choices: choices);
                            },
                          ),
                          SizedBox(
                            height: 100,
                            child: ImagePickerWidget(
                              image: item.image,
                              imageUrl: item.url,
                              onImageSelected: (value) {
                                var choices = [
                                  ...(widget.question as ImageChoiceQuestion)
                                      .choices
                                ];
                                choices[index] = item.copyWith(image: value);
                                onChange(
                                  choices: choices,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.spacing_1.widthBox,
              IconButton.filled(
                onPressed: () {
                  final temp = [
                    ...(widget.question as ImageChoiceQuestion).choices
                  ];
                  temp.insert(index + 1, const ImageChoice());
                  onChange(choices: temp);
                },
                icon: const Icon(Icons.add),
              ),
              IconButton.outlined(
                onPressed: () {
                  var choices = [
                    ...(widget.question as ImageChoiceQuestion).choices
                  ];
                  choices.removeAt(index);
                  if (choices.isEmpty) choices = [const ImageChoice()];
                  onChange(choices: choices);
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
