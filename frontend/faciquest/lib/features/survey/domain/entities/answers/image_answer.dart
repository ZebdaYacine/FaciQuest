part of '../answer_entity.dart';

class ImageAnswer extends AnswerEntity {
  const ImageAnswer({required super.questionId});

  @override
  PlutoCell get plutoCell => PlutoCell(value: null);

  static AnswerEntity fromMap(Map<String, dynamic> map) {
    return ImageAnswer(
      questionId: map['questionId'],
    );
  }
}
