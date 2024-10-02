part of '../answer_entity.dart';

class NameAnswer extends AnswerEntity {
  const NameAnswer({
    required super.questionId,
    this.firstName,
    this.lastName,
    this.middleName,
  });

  final String? firstName;
  final String? lastName;
  final String? middleName;

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
    };
  }

  NameAnswer copyWith({
    String? firstName,
    String? lastName,
    String? middleName,
  }) {
    return NameAnswer(
      questionId: questionId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      middleName: middleName ?? this.middleName,
    );
  }

  @override
  List<Object?> get props => [super.props, firstName, lastName, middleName];

  @override
  PlutoCell get plutoCell => PlutoCell(
        value: '${firstName ?? ''} ${middleName ?? ''} ${lastName ?? ''}',
      );
}
