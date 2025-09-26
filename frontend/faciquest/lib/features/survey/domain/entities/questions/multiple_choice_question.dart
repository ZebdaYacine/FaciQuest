part of '../question_entity.dart';

/// Multiple Choice is a simple closed-ended question type that lets
/// respondents select a single answer from a defined list of choices.
class MultipleChoiceQuestion extends QuestionEntity {
  const MultipleChoiceQuestion({
    required super.id,
    required super.title,
    required super.order,
    super.type = QuestionType.multipleChoice,
    super.isRequired = false,
    this.choices = const [''],
  });
  final List<String> choices;

  @override
  bool get isValid =>
      super.isValid &&
      choices.isNotEmpty &&
      choices.every(
        (element) => element.isNotEmpty,
      );

  @override
  QuestionEntity copyWith({
    String? id,
    String? title,
    int? order,
    QuestionType? type,
    bool? isRequired,
    List<String>? choices,
  }) {
    return MultipleChoiceQuestion(
      id: id ?? this.id,
      title: title ?? this.title,
      order: order ?? this.order,
      isRequired: isRequired ?? this.isRequired,
      choices: choices ?? this.choices,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return MultipleChoiceQuestion(
      id: map['id'] ?? '',
      title: map['title'],
      order: map['order'],
      choices: List<String>.from(map['choices']),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'choices': choices,
    };
  }

  @override
  List<Object?> get props => [...super.props, choices];
  static MultipleChoiceQuestion copyFrom(QuestionEntity question, {bool isRequired = false}) {
    return MultipleChoiceQuestion(
      id: question.id,
      title: question.title,
      order: question.order,
      isRequired: isRequired,
    );
  }
}
