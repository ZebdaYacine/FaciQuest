import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:flutter/material.dart';

class IncomeModal extends StatefulWidget {
  const IncomeModal({super.key});

  @override
  State<IncomeModal> createState() => _IncomeModalState();
}

class _IncomeModalState extends State<IncomeModal> {
  RangeValues values = const RangeValues(18, 99);
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
            'collectors.targeting.income_range'.tr(),
            style: context.textTheme.titleLarge,
          ),
          AppSpacing.spacing_2.heightBox,
          RangeSlider(
            values: values,
            min: 0,
            max: 1000000,
            labels: RangeLabels(
              'collectors.targeting.min'
                  .tr(args: [values.start.toStringAsFixed(0)]),
              'collectors.targeting.max'
                  .tr(args: [values.end.toStringAsFixed(0)]),
            ),
            divisions: 120,
            onChanged: (value) {
              setState(() {
                values = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('collectors.targeting.min'
                    .tr(args: [values.start.toStringAsFixed(0)])),
                Text('collectors.targeting.max'
                    .tr(args: [values.end.toStringAsFixed(0)])),
              ],
            ),
          )
        ],
      ),
      actions: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: context.colorScheme.onPrimary,
          backgroundColor: context.colorScheme.primary,
        ),
        onPressed: () {
          context.pop(values);
        },
        child: Text('actions.save'.tr()),
      ),
    );
  }
}
