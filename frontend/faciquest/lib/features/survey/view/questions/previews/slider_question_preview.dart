import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class SliderQuestionPreview extends StatelessWidget {
  const SliderQuestionPreview({
    required this.question,
    super.key,
  });
  final SliderQuestion question;

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
