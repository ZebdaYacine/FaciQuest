part of '../answer_entity.dart';

class StarRatingAnswer extends AnswerEntity {
  const StarRatingAnswer({
    required super.questionId,
    required this.rating,
  });

  final double rating;

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'rating': rating,
    };
  }

  @override
  PlutoCell get plutoCell => PlutoCell(value: rating);
}
