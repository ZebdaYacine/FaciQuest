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
      'questionId': questionId,
      'selectedOptions': selectedChoices.toList(),
    };
  }

  @override
  List<Object?> get props => [super.props, selectedChoices];
}
