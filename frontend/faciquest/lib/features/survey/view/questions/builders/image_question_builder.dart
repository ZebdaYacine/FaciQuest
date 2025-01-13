import 'dart:io';

import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class ImageQuestionBuilder extends QuestionBuilder {
  const ImageQuestionBuilder({
    required super.question,
    super.onChanged,
    super.key,
  });

  @override
  State<ImageQuestionBuilder> createState() => _ImageQuestionBuilderState();
}

class _ImageQuestionBuilderState extends State<ImageQuestionBuilder>
    with BuildFormMixin {
  onChange({
    File? image,
  }) async{
    widget.onChanged?.call((widget.question as ImageQuestion).copyWith(
      image: ImageChoice(
        id: (widget.question as ImageQuestion).image.id,
        image: await image?.readAsBytes(),
      ),
    ));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 100,
            width: double.infinity,
            child: ImagePickerWidget(
              imageBytes: (widget.question as ImageQuestion).image.image,
              useImageBytes: true,
              imageUrl: (widget.question as ImageQuestion).image.url,
              onImageSelected: (value) {
                onChange(
                  image: value,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
