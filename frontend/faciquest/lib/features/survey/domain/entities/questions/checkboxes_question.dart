part of '../question_entity.dart';

class CheckboxesQuestion extends QuestionEntity {
  const CheckboxesQuestion({
    required super.title,
    this.choices = const [],
  });
  final List<String> choices;

  @override
  QuestionEntity copyWith({
    String? title,
    List<String>? choices,
  }) {
    return CheckboxesQuestion(
      title: title ?? this.title,
      choices: choices ?? this.choices,
    );
  }

  @override
  QuestionEntity fromMap(Map<String, dynamic> map) {
    return CheckboxesQuestion(
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
