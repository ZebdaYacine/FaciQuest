part of '../answer_entity.dart';

class FileUploadAnswer extends AnswerEntity {
  const FileUploadAnswer({required super.questionId});

  @override
  TrinaCell get plutoCell => TrinaCell(value: null);

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'type': 'fileUpload',
    };
  }

  static AnswerEntity fromMap(Map<String, dynamic> map) {
    return FileUploadAnswer(
      questionId: map['questionId'],
    );
  }
}
