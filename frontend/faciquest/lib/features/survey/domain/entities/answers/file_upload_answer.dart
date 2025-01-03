part of '../answer_entity.dart';

class FileUploadAnswer extends AnswerEntity {
  const FileUploadAnswer({required super.questionId});

  @override
  PlutoCell get plutoCell => PlutoCell(value: null);

  static AnswerEntity fromMap(Map<String, dynamic> map) {
    return FileUploadAnswer(
      questionId: map['questionId'],
    );
  }
}
