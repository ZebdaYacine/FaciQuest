part of '../answer_entity.dart';

class TextAnswer extends AnswerEntity {
  const TextAnswer({required super.questionId});

  @override
  PlutoCell get plutoCell => PlutoCell();
}
