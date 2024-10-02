import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:flutter/material.dart';

enum Gender { male, female, both }

class GenderModal extends StatefulWidget {
  const GenderModal({super.key});

  @override
  State<GenderModal> createState() => _GenderModalState();
}

class _GenderModalState extends State<GenderModal> {
  Gender? selectedGender = Gender.both;
  @override
  Widget build(BuildContext context) {
    return AppBackDrop(
      showDivider: false,
      showHeaderContent: false,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
            style: context.textTheme.titleLarge,
          ),
          AppSpacing.spacing_2.heightBox,
          RadioListTile<Gender>(
            value: Gender.both,
            groupValue: selectedGender,
            title: const Text('Both'),
            onChanged: (value) {
              setState(() {
                selectedGender = value;
              });
            },
          ),
          RadioListTile<Gender>(
            value: Gender.male,
            groupValue: selectedGender,
            title: const Text('Male'),
            onChanged: (value) {
              setState(() {
                selectedGender = value;
              });
            },
          ),
          RadioListTile<Gender>(
            value: Gender.female,
            groupValue: selectedGender,
            title: const Text('Female'),
            onChanged: (value) {
              setState(() {
                selectedGender = value;
              });
            },
          ),
        ],
      ),
      actions: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: context.colorScheme.onPrimary,
          backgroundColor: context.colorScheme.primary,
        ),
        onPressed: () {
          context.pop(result: selectedGender);
        },
        child: const Center(
          child: Text('save'),
        ),
      ),
    );
  }
}
