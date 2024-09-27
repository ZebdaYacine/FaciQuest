part of '../answer_entity.dart';

class ShortAnswerAnswer extends AnswerEntity {
  const ShortAnswerAnswer({
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
}
