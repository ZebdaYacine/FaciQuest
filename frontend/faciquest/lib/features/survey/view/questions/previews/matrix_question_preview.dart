import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class MatrixQuestionPreview extends StatelessWidget {
  const MatrixQuestionPreview({
    required this.question,
    required this.answer,
    required this.onAnswerChanged,
    super.key,
  });
  final MatrixQuestion question;
  final MatrixAnswer? answer;
  final ValueChanged<MatrixAnswer>? onAnswerChanged;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      children: _buildMatrix(),
    );
  }

  List<TableRow> _buildMatrix() {
    List<TableRow> tableRows = [];

    // Add column headers
    tableRows.add(
      TableRow(
        children: [
          Container(), // Empty top-left corner cell
          ...question.cols.map(
            (col) => Center(
              child: Text(
                col,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );

    // Add rows with question options
    for (String row in question.rows) {
      tableRows.add(
        TableRow(
          decoration: const BoxDecoration(),
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  row,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ...question.cols.map((col) {
              bool isSelected = answer?.getValue(row, col) ?? false;
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: question.useCheckbox
                      ? Checkbox(
                          value: isSelected,
                          onChanged: (bool? value) {
                            if (value != null && onAnswerChanged != null) {
                              final newAnswer = (answer ??
                                      MatrixAnswer.empty(
                                        questionId: question.id,
                                        rows: question.rows,
                                        cols: question.cols,
                                        useCheckboxes: true,
                                      ))
                                  .setValue(row, col, value);
                              onAnswerChanged!(newAnswer);
                            }
                          },
                        )
                      : Radio<String>(
                          value: col,
                          groupValue: answer?.getSelectedColumn(row),
                          onChanged: (String? value) {
                            if (value != null && onAnswerChanged != null) {
                              final newAnswer = (answer ??
                                      MatrixAnswer.empty(
                                        questionId: question.id,
                                        rows: question.rows,
                                        cols: question.cols,
                                        useCheckboxes: false,
                                      ))
                                  .setValue(row, col, true);
                              onAnswerChanged!(newAnswer);
                            }
                          },
                        ),
                ),
              );
            }),
          ],
        ),
      );
    }

    return tableRows;
  }
}
