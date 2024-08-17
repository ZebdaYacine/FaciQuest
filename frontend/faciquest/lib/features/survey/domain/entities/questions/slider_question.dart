part of '../question_entity.dart';

class SliderQuestion extends QuestionEntity {
  SliderQuestion({
    required super.title,
    this.min = 0,
    this.max = 100,
  });
  final int min;
  final int max;

  @override
  QuestionEntity copyWith({
    String? title,
    int? min,
    int? max,
  }) {
    return SliderQuestion(
      title: title ?? this.title,
      min: min ?? this.min,
      max: max ?? this.max,
    );
  }

  @override
  QuestionEntity fromMap(Map<String, dynamic> map) {
    return SliderQuestion(
      title: map['title'],
      min: map['min'],
      max: map['max'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'min': min,
      'max': max,
    };
  }

  @override
  List<Object?> get props => [title, min, max];

  static SliderQuestion copyFrom(QuestionEntity question) {
    return SliderQuestion(title: question.title);
  }
}
