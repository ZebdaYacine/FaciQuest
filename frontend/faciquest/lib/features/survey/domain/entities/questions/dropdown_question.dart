part of '../question_entity.dart';

class DropdownQuestion extends QuestionEntity {
  const DropdownQuestion({
    required super.title,
    this.choices = const [],
  });
  final List<String> choices;

  @override
  QuestionEntity copyWith({
    String? title,
    List<String>? choices,
  }) {
    return DropdownQuestion(
      title: title ?? this.title,
      choices: choices ?? this.choices,
    );
  }

  @override
  QuestionEntity fromMap(Map<String, dynamic> map) {
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
    };
  }

  @override
  List<Object?> get props => [title, choices];
}
