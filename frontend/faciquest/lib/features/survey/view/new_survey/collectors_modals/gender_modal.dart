import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:flutter/material.dart';

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
            'collectors.targeting.gender.title'.tr(),
            style: context.textTheme.titleLarge,
          ),
          AppSpacing.spacing_2.heightBox,
          RadioListTile<Gender>(
            value: Gender.both,
            groupValue: selectedGender,
            title: Text('collectors.targeting.gender.both'.tr()),
            onChanged: (value) {
              setState(() {
                selectedGender = value;
              });
            },
          ),
          RadioListTile<Gender>(
            value: Gender.male,
            groupValue: selectedGender,
            title: Text('collectors.targeting.gender.male'.tr()),
            onChanged: (value) {
              setState(() {
                selectedGender = value;
              });
            },
          ),
          RadioListTile<Gender>(
            value: Gender.female,
            groupValue: selectedGender,
            title: Text('collectors.targeting.gender.female'.tr()),
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
          context.pop(selectedGender);
        },
        child: Text('actions.save'.tr()),
      ),
    );
  }
}
