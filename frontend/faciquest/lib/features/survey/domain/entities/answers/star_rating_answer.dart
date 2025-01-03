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
      'rating': rating.toString(),
    };
  }

  @override
  PlutoCell get plutoCell => PlutoCell(value: rating);

  static AnswerEntity fromMap(Map<String, dynamic> map) {
    return StarRatingAnswer(
      questionId: map['questionId'],
      rating: double.parse(map['rating']),
    );
  }
}
