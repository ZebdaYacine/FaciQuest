import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneQuestionPreview extends StatelessWidget {
  const PhoneQuestionPreview({
    required this.question,
    required this.answer,
    required this.onAnswerChanged,
    super.key,
  });
  final PhoneQuestion question;
  final PhoneAnswer? answer;
  final ValueChanged<PhoneAnswer>? onAnswerChanged;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      initialValue: answer?.value,
      decoration: const InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
      ),
      initialCountryCode: 'DZ',
      onChanged: (phone) {
        onAnswerChanged?.call(
          PhoneAnswer(
            questionId: question.id,
            value: phone.completeNumber,
          ),
        );
      },
    );
  }
}
