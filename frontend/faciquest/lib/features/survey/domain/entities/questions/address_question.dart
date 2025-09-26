part of '../question_entity.dart';

class AddressQuestion extends QuestionEntity {
  const AddressQuestion({
    required super.id,
    required super.title,
    required super.order,
    super.isRequired = false,
    super.type = QuestionType.address,
    this.streetAddress1Label = 'Address',
    this.streetAddress1Hint,
    this.showStreetAddress1 = true,
    this.streetAddress2Label = 'Address 2',
    this.streetAddress2Hint,
    this.showStreetAddress2 = false,
    this.cityLabel = 'City',
    this.cityHint,
    this.showCity = false,
    this.stateLabel = 'State',
    this.stateHint,
    this.showState = false,
    this.showStatesAsDropdown = false,
    this.postalCodeLabel = 'Zip Code',
    this.postalCodeHint,
    this.showPostalCode = false,
    this.countryLabel = 'Country',
    this.countryHint,
    this.showCountry = false,
  });

  final String streetAddress1Label;
  final String? streetAddress1Hint;
  final bool showStreetAddress1;

  //
  final String streetAddress2Label;
  final String? streetAddress2Hint;
  final bool showStreetAddress2;

  // City/Town
  final String cityLabel;
  final String? cityHint;
  final bool showCity;
  // State/Province
  final String stateLabel;
  final String? stateHint;
  final bool showState;
  final bool showStatesAsDropdown;

  // ZIP/Postal code
  final String postalCodeLabel;
  final String? postalCodeHint;
  final bool showPostalCode;

  // Country
  final String countryLabel;
  final String? countryHint;
  final bool showCountry;
  @override
  List<Object?> get props => [
        ...super.props,
        streetAddress1Label,
        streetAddress1Hint,
        showStreetAddress1,
        streetAddress2Label,
        streetAddress2Hint,
        showStreetAddress2,
        cityLabel,
        cityHint,
        showCity,
        stateLabel,
        stateHint,
        showState,
        showStatesAsDropdown,
        postalCodeLabel,
        postalCodeHint,
        showPostalCode,
        countryLabel,
        countryHint,
        showCountry,
      ];
  @override
  QuestionEntity copyWith({
    String? id,
    bool? isRequired,
    String? title,
    int? order,
    QuestionType? type,
    String? streetAddress1Label,
    String? streetAddress1Hint,
    bool? showStreetAddress1,
    String? streetAddress2Label,
    String? streetAddress2Hint,
    bool? showStreetAddress2,
    String? cityLabel,
    String? cityHint,
    bool? showCity,
    String? stateLabel,
    String? stateHint,
    bool? showState,
    bool? showStatesAsDropdown,
    String? postalCodeLabel,
    String? postalCodeHint,
    bool? showPostalCode,
    String? countryLabel,
    String? countryHint,
    bool? showCountry,
  }) {
    return AddressQuestion(
      id: id ?? this.id,
      title: title ?? this.title,
      order: order ?? this.order,
      isRequired: isRequired ?? this.isRequired,
      streetAddress1Label: streetAddress1Label ?? this.streetAddress1Label,
      streetAddress1Hint: streetAddress1Hint ?? this.streetAddress1Hint,
      showStreetAddress1: showStreetAddress1 ?? this.showStreetAddress1,
      streetAddress2Label: streetAddress2Label ?? this.streetAddress2Label,
      streetAddress2Hint: streetAddress2Hint ?? this.streetAddress2Hint,
      showStreetAddress2: showStreetAddress2 ?? this.showStreetAddress2,
      cityLabel: cityLabel ?? this.cityLabel,
      cityHint: cityHint ?? this.cityHint,
      showCity: showCity ?? this.showCity,
      stateLabel: stateLabel ?? this.stateLabel,
      stateHint: stateHint ?? this.stateHint,
      showState: showState ?? this.showState,
      showStatesAsDropdown: showStatesAsDropdown ?? this.showStatesAsDropdown,
      postalCodeLabel: postalCodeLabel ?? this.postalCodeLabel,
      postalCodeHint: postalCodeHint ?? this.postalCodeHint,
      showPostalCode: showPostalCode ?? this.showPostalCode,
      countryLabel: countryLabel ?? this.countryLabel,
      countryHint: countryHint ?? this.countryHint,
      showCountry: showCountry ?? this.showCountry,
      type: type ?? this.type,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return AddressQuestion(
      id: map['id'],
      title: map['title'],
      order: map['order'],
      streetAddress1Label: map['streetAddress1Label'],
      streetAddress1Hint: map['streetAddress1Hint'],
      showStreetAddress1: map['showStreetAddress1'] ?? true,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'streetAddress1Label': streetAddress1Label,
      if (streetAddress1Hint != null) 'streetAddress1Hint': streetAddress1Hint,
      'showStreetAddress1': showStreetAddress1,
      'streetAddress2Label': streetAddress2Label,
      if (streetAddress2Hint != null) 'streetAddress2Hint': streetAddress2Hint,
      'showStreetAddress2': showStreetAddress2,
      'cityLabel': cityLabel,
      if (cityHint != null) 'cityHint': cityHint,
      'showCity': showCity,
      'stateLabel': stateLabel,
      if (stateHint != null) 'stateHint': stateHint,
      'showState': showState,
      'showStatesAsDropdown': showStatesAsDropdown,
      'postalCodeLabel': postalCodeLabel,
      if (postalCodeHint != null) 'postalCodeHint': postalCodeHint,
      'showPostalCode': showPostalCode,
      'countryLabel': countryLabel,
      if (countryHint != null) 'countryHint': countryHint,
      'showCountry': showCountry,
    };
  }

  static AddressQuestion copyFrom(QuestionEntity question) {
    return AddressQuestion(
      id: question.id,
      title: question.title,
      order: question.order,
    );
  }
}
