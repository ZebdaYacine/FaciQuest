import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';

class ShortAnswerQuestionBuilder extends StatefulWidget {
  final ShortAnswerQuestion question;
  final ValueChanged<QuestionEntity>? onChanged;
  const ShortAnswerQuestionBuilder({
    required this.question,
    this.onChanged,
    super.key,
  });

  @override
  State<ShortAnswerQuestionBuilder> createState() =>
      _ShortAnswerQuestionBuilderState();
}

class _ShortAnswerQuestionBuilderState extends State<ShortAnswerQuestionBuilder>
    with BuildFormMixin {
  onChange({
    int? maxLength,
  }) {
    widget.onChanged?.call(widget.question.copyWith(
      maxLength: maxLength,
    ));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Max length :'),
            AppSpacing.spacing_1.widthBox,
            Flexible(
              child: InputQty.int(
                initVal: widget.question.maxLength,
                onQtyChanged: (e) {
                  onChange(maxLength: e);
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}
