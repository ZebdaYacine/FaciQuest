part of '../question_entity.dart';

///

class CheckboxesQuestion extends QuestionEntity {
  const CheckboxesQuestion({
    required super.id,
    required super.title,
    required super.order,
    super.type = QuestionType.checkboxes,
    this.choices = const [''],
  });
  final List<String> choices;

  @override
  QuestionEntity copyWith({
    String? id,
    String? title,
    int? order,
    QuestionType? type,
    List<String>? choices,
  }) {
    return CheckboxesQuestion(
      id: id ?? this.id,
      title: title ?? this.title,
      order: order ?? this.order,
      choices: choices ?? this.choices,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return CheckboxesQuestion(
      id: map['id'],
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
  static CheckboxesQuestion copyFrom(QuestionEntity question) {
    return CheckboxesQuestion(
      id: question.id,
      title: question.title,
      order: question.order,
    );
  }
}
