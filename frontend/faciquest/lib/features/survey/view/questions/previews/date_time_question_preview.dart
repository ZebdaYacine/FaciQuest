import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class DateTimeQuestionPreview extends StatefulWidget {
  const DateTimeQuestionPreview({
    required this.question,
    required this.answer,
    required this.onAnswerChanged,
    super.key,
  });
  final DateTimeQuestion question;
  final DateTimeAnswer? answer;
  final ValueChanged<DateTimeAnswer>? onAnswerChanged;

  @override
  State<DateTimeQuestionPreview> createState() =>
      _DateTimeQuestionPreviewState();
}

class _DateTimeQuestionPreviewState extends State<DateTimeQuestionPreview> {
  late final controller = TextEditingController(text: widget.answer?.value);
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          controller.text = DateFormat('dd/MM/yyyy').format(date);
        }
      },
      readOnly: true,
      onChanged: (value) {
        widget.onAnswerChanged?.call(
          DateTimeAnswer(
            questionId: widget.question.id,
            value: value,
          ),
        );
      },
      decoration: const InputDecoration(
          // hintText: question.hint,
          ),
    );
  }
}
