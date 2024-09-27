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
}
