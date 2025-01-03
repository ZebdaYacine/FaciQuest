part of '../answer_entity.dart';

class SliderAnswer extends AnswerEntity {
  const SliderAnswer({
    required super.questionId,
    required this.value,
  });

  final double value;

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'type': 'slider',
      'value': value,
    };
  }

  @override
  List<Object?> get props => [super.props, value];

  @override
  PlutoCell get plutoCell => PlutoCell(
        value: value.toString(),
      );


  static AnswerEntity fromMap(Map<String, dynamic> map) {
    return SliderAnswer(
      questionId: map['questionId'],
      value: double.parse(map['value']),
    );
  }
}
