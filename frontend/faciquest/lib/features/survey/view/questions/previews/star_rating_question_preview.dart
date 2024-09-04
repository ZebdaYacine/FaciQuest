import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class StarRatingQuestionPreview extends StatelessWidget {
  const StarRatingQuestionPreview({
    required this.question,
    super.key,
  });
  final StarRatingQuestion question;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${question.order}. ${question.title}'),
        AppSpacing.spacing_1.heightBox,
        RatingWidget(
          length: question.maxRating,
          size: RatingSize.large,
          shape: question.shape,
          color: question.color,
          value: 3,
          onChanged: (value) {},
        )
      ],
    );
  }
}
