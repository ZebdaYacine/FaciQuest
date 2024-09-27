part of '../answer_entity.dart';

class MatrixAnswer extends AnswerEntity {
  final Map<String, Map<String, bool>> values;
  final bool multipleSelect;

  const MatrixAnswer({
    required super.questionId,
    required this.values,
    required this.multipleSelect,
  });

  factory MatrixAnswer.empty({
    required String questionId,
    required List<String> rows,
    required List<String> cols,
    required bool useCheckboxes,
  }) {
    return MatrixAnswer(
      questionId: questionId,
      values: {
        for (var row in rows) row: {for (var col in cols) col: false}
      },
      multipleSelect: useCheckboxes,
    );
  }

  MatrixAnswer copyWith({Map<String, Map<String, bool>>? values}) {
    return MatrixAnswer(
      questionId: questionId,
      values: values ?? this.values,
      multipleSelect: multipleSelect,
    );
  }

  bool getValue(String row, String col) => values[row]?[col] ?? false;

  MatrixAnswer setValue(String row, String col, bool value) {
    final newValues = Map<String, Map<String, bool>>.from(values);
    newValues[row] = Map<String, bool>.from(newValues[row] ?? {});

    if (!multipleSelect) {
      // For radio buttons (single answer per row)
      for (var key in newValues[row]!.keys) {
        newValues[row]![key] = false;
      }
      newValues[row]![col] = true; // Always set to true for radio buttons
    } else {
      // For checkboxes (multiple answers per row)
      newValues[row]![col] = value;
    }

    return copyWith(values: newValues);
  }

  // Helper method to get the selected column for a single-answer row
  String? getSelectedColumn(String row) {
    if (multipleSelect) return null;
    return values[row]
        ?.entries
        .firstWhere((entry) => entry.value,
            orElse: () => const MapEntry('', false))
        .key;
  }
}
