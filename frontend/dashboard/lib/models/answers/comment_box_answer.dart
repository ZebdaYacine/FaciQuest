part of '../answer_entity.dart';

class CommentBoxAnswer extends AnswerEntity {
  const CommentBoxAnswer({
    required super.questionId,
    required this.value,
  });

  final String value;

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'type': 'commentBox',
      'value': value,
    };
  }

  @override
  List<Object?> get props => [super.props, value];

  @override
  TrinaCell get plutoCell => TrinaCell(
        value: value,
      );

  static AnswerEntity fromMap(Map<String, dynamic> map) {
    return CommentBoxAnswer(
      questionId: map['questionId'],
      value: map['value'],
    );
  }
}
