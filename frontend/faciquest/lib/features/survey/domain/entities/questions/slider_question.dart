part of '../question_entity.dart';

class SliderQuestion extends QuestionEntity {
  const SliderQuestion({
    required super.title,
    required super.order,
    super.type = QuestionType.slider,
    this.min = 0,
    this.max = 100,
  });
  final int min;
  final int max;

  @override
  QuestionEntity copyWith({
    String? title,
    int? order,
    QuestionType? type,
    int? min,
    int? max,
  }) {
    return SliderQuestion(
      title: title ?? this.title,
      order: order ?? this.order,
      min: min ?? this.min,
      max: max ?? this.max,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return SliderQuestion(
      title: map['title'],
      order: map['order'],
      min: map['min'],
      max: map['max'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'min': min,
      'max': max,
    };
  }

  @override
  List<Object?> get props => [title, min, max];

  static SliderQuestion copyFrom(QuestionEntity question) {
    return SliderQuestion(
      title: question.title,
      order: question.order,
    );
  }
}
