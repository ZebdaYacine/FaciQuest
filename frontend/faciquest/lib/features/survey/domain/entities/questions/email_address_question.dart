part of '../question_entity.dart';

class EmailAddressQuestion extends QuestionEntity {
  const EmailAddressQuestion({
    required super.id,
    required super.title,
    required super.order,
    super.type = QuestionType.emailAddress,
    this.emailAddressLabel = 'Email Address',
    this.emailAddressHint,
    this.showEmailAddress = true,
    super.isRequired = false,
  });

  final String emailAddressLabel;
  final String? emailAddressHint;
  final bool showEmailAddress;

  @override
  QuestionEntity copyWith({
    String? id,
    String? title,
    int? order,
    QuestionType? type,
    String? emailAddressLabel,
    String? emailAddressHint,
    bool? showEmailAddress,
    bool? isRequired,
  }) {
    return EmailAddressQuestion(
      id: id ?? this.id,
      title: title ?? this.title,
      order: order ?? this.order,
      emailAddressLabel: emailAddressLabel ?? this.emailAddressLabel,
      emailAddressHint: emailAddressHint ?? this.emailAddressHint,
      showEmailAddress: showEmailAddress ?? this.showEmailAddress,
      isRequired: isRequired ?? this.isRequired,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return EmailAddressQuestion(
      id: map['id'],
      title: map['title'],
      order: map['order'],
      emailAddressLabel: map['emailAddressLabel'],
      emailAddressHint: map['emailAddressHint'],
      showEmailAddress: map['showEmailAddress'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'emailAddressHint': emailAddressHint,
      'emailAddressLabel': emailAddressLabel,
      'showEmailAddress': showEmailAddress,
    };
  }

  static EmailAddressQuestion copyFrom(QuestionEntity question) {
    return EmailAddressQuestion(
      id: question.id,
      title: question.title,
      order: question.order,
    );
  }
}
