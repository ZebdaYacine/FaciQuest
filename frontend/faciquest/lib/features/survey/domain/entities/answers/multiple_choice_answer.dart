part of '../answer_entity.dart';

/// Multiple Choice is a simple closed-ended question type that lets
/// respondents select a single answer from a defined list of choices.
class MultipleChoiceAnswer extends AnswerEntity {
  const MultipleChoiceAnswer({
    required super.questionId,
    required this.selectedChoice,
  });

  final String selectedChoice;

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'selectedChoice': selectedChoice,
    };
  }

  @override
  List<Object?> get props {
    return [...super.props, selectedChoice];
  }

  @override
  PlutoCell get plutoCell => PlutoCell(
        value: selectedChoice,
      );

  static AnswerEntity fromMap(Map<String, dynamic> map) {
    return MultipleChoiceAnswer(
      questionId: map['questionId'],
      selectedChoice: map['selectedChoice'],
    );
  }
}
