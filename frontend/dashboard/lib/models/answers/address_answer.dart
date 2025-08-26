part of '../answer_entity.dart';

class AddressAnswer extends AnswerEntity {
  final String? streetAddress1;
  final String? streetAddress2;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;
  const AddressAnswer({
    required super.questionId,
    this.streetAddress1,
    this.streetAddress2,
    this.city,
    this.state,
    this.postalCode,
    this.country,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'type': 'address',
      'streetAddress1': streetAddress1,
      'streetAddress2': streetAddress2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
    };
  }

  @override
  List<Object?> get props => [
        ...super.props,
        streetAddress1,
        streetAddress2,
        city,
        state,
        postalCode,
        country,
      ];

  AddressAnswer copyWith({
    String? streetAddress1,
    String? streetAddress2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
  }) {
    return AddressAnswer(
      questionId: questionId,
      streetAddress1: streetAddress1 ?? this.streetAddress1,
      streetAddress2: streetAddress2 ?? this.streetAddress2,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
    );
  }

  @override
  TrinaCell get plutoCell => TrinaCell(
        value:
            '${streetAddress1 ?? ''} ${streetAddress2 ?? ''} ${city ?? ''} ${state ?? ''} ${postalCode ?? ''} ${country ?? ''}',
      );

  static AnswerEntity fromMap(Map<String, dynamic> map) {
    return AddressAnswer(
      questionId: map['questionId'],
      streetAddress1: map['streetAddress1'],
      streetAddress2: map['streetAddress2'],
      city: map['city'],
      state: map['state'],
      postalCode: map['postalCode'],
      country: map['country'],
    );
  }
}
