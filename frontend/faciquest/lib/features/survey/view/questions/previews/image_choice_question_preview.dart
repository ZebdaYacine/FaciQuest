import 'dart:typed_data';

import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class ImageChoiceQuestionPreview extends StatelessWidget {
  const ImageChoiceQuestionPreview({
    required this.question,
    required this.onAnswerChanged,
    required this.answer,
    super.key,
  });
  final ImageChoiceQuestion question;
  final ImageChoiceAnswer? answer;
  final ValueChanged<ImageChoiceAnswer>? onAnswerChanged;

  void _handleAnswerChanged(String? value) {
    if (value == null) return;
    final newAnswer = (answer ??
            ImageChoiceAnswer(
              multipleSelect: question.multipleSelect,
              questionId: question.id,
              selectedChoices: {value},
            ))
        .setValue(value);
    onAnswerChanged?.call(newAnswer);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 4,
      spacing: 4,
      children: [
        for (var image in question.choices) ...[
          Stack(
            children: [
              InkWell(
                onTap: () {
                  _handleAnswerChanged(image.id);
                },
                child: Ink(
                  padding: 2.padding,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: answer?.getSelectedChoice(image.id) == image.id
                          ? Colors.green
                          : context.colorScheme.primary,
                      width: 4,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: (image.url != null)
                        ? Image.network(
                            image.url!,
                            fit: BoxFit.cover,
                          )
                        : (image.image != null)
                            ? Image.memory(
                                image.image!,
                                fit: BoxFit.cover,
                              )
                            : Text(image.altText ?? ''),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: question.multipleSelect
                    ? Checkbox(
                        value: answer?.getSelectedChoice(image.id) != '',
                        onChanged: (value) {
                          _handleAnswerChanged(image.id);
                        })
                    : Radio(
                        value: image.id,
                        groupValue: answer?.getSelectedChoice(image.id),
                        onChanged: (value) {
                          _handleAnswerChanged(image.id);
                        },
                      ),
              ),
            ],
          )
        ]
      ],
    );
  }
}
