part of '../question_entity.dart';

class ShortAnswerQuestion extends QuestionEntity {
  const ShortAnswerQuestion({
    required super.id,
    required super.title,
    required super.order,
    super.type = QuestionType.shortAnswer,
    super.isRequired = false,
    this.maxLength = 255,
  });

  final int maxLength;

  @override
  QuestionEntity copyWith({
    String? id,
    int? order,
    String? titleLarge,
    QuestionType? type,
    String? headline6,
    String? title,
    bool? isRequired,
    int? maxLength,
  }) {
    return ShortAnswerQuestion(
      id: id ?? this.id,
      title: title ?? this.title,
      order: order ?? this.order,
      isRequired: isRequired ?? this.isRequired,
      maxLength: maxLength ?? this.maxLength,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return ShortAnswerQuestion(
      id: map['id'],
      title: map['title'],
      order: map['order'],
      maxLength: map['maxLength'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'maxLength': maxLength,
    };
  }

  @override
  List<Object?> get props => [super.props, maxLength];
  static ShortAnswerQuestion copyFrom(QuestionEntity question) {
    return ShortAnswerQuestion(
      id: question.id,
      title: question.title,
      order: question.order,
      isRequired: question.isRequired,
    );
  }
}
