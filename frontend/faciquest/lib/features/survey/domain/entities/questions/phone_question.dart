part of '../question_entity.dart';

class PhoneQuestion extends QuestionEntity {
  const PhoneQuestion({
    required super.id,
    required super.title,
    required super.order,
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
    String? id,
    String? title,
    int? order,
    QuestionType? type,
    String? phoneLabel,
    String? phoneHint,
    bool? showPhone,
  }) {
    return PhoneQuestion(
      id: id ?? this.id,
      title: title ?? this.title,
      order: order ?? this.order,
      phoneLabel: phoneLabel ?? this.phoneLabel,
      phoneHint: phoneHint ?? this.phoneHint,
      showPhone: showPhone ?? this.showPhone,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return PhoneQuestion(
      id: map['id'],
      title: map['title'],
      order: map['order'],
      phoneLabel: map['phoneLabel'],
      phoneHint: map['phoneHint'],
      showPhone: map['showPhone'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'phoneHint': phoneHint,
      'phoneLabel': phoneLabel,
      'showPhone': showPhone,
    };
  }

  static PhoneQuestion copyFrom(QuestionEntity question) {
    return PhoneQuestion(
      id: question.id,
      title: question.title,
      order: question.order,
    );
  }
}
