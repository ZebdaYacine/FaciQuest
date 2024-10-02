import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

Future<Set<TargetingCriteria>?> showTargetingCriteriaModal(
  BuildContext context,
) async {
  return showModalBottomSheet<Set<TargetingCriteria>>(
    context: context,
    isScrollControlled: true,
    constraints: BoxConstraints(maxHeight: context.height * 0.9),
    builder: (BuildContext context) {
      return const TargetingCriteriaModal();
    },
  );
}

class TargetingCriteriaModal extends StatefulWidget {
  const TargetingCriteriaModal({super.key});

  @override
  State<TargetingCriteriaModal> createState() => _TargetingCriteriaModalState();
}

class _TargetingCriteriaModalState extends State<TargetingCriteriaModal> {
  String searchQuery = '';
  List<TargetingCriteria> list = TargetingCriteria.dummy();

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
          TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          AppSpacing.spacing_1.heightBox,
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final criteria = filteredList[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          criteria.title,
                          style: context.textTheme.titleMedium,
                        ),
                        AppSpacing.spacing_1.heightBox,
                        Text(
                          criteria.description ?? '',
                          style: context.textTheme.bodySmall,
                        ),
                        AppSpacing.spacing_1.heightBox,
                        MultiDropdown(
                          dropdownDecoration: const DropdownDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          items: criteria.choices
                              .map(
                                (e) => DropdownItem(label: e.title, value: e),
                              )
                              .toList(),
                          onSelectionChange: (selectedItems) {
                            selectedChoices.removeWhere(
                              (element) {
                                return element.id == criteria.id;
                              },
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
      actions: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('cancel'),
            ),
          ),
          AppSpacing.spacing_1.widthBox,
          Expanded(
            child: FilledButton(
              onPressed: () {
                context.pop(result: selectedChoices);
              },
              child: const Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }
}
