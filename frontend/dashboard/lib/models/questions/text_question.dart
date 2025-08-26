part of '../question_entity.dart';

class TextQuestion extends QuestionEntity {
  const TextQuestion({
    required super.id,
    required super.title,
    required super.order,
    super.type = QuestionType.text,
  });

  @override
  QuestionEntity copyWith({
    String? id,
    String? title,
    int? order,
    QuestionType? type,
  }) {
    return TextQuestion(
      id: id ?? this.id,
      title: title ?? this.title,
      order: order ?? this.order,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return TextQuestion(
      id: map['id'],
      title: map['title'],
      order: map['order'],
    );
  }

  static TextQuestion copyFrom(QuestionEntity question) {
    return TextQuestion(
      id: question.id,
      title: question.title,
      order: question.order,
    );
  }
}
