import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showBuyTargetedResponsesModal(BuildContext context) async {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    constraints: BoxConstraints(maxHeight: context.height * 0.9),
    builder: (BuildContext _) {
      return BlocProvider.value(
        value: context.read<NewSurveyCubit>(),
        child: const BuyTargetedResponsesModal(),
      );
    },
  );
}

class BuyTargetedResponsesModal extends StatefulWidget {
  const BuyTargetedResponsesModal({
    super.key,
    this.collector,
  });
  final CollectorEntity? collector;

  @override
  State<BuyTargetedResponsesModal> createState() =>
      _BuyTargetedResponsesModalState();
}

class _BuyTargetedResponsesModalState extends State<BuyTargetedResponsesModal> {
  double population = 200;
  double get price => population * 1.5;
  Gender gender = Gender.both;
  RangeValues range = const RangeValues(18, 99);
  Set<String> countries = {'Algeria'};
  Set<Province> provinces = {};
  Set<City> cities = {};
  Set<TargetingCriteria> selectedCriteria = {};

  Set<String> get selectedCountries => {
        ...countries,
        ...provinces.map((e) => e.name),
        ...cities.map((e) => e.name),
      };
  @override
  Widget build(BuildContext context) {
    return AppBackDrop(
      headerActions: BackdropHeaderActions.none,
      title: Text(
        'Buy targeted responses',
        style: context.textTheme.titleLarge,
      ).tr(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.people_outline_rounded,
                      size: 60,
                    ),
                    Text(
                      'How many responses do you need?',
                      style: context.textTheme.titleMedium,
                    ),
                    AppSpacing.spacing_1.heightBox,
                    Slider(
                      value: population,
                      min: 50,
                      label: '${population.round()}',
                      max: 5000,
                      onChanged: (value) {
                        setState(() {
                          population = value;
                        });
                      },
                    ),
                    Text(
                      '${population.round()}',
                      style: context.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.spacing_2.heightBox,
            Card(
              child: Column(
                children: [
                  AppSpacing.spacing_2.heightBox,
                  Text(
                    'Who do you want to survey?',
                    style: context.textTheme.titleMedium,
                  ),
                  AppSpacing.spacing_2.heightBox,
                  Row(
                    children: [
                      AppSpacing.spacing_2.widthBox,
                      FilledButton.icon(
                        onPressed: () async {
                          final result =
                              await showTargetingCriteriaModal(context);
                          if (result != null) {
                            setState(() {
                              selectedCriteria = result;
                            });
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add targeting criteria'),
                      ),
                    ],
                  ),
                  ListTile(
                    leading: const Icon(Icons.language),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    dense: true,
                    title: const Text('Country'),
                    subtitle: Text(
                      selectedCountries.join(', '),
                      maxLines: 2,
                    ),
                    onTap: () async {
                      final result = await showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return const CountryModal();
                        },
                      );

                      if (result != null && result is Map) {
                        setState(() {
                          countries = result['countries'] as Set<String>;
                          provinces = result['provinces'] as Set<Province>;
                          cities = result['cities'] as Set<City>;
                        });
                      }
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.male),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    dense: true,
                    title: const Text('Gender'),
                    subtitle: Text(gender.name),
                    onTap: () async {
                      final result = await showModalBottomSheet(
                        context: context,
                        builder: (context) => const GenderModal(),
                      );
                      if (result != null && result is Gender) {
                        setState(() {
                          gender = result;
                        });
                      }
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.people_outline),
                    dense: true,
                    trailing: const Icon(Icons.chevron_right_rounded),
                    title: const Text('Age Range'),
                    subtitle: Text(
                      '${range.start.round()} - ${range.end.round()}',
                    ),
                    onTap: () async {
                      final result = await showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return const AgeModal();
                        },
                      );
                      if (result != null && result is RangeValues) {
                        setState(() {
                          range = result;
                        });
                      }
                    },
                  ),
                  for (final criteria in selectedCriteria) ...[
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.flag),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      dense: true,
                      title: Text(criteria.title),
                      subtitle: Text(criteria.choices.join(', ')),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      actions: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estimated cost',
                style: context.textTheme.titleLarge,
              ),
              Text('${price.toStringAsFixed(2).replaceAll('.', ',')} DZD',
                  style: context.textTheme.titleLarge),
            ],
          ),
          AppSpacing.spacing_2.heightBox,
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: context.colorScheme.onPrimary,
              backgroundColor: context.colorScheme.primary,
            ),
            onPressed: () {
              showPaymentModal(context);
            },
            child: const Center(child: Text('Checkout')),
          ),
        ],
      ),
    );
  }
}
