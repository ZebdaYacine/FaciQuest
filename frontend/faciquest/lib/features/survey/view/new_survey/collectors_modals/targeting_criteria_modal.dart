import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

Future<Set<TargetingCriteria>?> showTargetingCriteriaModal(
  BuildContext context,
) async {
  return showModalBottomSheet<Set<TargetingCriteria>>(
    context: context,
    isScrollControlled: true,
    constraints: BoxConstraints(maxHeight: context.height * 0.9),
    builder: (BuildContext _) {
      return BlocProvider.value(
        value: context.read<NewSurveyCubit>()..fetchTargetingCriteria(),
        child: const TargetingCriteriaModal(),
      );
    },
  );
}

class TargetingCriteriaModal extends StatefulWidget {
  const TargetingCriteriaModal({super.key});

  @override
  State<TargetingCriteriaModal> createState() => _TargetingCriteriaModalState();
}

class _TargetingCriteriaModalState extends State<TargetingCriteriaModal> {
  @override
  void initState() {
    super.initState();
    context.read<NewSurveyCubit>().fetchTargetingCriteria().then((value) {
      setState(() {
        list = value;
      });
    });
  }

  String searchQuery = '';
  List<TargetingCriteria> list = [];
  Set<TargetingCriteria> selectedChoices = {};

  List<TargetingCriteria> get filteredList {
    if (searchQuery.isEmpty) {
      return list;
    }
    return list
        .where((element) =>
            (element.category
                    ?.toLowerCase()
                    .contains(searchQuery.toLowerCase()) ??
                false) ||
            (element.description
                    ?.toLowerCase()
                    .contains(searchQuery.toLowerCase()) ??
                false) ||
            (element.title.toLowerCase().contains(searchQuery.toLowerCase())))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackDrop(
      showDivider: false,
      showHeaderContent: false,
      body: Column(
        children: [
          Padding(
            padding: AppSpacing.spacing_1.padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'collectors.targeting.title'.tr(),
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.primary,
                  ),
                ),
                AppSpacing.spacing_2.heightBox,
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'collectors.targeting.search_label'.tr(),
                    hintText: 'collectors.targeting.search_hint'.tr(),
                    prefixIcon: Icon(
                      Icons.search,
                      color: context.colorScheme.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: context.colorScheme.outline,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: context.colorScheme.outline,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: context.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final criteria = filteredList[index];
                return Card(
                  elevation: 2,
                  margin: AppSpacing.spacing_2.bottomPadding,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: AppSpacing.spacing_3.padding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    criteria.title,
                                    style:
                                        context.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: context.colorScheme.primary,
                                    ),
                                  ),
                                  if (criteria.category != null) ...[
                                    AppSpacing.spacing_1.heightBox,
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: context
                                            .colorScheme.primaryContainer
                                            .withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        criteria.category!,
                                        style: context.textTheme.labelSmall
                                            ?.copyWith(
                                          color: context.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (criteria.description != null) ...[
                          AppSpacing.spacing_2.heightBox,
                          Text(
                            criteria.description!,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                        AppSpacing.spacing_3.heightBox,
                        MultiDropdown(
                          dropdownDecoration: const DropdownDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                            // border: Border.all(
                            //   color: context.colorScheme.outline,
                            // ),
                          ),
                          items: criteria.choices
                              .map(
                                (e) => DropdownItem(label: e.title, value: e),
                              )
                              .toList(),
                          onSelectionChange: (selectedItems) {
                            selectedChoices.removeWhere(
                              (element) => element.id == criteria.id,
                            );
                            selectedChoices
                                .add(criteria.copyWith(choices: selectedItems));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      actions: Padding(
        padding: AppSpacing.spacing_3.padding,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'actions.cancel'.tr(),
                  style: context.textTheme.labelLarge,
                ),
              ),
            ),
            AppSpacing.spacing_2.widthBox,
            Expanded(
              child: FilledButton(
                onPressed: () => context.pop(result: selectedChoices),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'actions.apply'.tr(),
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
