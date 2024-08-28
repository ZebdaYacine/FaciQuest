part of '../question_entity.dart';

///

class MatrixQuestion extends QuestionEntity {
  const MatrixQuestion({
    required super.title,
    required super.order,
    super.type = QuestionType.matrix,
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
    int? order,
    QuestionType? type,
    List<String>? rows,
    List<String>? cols,
    bool? useCheckbox,
  }) {
    return MatrixQuestion(
      title: title ?? this.title,
      order: order ?? this.order,
      rows: rows ?? this.rows,
      cols: cols ?? this.cols,
      useCheckbox: useCheckbox ?? this.useCheckbox,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return MatrixQuestion(
      title: map['title'],
      order: map['order'],
      rows: List<String>.from(map['rows']),
      cols: List<String>.from(map['cols']),
      useCheckbox: map['useCheckbox'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'rows': rows,
      'cols': cols,
      'useCheckbox': useCheckbox,
    };
  }

  @override
  List<Object?> get props => [title, rows, useCheckbox, cols];

  static MatrixQuestion copyFrom(QuestionEntity question) {
    return MatrixQuestion(
      title: question.title,
      order: question.order,
    );
  }
}
