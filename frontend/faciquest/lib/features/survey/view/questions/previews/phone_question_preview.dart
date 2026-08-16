import 'package:faciquest/features/features.dart';
import 'package:easy_localization/easy_localization.dart';
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
      decoration: InputDecoration(
        labelText: 'personal_info.fields.phone'.tr(),
        border: const OutlineInputBorder(
          borderSide: BorderSide(),
        ),
      ),
      initialCountryCode: 'DZ',
      textInputAction: TextInputAction.done,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      invalidNumberMessage: 'survey.validation.invalid_phone'.tr(),
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
