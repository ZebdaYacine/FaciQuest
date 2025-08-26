part of '../answer_entity.dart';

class AudioRecordAnswer extends AnswerEntity {
  const AudioRecordAnswer({required super.questionId});

  @override
  TrinaCell get plutoCell => TrinaCell(
        value: null,
      );
  @override
  Map<String, dynamic> toMap() {
    return {
      'questionId': questionId,
      'type': 'audioRecord',
    };
  }

  static AnswerEntity fromMap(Map<String, dynamic> map) {
    return AudioRecordAnswer(
      questionId: map['questionId'],
    );
  }
}
