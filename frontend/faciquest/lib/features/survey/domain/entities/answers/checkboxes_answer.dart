part of '../answer_entity.dart';

///

class CheckboxesAnswer extends AnswerEntity {
  const CheckboxesAnswer({
    required super.questionId,
    required this.selectedChoices,
  });

  final Set<String> selectedChoices;

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'selectedOptions': selectedChoices.toList(),
    };
  }

  @override
  List<Object?> get props => [super.props, selectedChoices];

  @override
  PlutoCell get plutoCell => PlutoCell(
        value: selectedChoices.toList().join(', '),
      );


  static AnswerEntity fromMap(Map<String, dynamic> map) {
    return CheckboxesAnswer(
      questionId: map['questionId'],
      selectedChoices: Set<String>.from(map['selectedOptions']),
    );
  }
}
