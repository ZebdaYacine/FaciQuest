part of '../answer_entity.dart';

class AudioRecordAnswer extends AnswerEntity {
  const AudioRecordAnswer({required super.questionId});

  @override
  PlutoCell get plutoCell => PlutoCell(
        value: null,
      );
}
