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
          RadioGroup<Gender>(
            groupValue: selectedGender,
            onChanged: (value) => setState(() => selectedGender = value),
            child: Column(
              children: [
                RadioListTile<Gender>(
                  value: Gender.both,
                  title: Text('collectors.targeting.gender.both'.tr()),
                ),
                RadioListTile<Gender>(
                  value: Gender.male,
                  title: Text('collectors.targeting.gender.male'.tr()),
                ),
                RadioListTile<Gender>(
                  value: Gender.female,
                  title: Text('collectors.targeting.gender.female'.tr()),
                ),
              ],
            ),
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
