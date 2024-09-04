import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class StarRatingQuestionBuilder extends QuestionBuilder {
  const StarRatingQuestionBuilder({
    required super.question,
    super.onChanged,
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
    widget.onChanged?.call((widget.question as StarRatingQuestion).copyWith(
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
            const Text('Max Rating :'),
            AppSpacing.spacing_0_5.widthBox,
            Expanded(
              child: DropdownButton<int>(
                value: (widget.question as StarRatingQuestion).maxRating,
                items: List.generate(
                  9,
                  (e) => DropdownMenuItem(
                    value: e + 2,
                    child: Text('${e + 2}'),
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
            const Text('Color :'),
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
                    child:
                        e.color == (widget.question as StarRatingQuestion).color
                            ? const Icon(Icons.check, color: Colors.white)
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
            const Text('Shape :'),
            AppSpacing.spacing_0_5.widthBox,
            Flexible(
              child: DropdownButton<StarRatingShape>(
                value: (widget.question as StarRatingQuestion).shape,
                items: StarRatingShape.values
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name),
                        ))
                    .toList(),
                onChanged: (e) {
                  onChange(shape: e);
                },
              ),
            ),
            AppSpacing.spacing_1.widthBox,
            Icon(
              (widget.question as StarRatingQuestion).shape.fullIcon,
              color: (widget.question as StarRatingQuestion).color,
              size: 40,
            ),
          ],
        ),
      ],
    );
  }
}
