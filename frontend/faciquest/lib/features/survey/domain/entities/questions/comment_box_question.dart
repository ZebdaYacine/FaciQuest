part of '../question_entity.dart';

class CommentBoxQuestion extends QuestionEntity {
  const CommentBoxQuestion({
    required super.id,

    required super.title,
    required super.order,
    super.type = QuestionType.commentBox,
    this.maxLength = 500,
    this.maxLines = 5,
  });

  final int maxLength;
  final int maxLines;

  @override
  QuestionEntity copyWith({
    String? id,
    String? title,
    int? order,
    QuestionType? type,
    int? maxLength,
    int? maxLines,
  }) {
    return CommentBoxQuestion(
      id: id ?? this.id,
      title: title ?? this.title,
      order: order ?? this.order,
      maxLength: maxLength ?? this.maxLength,
      maxLines: maxLines ?? this.maxLines,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return CommentBoxQuestion(
      id: map['id'],
      title: map['title'],
      order: map['order'],
      maxLength: map['maxLength'],
      maxLines: map['maxLines'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'maxLength': maxLength,
      'maxLines': maxLines,
    };
  }

  static CommentBoxQuestion copyFrom(QuestionEntity question) {
    return CommentBoxQuestion(
      id: question.id,
      title: question.title,
      order: question.order,
    );
  }
}
