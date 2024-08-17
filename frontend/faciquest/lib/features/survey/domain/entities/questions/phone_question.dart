part of '../question_entity.dart';

class PhoneQuestion extends QuestionEntity {
  PhoneQuestion({
    required super.title,
    super.type = QuestionType.phoneNumber,
    this.phoneLabel = 'Phone Number',
    this.phoneHint,
    this.showPhone = true,
  });

  final String phoneLabel;
  final String? phoneHint;
  final bool showPhone;

  @override
  QuestionEntity copyWith({
    String? title,
    QuestionType? type,
    String? phoneLabel,
    String? phoneHint,
    bool? showPhone,
  }) {
    return PhoneQuestion(
      title: title ?? this.title,
      phoneLabel: phoneLabel ?? this.phoneLabel,
      phoneHint: phoneHint ?? this.phoneHint,
      showPhone: showPhone ?? this.showPhone,
    );
  }

 static QuestionEntity fromMap(Map<String, dynamic> map) {
    return PhoneQuestion(
      title: map['title'],
      phoneLabel: map['phoneLabel'],
      phoneHint: map['phoneHint'],
      showPhone: map['showPhone'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'phoneHint': phoneHint,
      'phoneLabel': phoneLabel,
      'showPhone': showPhone,
      'type': type.name,
    };
  }

  static PhoneQuestion copyFrom(QuestionEntity question) {
    return PhoneQuestion(title: question.title);
  }
}
