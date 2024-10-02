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
      'value': value,
    };
  }

  @override
  List<Object?> get props => [super.props, value];

  @override
  PlutoCell get plutoCell => PlutoCell(
        value: value,
      );
}
