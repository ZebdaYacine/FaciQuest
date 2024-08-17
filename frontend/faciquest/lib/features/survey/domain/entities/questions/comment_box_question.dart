part of '../question_entity.dart';

class CommentBoxQuestion extends QuestionEntity {
  CommentBoxQuestion({
    required super.title,
    super.type = QuestionType.commentBox,
    this.maxLength = 500,
    this.isRequired = false,
    this.maxLines = 5,
  });

  final int maxLength;
  final bool isRequired;
  final int maxLines;

  @override
  QuestionEntity copyWith({
    String? title,
    QuestionType? type,
    int? maxLength,
    bool? isRequired,
    int? maxLines,
  }) {
    return CommentBoxQuestion(
      title: title ?? this.title,
      maxLength: maxLength ?? this.maxLength,
      isRequired: isRequired ?? this.isRequired,
      maxLines: maxLines ?? this.maxLines,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return CommentBoxQuestion(
      title: map['title'],
      maxLength: map['maxLength'],
      isRequired: map['isRequired'],
      maxLines: map['maxLines'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'maxLength': maxLength,
      'isRequired': isRequired,
      'maxLines': maxLines,
      'type': type.name,
    };
  }

  static CommentBoxQuestion copyFrom(QuestionEntity question) {
    return CommentBoxQuestion(title: question.title);
  }
}
