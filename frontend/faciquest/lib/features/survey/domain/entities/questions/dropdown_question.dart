part of '../question_entity.dart';

class DropdownQuestion extends QuestionEntity {
  const DropdownQuestion({
    required super.title,
    super.type = QuestionType.dropdown,
    this.choices = const [''],
  });
  final List<String> choices;

  @override
  QuestionEntity copyWith({
    String? title,
    QuestionType? type,
    List<String>? choices,
  }) {
    return DropdownQuestion(
      title: title ?? this.title,
      choices: choices ?? this.choices,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return DropdownQuestion(
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

  static DropdownQuestion copyFrom(QuestionEntity question) {
    return DropdownQuestion(title: question.title);
  }
}
