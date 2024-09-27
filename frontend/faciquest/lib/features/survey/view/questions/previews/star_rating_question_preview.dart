import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class StarRatingQuestionPreview extends StatelessWidget {
  const StarRatingQuestionPreview({
    required this.question,
    required this.answer,
    required this.onAnswerChanged,
    super.key,
  });
  final StarRatingQuestion question;
  final StarRatingAnswer? answer;
  final ValueChanged<StarRatingAnswer>? onAnswerChanged;

  @override
  Widget build(BuildContext context) {
    return RatingWidget(
      length: question.maxRating,
      size: RatingSize.large,
      shape: question.shape,
      color: question.color,
      value: answer?.rating ?? 0,
      onChanged: (value) {
        onAnswerChanged?.call(
          StarRatingAnswer(
            questionId: question.id,
            rating: value,
          ),
        );
      },
    );
  }
}
