part of '../question_entity.dart';

///

class MatrixQuestion extends QuestionEntity {
  const MatrixQuestion({
    required super.id,
    required super.title,
    required super.order,
    super.type = QuestionType.matrix,
    this.rows = const [''],
    this.cols = const [''],
    this.useCheckbox = false,
    super.isRequired = false,
  });
  final List<String> rows;
  final List<String> cols;
  final bool useCheckbox;

  @override
  bool get isValid =>
      super.isValid &&
      rows.isNotEmpty &&
      cols.isNotEmpty &&
      rows.every((e) => e.isNotEmpty) &&
      cols.every((e) => e.isNotEmpty);

  @override
  QuestionEntity copyWith({
    String? id,
    String? title,
    int? order,
    QuestionType? type,
    List<String>? rows,
    List<String>? cols,
    bool? useCheckbox,
    bool? isRequired,
  }) {
    return MatrixQuestion(
      id: id ?? this.id,
      title: title ?? this.title,
      order: order ?? this.order,
      rows: rows ?? this.rows,
      cols: cols ?? this.cols,
      useCheckbox: useCheckbox ?? this.useCheckbox,
      isRequired: isRequired ?? this.isRequired,
    );
  }

  static QuestionEntity fromMap(Map<String, dynamic> map) {
    return MatrixQuestion(
      id: map['id'],
      title: map['title'],
      order: map['order'],
      rows: List<String>.from(map['rows']),
      cols: List<String>.from(map['cols']),
      useCheckbox: map['useCheckbox'],
      isRequired: map['isRequired'],
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
  List<Object?> get props => [...super.props, rows, useCheckbox, cols];

  static MatrixQuestion copyFrom(QuestionEntity question) {
    return MatrixQuestion(
      id: question.id,
      title: question.title,
      order: question.order,
    );
  }
}
