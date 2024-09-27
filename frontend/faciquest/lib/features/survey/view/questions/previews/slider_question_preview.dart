import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class SliderQuestionPreview extends StatelessWidget {
  const SliderQuestionPreview({
    required this.question,
    required this.answer,
    required this.onAnswerChanged,
    super.key,
  });
  final SliderQuestion question;
  final SliderAnswer? answer;
  final ValueChanged<SliderAnswer>? onAnswerChanged;

  @override
  Widget build(BuildContext context) {
    return Slider(
      min: question.min,
      max: question.max,
      value: 5,
      onChanged: (newValue) {},
    );
  }
}
