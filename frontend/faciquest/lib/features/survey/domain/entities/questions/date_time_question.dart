part of '../question_entity.dart';

class DateTimeQuestion extends QuestionEntity {
  const DateTimeQuestion({
    required super.id,
    required super.title,
    required super.order,
    super.type = QuestionType.dateTime,
    this.collectDateInfo = true,
    this.collectTimeInfo = false,
  });
  final bool collectDateInfo;
  final bool collectTimeInfo;

  @override
  QuestionEntity copyWith({
    String? title,
    int? order,
    QuestionType? type,
    bool? collectDateInfo,
    bool? collectTimeInfo,
  }) {
    return DateTimeQuestion(
        id: id,
        title: title ?? this.title,
        order: order ?? this.order,
        collectDateInfo: collectDateInfo ?? this.collectDateInfo,
        collectTimeInfo: collectTimeInfo ?? this.collectTimeInfo);
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return DateTimeQuestion(
      id: map['id'],
      title: map['title'],
      order: map['order'],
      collectDateInfo: map['collectDateInfo'],
      collectTimeInfo: map['collectTimeInfo'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'collectDateInfo': collectDateInfo,
      'collectTimeInfo': collectTimeInfo,
    };
  }

  @override
  List<Object?> get props => [title, collectDateInfo, collectTimeInfo];

  static DateTimeQuestion copyFrom(QuestionEntity question) {
    return DateTimeQuestion(
      id: question.id,
      title: question.title,
      order: question.order,
    );
  }
}
