import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';

class SliderQuestionBuilder extends QuestionBuilder {
  const SliderQuestionBuilder({
    required super.question,
    super.onChanged,
    super.key,
  });

  @override
  State<SliderQuestionBuilder> createState() => _SliderQuestionBuilderState();
}

class _SliderQuestionBuilderState extends State<SliderQuestionBuilder>
    with BuildFormMixin {
  onChange({
    double? min,
    double? max,
  }) {
    widget.onChanged?.call((widget.question as SliderQuestion).copyWith(
      min: min,
      max: max,
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
            Text('survey.question.slider.min'.tr()),
            AppSpacing.spacing_1.widthBox,
            Flexible(
              child: InputQty.double(
                initVal: (widget.question as SliderQuestion).min,
                onQtyChanged: (e) {
                  onChange(min: e);
                },
              ),
            )
          ],
        ),
        AppSpacing.spacing_1.heightBox,
        Row(
          children: [
            Text('survey.question.slider.max'.tr()),
            AppSpacing.spacing_1.widthBox,
            Flexible(
              child: InputQty.double(
                initVal: (widget.question as SliderQuestion).max,
                onQtyChanged: (e) {
                  onChange(max: e);
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}
