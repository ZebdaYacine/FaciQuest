part of '../answer_entity.dart';

class DateTimeAnswer extends AnswerEntity {
  const DateTimeAnswer({
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


  static AnswerEntity fromMap(Map<String, dynamic> map) {
    return DateTimeAnswer(
      questionId: map['questionId'],
      value: map['value'],
    );
  }
}
