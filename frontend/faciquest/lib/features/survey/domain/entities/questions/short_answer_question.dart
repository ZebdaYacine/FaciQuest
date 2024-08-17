part of '../question_entity.dart';

class ShortAnswerQuestion extends QuestionEntity {
  ShortAnswerQuestion({
    required super.title,
    this.maxLength = 255,
  });

  final int maxLength;

  @override
  QuestionEntity copyWith({
    String? title,
    int? maxLength,
  }) {
    return ShortAnswerQuestion(
      title: title ?? this.title,
      maxLength: maxLength ?? this.maxLength,
    );
  }

  @override
  QuestionEntity fromMap(Map<String, dynamic> map) {
    return ShortAnswerQuestion(
      title: map['title'],
      maxLength: map['maxLength'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{'title': title, 'maxLength': maxLength};
  }

  @override
  List<Object?> get props => [title, maxLength];
  static ShortAnswerQuestion copyFrom(QuestionEntity question) {
    return ShortAnswerQuestion(title: question.title);
  }
}
