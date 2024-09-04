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
    return RatingWidget(
      length: question.maxRating,
      size: RatingSize.large,
      shape: question.shape,
      color: question.color,
      value: 3,
      onChanged: (value) {},
    );
  }
}
