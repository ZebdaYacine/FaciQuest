part of '../question_entity.dart';

class EmailAddressQuestion extends QuestionEntity {
  const EmailAddressQuestion({
    required super.title,
    required super.order,
    super.type = QuestionType.emailAddress,
    this.emailAddressLabel = 'Email Address',
    this.emailAddressHint,
    this.showEmailAddress = true,
  });

  final String emailAddressLabel;
  final String? emailAddressHint;
  final bool showEmailAddress;

  @override
  QuestionEntity copyWith({
    String? title,
    int? order,
    QuestionType? type,
    String? emailAddressLabel,
    String? emailAddressHint,
    bool? showEmailAddress,
  }) {
    return EmailAddressQuestion(
      title: title ?? this.title,
      order: order ?? this.order,
      emailAddressLabel: emailAddressLabel ?? this.emailAddressLabel,
      emailAddressHint: emailAddressHint ?? this.emailAddressHint,
      showEmailAddress: showEmailAddress ?? this.showEmailAddress,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return EmailAddressQuestion(
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
      title: question.title,
      order: question.order,
    );
  }
}
