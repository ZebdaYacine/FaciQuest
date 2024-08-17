part of '../question_entity.dart';

class TextQuestion extends QuestionEntity {
  TextQuestion({
    required super.title,
    super.type = QuestionType.text,
  });

  @override
  QuestionEntity copyWith({
    String? title,
    QuestionType? type,
  }) {
    return TextQuestion(
      title: title ?? this.title,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return TextQuestion(
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

  static TextQuestion copyFrom(QuestionEntity question) {
    return TextQuestion(title: question.title);
  }
}
