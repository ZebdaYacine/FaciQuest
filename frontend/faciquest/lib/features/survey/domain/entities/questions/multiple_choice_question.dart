part of '../question_entity.dart';

/// Multiple Choice is a simple closed-ended question type that lets 
/// respondents select a single answer from a defined list of choices.
class MultipleChoiceQuestion extends QuestionEntity {
  const MultipleChoiceQuestion({
    required super.title,
    this.choices = const [''],
  });
  final List<String> choices;

  @override
  QuestionEntity copyWith({
    String? title,
    List<String>? choices,
  }) {
    return MultipleChoiceQuestion(
      title: title ?? this.title,
      choices: choices ?? this.choices,
    );
  }

  @override
  QuestionEntity fromMap(Map<String, dynamic> map) {
    return MultipleChoiceQuestion(
      title: map['title'],
      choices: List<String>.from(map['choices']),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'choices': choices,
    };
  }

  @override
  List<Object?> get props => [title, choices];
}
