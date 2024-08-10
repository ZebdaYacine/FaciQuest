part of '../question_entity.dart';

class AudioRecordQuestion extends QuestionEntity {
  AudioRecordQuestion({
    required super.title,
  });

  @override
  QuestionEntity copyWith({String? title}) {
    return AudioRecordQuestion(
      title: title ?? this.title,
    );
  }

  @override
  QuestionEntity fromMap(Map<String, dynamic> map) {
    return AudioRecordQuestion(
      title: map['title'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
    };
  }
}
