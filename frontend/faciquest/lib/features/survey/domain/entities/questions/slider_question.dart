part of '../question_entity.dart';

class SliderQuestion extends QuestionEntity {
  const SliderQuestion({
    required super.id,
    required super.title,
    required super.order,
    super.type = QuestionType.slider,
    super.isRequired = false,
    this.min = 0,
    this.max = 100,
  });
  final double min;
  final double max;

  @override
  QuestionEntity copyWith({
    String? id,
    String? title,
    int? order,
    QuestionType? type,
    bool? isRequired,
    double? min,
    double? max,
  }) {
    return SliderQuestion(
      id: id ?? this.id,
      title: title ?? this.title,
      order: order ?? this.order,
      isRequired: isRequired ?? this.isRequired,
      min: min ?? this.min,
      max: max ?? this.max,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return SliderQuestion(
      id: map['id'],
      title: map['title'],
      order: (map['order'] as num).toInt(),
      min: (map['min'] as num).toDouble(),
      max: (map['max'] as num).toDouble(),
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
  List<Object?> get props => [super.props, min, max];

  static SliderQuestion copyFrom(QuestionEntity question, {bool isRequired = false}) {
    return SliderQuestion(
      id: question.id,
      title: question.title,
      order: question.order,
      isRequired: isRequired,
    );
  }

  @override
  bool get isValid => super.isValid && min < max;
}
