part of '../question_entity.dart';

class DropdownQuestion extends QuestionEntity {
  const DropdownQuestion({
    required super.title,
    required super.order,
    super.type = QuestionType.dropdown,
    this.choices = const [''],
  });
  final List<String> choices;

  @override
  QuestionEntity copyWith({
    String? title,
    int? order,
    QuestionType? type,
    List<String>? choices,
  }) {
    return DropdownQuestion(
      title: title ?? this.title,
      order: order ?? this.order,
      choices: choices ?? this.choices,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return DropdownQuestion(
      title: map['title'],
      order: map['order'],
      choices: List<String>.from(map['choices']),
    );
  }

  @override
  bool get isValid =>
      super.isValid &&
      choices.isNotEmpty &&
      choices.every(
        (element) => element.isNotEmpty,
      );

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'choices': choices,
    };
  }

  @override
  List<Object?> get props => [title, choices];

  static DropdownQuestion copyFrom(QuestionEntity question) {
    return DropdownQuestion(
      title: question.title,
      order: question.order,
    );
  }
}
