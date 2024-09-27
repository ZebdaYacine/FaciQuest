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

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (var image in question.choices) ...[
          Stack(
            children: [
              Container(
                padding: 2.padding,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.colorScheme.primary,
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
                          ? Image.file(
                              image.image!,
                              fit: BoxFit.cover,
                            )
                          : Text(image.altText ?? ''),
                ),
              ),
              Positioned(
                right: 0,
                child: question.useCheckbox
                    ? Checkbox(value: true, onChanged: (value) {})
                    : Radio(
                        value: true,
                        groupValue: true,
                        onChanged: (value) {},
                      ),
              ),
            ],
          )
        ]
      ],
    );
  }
}
