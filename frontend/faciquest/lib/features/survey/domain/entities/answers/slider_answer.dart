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
      'value': value,
    };
  }

  @override
  List<Object?> get props => [super.props, value];
}
