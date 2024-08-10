import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class StarRatingQuestionBuilder extends StatefulWidget {
  final StarRatingQuestion question;
  final ValueChanged<QuestionEntity>? onChanged;
  const StarRatingQuestionBuilder({
    required this.question,
    this.onChanged,
    super.key,
  });

  @override
  State<StarRatingQuestionBuilder> createState() =>
      _StarRatingQuestionBuilderState();
}

class _StarRatingQuestionBuilderState extends State<StarRatingQuestionBuilder> {
  onChange({
    int? maxRating,
    StarRatingColors? color,
    StarRatingShape? shape,
  }) {
    widget.onChanged?.call(widget.question.copyWith(
      maxRating: maxRating,
      shape: shape,
      color: color?.color,
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
            Text('Max Rating :'),
            AppSpacing.spacing_0_5.widthBox,
            Expanded(
              child: DropdownButton<int>(
                value: widget.question.maxRating,
                items: List.generate(
                  9,
                  (e) => DropdownMenuItem(
                    child: Text('${e + 2}'),
                    value: e + 2,
                  ),
                ),
                onChanged: (e) {
                  onChange(maxRating: e);
                },
              ),
            ),
          ],
        ),
        AppSpacing.spacing_1.heightBox,
        Row(
          children: [
            Text('Color :'),
            AppSpacing.spacing_0_5.widthBox,
            ...StarRatingColors.values.map(
              (e) {
                return InkWell(
                  onTap: () {
                    onChange(color: e);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    margin: AppSpacing.spacing_0_5.rightPadding,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: e.color,
                    ),
                    child: e.color == widget.question.color
                        ? Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              },
            )
          ],
        ),
        AppSpacing.spacing_1.heightBox,
        Row(
          children: [
            Text('Shape :'),
            AppSpacing.spacing_0_5.widthBox,
            Flexible(
              child: DropdownButton<StarRatingShape>(
                value: widget.question.shape,
                items: StarRatingShape.values
                    .map((e) => DropdownMenuItem(
                          child: Text(e.name),
                          value: e,
                        ))
                    .toList(),
                onChanged: (e) {
                  onChange(shape: e);
                },
              ),
            ),
            AppSpacing.spacing_1.widthBox,
            Icon(
              widget.question.shape.icon,
              color: widget.question.color,
              size: 40,
            ),
          ],
        ),
      ],
    );
  }
}
