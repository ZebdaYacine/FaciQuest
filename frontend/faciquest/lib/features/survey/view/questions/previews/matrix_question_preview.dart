import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class MatrixQuestionPreview extends StatelessWidget {
  const MatrixQuestionPreview({
    required this.question,
    super.key,
  });
  final MatrixQuestion question;

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
            ...question.cols.map((_) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: question.useCheckbox
                      ? const Checkbox(
                          value: false,
                          onChanged: null,
                        )
                      : const Radio(
                          value: true,
                          groupValue: null,
                          onChanged: null,
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
