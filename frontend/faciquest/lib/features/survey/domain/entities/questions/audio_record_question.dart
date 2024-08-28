part of '../question_entity.dart';

class AudioRecordQuestion extends QuestionEntity {
  const AudioRecordQuestion({
    required super.title,
    required super.order,
    super.type = QuestionType.audioRecord,
  });

  @override
  QuestionEntity copyWith({
    String? title,
    int? order,
    QuestionType? type,
  }) {
    return AudioRecordQuestion(
      title: title ?? this.title,
      order: order ?? this.order,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return AudioRecordQuestion(
      title: map['title'],
      order: map['order'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
    };
  }

  static AudioRecordQuestion copyFrom(QuestionEntity question) {
    return AudioRecordQuestion(
      title: question.title,
      order: question.order,
    );
  }
}
