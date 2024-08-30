part of '../question_entity.dart';

class TextQuestion extends QuestionEntity {
  const TextQuestion({
    required super.title,
    required super.order,
    super.type = QuestionType.text,
  });

  @override
  QuestionEntity copyWith({
    String? title,
    int? order,
    QuestionType? type,
  }) {
    return TextQuestion(
      title: title ?? this.title,
      order: order ?? this.order,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return TextQuestion(
      title: map['title'],
      order: map['order'],
    );
  }

  static TextQuestion copyFrom(QuestionEntity question) {
    return TextQuestion(
      title: question.title,
      order: question.order,
    );
  }
}
