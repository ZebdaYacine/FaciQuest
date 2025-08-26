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
      'type': 'nameType',
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
  TrinaCell get plutoCell => TrinaCell(
        value: '${firstName ?? ''} ${middleName ?? ''} ${lastName ?? ''}',
      );

  static AnswerEntity fromMap(Map<String, dynamic> map) {
    return NameAnswer(
      questionId: map['questionId'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      middleName: map['middleName'],
    );
  }
}
