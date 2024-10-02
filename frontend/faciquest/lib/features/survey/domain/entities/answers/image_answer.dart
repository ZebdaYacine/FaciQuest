part of '../answer_entity.dart';

class ImageAnswer extends AnswerEntity {
  const ImageAnswer({required super.questionId});

  @override
  PlutoCell get plutoCell => PlutoCell(value: null);
}
