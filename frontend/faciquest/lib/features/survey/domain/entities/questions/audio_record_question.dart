part of '../question_entity.dart';

class AudioRecordQuestion extends QuestionEntity {
  AudioRecordQuestion({
    required super.title,
    super.type = QuestionType.audioRecord,
  });

  @override
  QuestionEntity copyWith({
    String? title,
    QuestionType? type,
  }) {
    return AudioRecordQuestion(
      title: title ?? this.title,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return AudioRecordQuestion(
      title: map['title'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'type': type.name,
    };
  }

  static AudioRecordQuestion copyFrom(QuestionEntity question) {
    return AudioRecordQuestion(title: question.title);
  }
}
