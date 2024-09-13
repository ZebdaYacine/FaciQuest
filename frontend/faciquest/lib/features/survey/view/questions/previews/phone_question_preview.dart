import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneQuestionPreview extends StatelessWidget {
  const PhoneQuestionPreview({
    required this.question,
    super.key,
  });
  final PhoneQuestion question;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      decoration: const InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
      ),
      initialCountryCode: 'DZ',
      onChanged: (phone) {},
    );
  }
}
