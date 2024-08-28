part of '../question_entity.dart';

class ShortAnswerQuestion extends QuestionEntity {
  ShortAnswerQuestion({
    required super.title,
    required super.order,
    super.type = QuestionType.shortAnswer,
    this.maxLength = 255,
  });

  final int maxLength;

  @override
  QuestionEntity copyWith({
    String? titleLarge,
    QuestionType? type,
    String? headline6,
    String? title,
    int? maxLength,
  }) {
    return ShortAnswerQuestion(
      title: title ?? this.title,
      order: order ?? this.order,
      maxLength: maxLength ?? this.maxLength,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return ShortAnswerQuestion(
      title: map['title'],
      order: map['order'],
      maxLength: map['maxLength'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'maxLength': maxLength,
      'type': type.name,
    };
  }

  @override
  List<Object?> get props => [title, maxLength];
  static ShortAnswerQuestion copyFrom(QuestionEntity question) {
    return ShortAnswerQuestion(
      title: question.title,
      order: question.order,
    );
  }
}
