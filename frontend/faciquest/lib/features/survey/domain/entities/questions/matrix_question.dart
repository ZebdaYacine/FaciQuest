part of '../question_entity.dart';

///

class MatrixQuestion extends QuestionEntity {
  const MatrixQuestion({
    required super.title,
    this.rows = const [''],
    this.cols = const [''],
    this.useCheckbox = false,
  });
  final List<String> rows;
  final List<String> cols;
  final bool useCheckbox;

  @override
  QuestionEntity copyWith({
    String? title,
    List<String>? rows,
    List<String>? cols,
    bool? useCheckbox,
  }) {
    return MatrixQuestion(
      title: title ?? this.title,
      rows: rows ?? this.rows,
      cols: cols ?? this.cols,
      useCheckbox: useCheckbox ?? this.useCheckbox,
    );
  }

  @override
  QuestionEntity fromMap(Map<String, dynamic> map) {
    return MatrixQuestion(
      title: map['title'],
      rows: List<String>.from(map['rows']),
      cols: List<String>.from(map['cols']),
      useCheckbox: map['useCheckbox'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'rows': rows,
      'cols': cols,
      'useCheckbox': useCheckbox
    };
  }

  @override
  List<Object?> get props => [title, rows, useCheckbox, cols];

  static MatrixQuestion copyFrom(QuestionEntity question) {
    return MatrixQuestion(title: question.title);
  }
}
