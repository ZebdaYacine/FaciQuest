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
      'type': 'shortAnswer',
      'value': value,
    };
  }

  @override
  List<Object?> get props => [super.props, value];

  @override
  PlutoCell get plutoCell => PlutoCell(
        value: value,
      );


  static AnswerEntity fromMap(Map<String, dynamic> map) {
    return ShortAnswerAnswer(
      questionId: map['questionId'],
      value: map['value'],
    );
  }
}
