part of '../question_entity.dart';

///

class CheckboxesQuestion extends QuestionEntity {
  const CheckboxesQuestion({
    required super.title,
    super.type = QuestionType.checkboxes,
    this.choices = const [''],
  });
  final List<String> choices;

  @override
  QuestionEntity copyWith({
    String? title,
    QuestionType? type,
    List<String>? choices,
  }) {
    return CheckboxesQuestion(
      title: title ?? this.title,
      choices: choices ?? this.choices,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
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
      'type': type.name,
    };
  }

  @override
  List<Object?> get props => [title, choices];
  static CheckboxesQuestion copyFrom(QuestionEntity question) {
    return CheckboxesQuestion(title: question.title);
  }
}
