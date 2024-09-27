part of '../question_entity.dart';

class NameQuestion extends QuestionEntity {
  const NameQuestion({
    required super.id,
    required super.title,
    required super.order,
    super.type = QuestionType.nameType,
    this.firstNameLabel = 'First Name',
    this.lastNameLabel = 'Last Name',
    this.firstNameHint,
    this.lastNameHint,
    this.middleNameLabel,
    this.middleNameHint,
    this.showFirstName = true,
    this.showLastName = true,
    this.showMiddleName = false,
  });

  final String firstNameLabel;
  final String lastNameLabel;
  final String? middleNameLabel;
  final String? firstNameHint;
  final String? lastNameHint;
  final String? middleNameHint;
  final bool showFirstName, showLastName, showMiddleName;

  @override
  QuestionEntity copyWith({
    String? id,
    String? title,
    int? order,
    QuestionType? type,
    String? firstNameLabel,
    String? lastNameLabel,
    String? firstNameHint,
    String? lastNameHint,
    String? middleNameLabel,
    String? middleNameHint,
    bool? showFirstName,
    bool? showLastName,
    bool? showMiddleName,
  }) {
    return NameQuestion(
      id: id ?? this.id,
      title: title ?? this.title,
      order: order ?? this.order,
      firstNameLabel: firstNameLabel ?? this.firstNameLabel,
      lastNameLabel: lastNameLabel ?? this.lastNameLabel,
      firstNameHint: firstNameHint ?? this.firstNameHint,
      lastNameHint: lastNameHint ?? this.lastNameHint,
      middleNameLabel: middleNameLabel ?? this.middleNameLabel,
      middleNameHint: middleNameHint ?? this.middleNameHint,
      showFirstName: showFirstName ?? this.showFirstName,
      showLastName: showLastName ?? this.showLastName,
      showMiddleName: showMiddleName ?? this.showMiddleName,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return NameQuestion(
      id: map['id'],
      title: map['title'],
      order: map['order'],
      firstNameLabel: map['firstNameLabel'],
      lastNameLabel: map['lastNameLabel'],
      firstNameHint: map['firstNameHint'],
      lastNameHint: map['lastNameHint'],
      middleNameLabel: map['middleNameLabel'],
      middleNameHint: map['middleNameHint'],
      showFirstName: map['showFirstName'],
      showLastName: map['showLastName'],
      showMiddleName: map['showMiddleName'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'firstNameLabel': firstNameLabel,
      'lastNameLabel': lastNameLabel,
      'firstNameHint': firstNameHint,
      'lastNameHint': lastNameHint,
      'middleNameLabel': middleNameLabel,
      'middleNameHint': middleNameHint,
      'showFirstName': showFirstName,
      'showLastName': showLastName,
      'showMiddleName': showMiddleName,
    };
  }

  static NameQuestion copyFrom(QuestionEntity question) {
    return NameQuestion(
      id: question.id,
      title: question.title,
      order: question.order,
    );
  }
}
