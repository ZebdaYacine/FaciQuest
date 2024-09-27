part of '../answer_entity.dart';

class EmailAddressAnswer extends AnswerEntity {
  const EmailAddressAnswer({
    required super.questionId,
    required this.value,
  });

  final String value;

  @override
  List<Object?> get props => [...super.props, value];

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'value': value,
    };
  }
}
