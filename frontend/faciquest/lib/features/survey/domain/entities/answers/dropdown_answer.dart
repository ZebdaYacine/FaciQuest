part of '../answer_entity.dart';

class DropdownAnswer extends AnswerEntity {
  const DropdownAnswer({
    required super.questionId,
    this.selectedChoice,
  });

  final String? selectedChoice;

  @override
  List<Object?> get props => [super.props, selectedChoice];

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'selectedChoice': selectedChoice,
    };
  }

  @override
  PlutoCell get plutoCell => PlutoCell(
        value: selectedChoice,
      );

  static AnswerEntity fromMap(Map<String, dynamic> map) {
    return DropdownAnswer(
      questionId: map['questionId'],
      selectedChoice: map['selectedChoice'],
    );
  }
}
