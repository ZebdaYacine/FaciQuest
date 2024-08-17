import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';

class CommentBoxQuestionBuilder extends QuestionBuilder {
  const CommentBoxQuestionBuilder({
    required super.question,
    super.onChanged,
    super.key,
  });

  @override
  State<CommentBoxQuestionBuilder> createState() =>
      _CommentBoxQuestionBuilderState();
}

class _CommentBoxQuestionBuilderState extends State<CommentBoxQuestionBuilder>
    with BuildFormMixin {
  onChange({
    int? maxLength,
    bool? isRequired,
    int? maxLines,
  }) {
    widget.onChanged?.call((widget.question as CommentBoxQuestion).copyWith(
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
                initVal: (widget.question as CommentBoxQuestion).maxLength,
                onQtyChanged: (e) {
                  onChange(maxLength: e);
                },
              ),
            )
          ],
        ),
        Row(
          children: [
            Text('Max lines :'),
            AppSpacing.spacing_1.widthBox,
            Flexible(
              child: InputQty.int(
                initVal: (widget.question as CommentBoxQuestion).maxLength,
                onQtyChanged: (e) {
                  onChange(maxLines: e);
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}
