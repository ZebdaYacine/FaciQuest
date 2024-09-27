part of '../question_entity.dart';

class AudioRecordQuestion extends QuestionEntity {
  const AudioRecordQuestion({
    required super.id,
    required super.title,
    required super.order,
    super.type = QuestionType.audioRecord,
  });

  @override
  QuestionEntity copyWith({
    String? id,
    String? title,
    int? order,
    QuestionType? type,
  }) {
    return AudioRecordQuestion(
      id: id ?? this.id,
      title: title ?? this.title,
      order: order ?? this.order,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return AudioRecordQuestion(
      id: map['id'],
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
      id: question.id,
      title: question.title,
      order: question.order,
    );
  }
}
