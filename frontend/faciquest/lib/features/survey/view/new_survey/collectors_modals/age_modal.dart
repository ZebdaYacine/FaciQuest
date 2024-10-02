import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:flutter/material.dart';

class AgeModal extends StatefulWidget {
  const AgeModal({super.key});

  @override
  State<AgeModal> createState() => _AgeModalState();
}

class _AgeModalState extends State<AgeModal> {
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
            'Age Range'.tr(),
            style: context.textTheme.titleLarge,
          ),
          AppSpacing.spacing_2.heightBox,
          RangeSlider(
            values: values,
            min: 0,
            max: 120,
            labels: RangeLabels(values.start.toString(), values.end.toString()),
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
                Text('Min: ${values.start.toStringAsFixed(0)}'),
                Text('Max: ${values.end.toStringAsFixed(0)}'),
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
          context.pop(result: values);
        },
        child: const Center(
          child: Text('save'),
        ),
      ),
    );
  }
}
