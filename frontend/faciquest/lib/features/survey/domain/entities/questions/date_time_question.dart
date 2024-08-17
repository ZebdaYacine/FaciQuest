part of '../question_entity.dart';

class DateTimeQuestion extends QuestionEntity {
  DateTimeQuestion({
    required super.title,
    this.collectDateInfo = true,
    this.collectTimeInfo = false,
  });
  final bool collectDateInfo;
  final bool collectTimeInfo;

  @override
  QuestionEntity copyWith(
      {String? title, bool? collectDateInfo, bool? collectTimeInfo}) {
    return DateTimeQuestion(
        title: title ?? this.title,
        collectDateInfo: collectDateInfo ?? this.collectDateInfo,
        collectTimeInfo: collectTimeInfo ?? this.collectTimeInfo);
  }

  @override
  QuestionEntity fromMap(Map<String, dynamic> map) {
    return DateTimeQuestion(
      title: map['title'],
      collectDateInfo: map['collectDateInfo'],
      collectTimeInfo: map['collectTimeInfo'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'collectDateInfo': collectDateInfo,
      'collectTimeInfo': collectTimeInfo
    };
  }

  @override
  List<Object?> get props => [title, collectDateInfo, collectTimeInfo];

  static DateTimeQuestion copyFrom(QuestionEntity question) {
    return DateTimeQuestion(title: question.title);
  }
}
