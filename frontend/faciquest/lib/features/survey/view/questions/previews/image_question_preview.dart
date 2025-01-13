import 'dart:typed_data';

import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class ImageQuestionPreview extends StatelessWidget {
  const ImageQuestionPreview({
    required this.question,
    super.key,
  });
  final ImageQuestion question;

  @override
  Widget build(BuildContext context) {
    if (question.image.url != null) {
      return AspectRatio(
        aspectRatio: 4 / 3,
        child: Image.network(
          question.image.url!,
        ),
      );
    } else if (question.image.image != null) {
      return Image.memory(
        Uint8List.fromList(question.image.image!),
      );
    } else {
      return Text(
        question.image.altText ?? '',
      );
    }
  }
}
