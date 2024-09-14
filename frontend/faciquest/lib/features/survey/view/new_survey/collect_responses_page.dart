import 'package:awesome_extensions/awesome_extensions.dart';

import 'package:faciquest/core/core.dart';
import 'package:flutter/material.dart';

class CollectResponsesPage extends StatefulWidget {
  const CollectResponsesPage({super.key});

  @override
  State<CollectResponsesPage> createState() => _CollectResponsesPageState();
}

class _CollectResponsesPageState extends State<CollectResponsesPage> {
  double population = 200;
  double get price => population * 1.5;
  Gender gender = Gender.both;
  RangeValues range = const RangeValues(18, 99);
  Set<String> countries = {'Algeria'};
  Set<Province> provinces = {};
  Set<City> cities = {};

  Set<String> get selectedCountries => {
        ...countries,
        ...provinces.map((e) => e.name),
        ...cities.map((e) => e.name),
      };
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.spacing_2,
              ),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.people_outline_rounded,
                            size: 100,
                          ),
                          Text(
                            'How many responses do you need?',
                            style: context.textTheme.titleMedium,
                          ),
                          AppSpacing.spacing_2.heightBox,
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
                        ListTile(
                          leading: const Icon(Icons.language),
                          trailing: const Icon(Icons.chevron_right_rounded),
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
                                provinces =
                                    result['provinces'] as Set<Province>;
                                cities = result['cities'] as Set<City>;
                              });
                            }
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.person_outline_rounded),
                          trailing: const Icon(Icons.chevron_right_rounded),
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
                        // const Divider(),
                        // ListTile(
                        //   leading: const Icon(Icons.monetization_on_outlined),
                        //   trailing: const Icon(Icons.chevron_right_rounded),
                        //   title: const Text('Income Range'),
                        //   subtitle: const Text(r'0$ - $200k'),
                        //   onTap: () {},
                        // ),
                        // const Divider(),
                        // AppSpacing.spacing_1.heightBox,
                        // ElevatedButton.icon(
                        //   onPressed: () {},
                        //   icon: const Icon(Icons.add),
                        //   label: const Text('Add targeting criteria'),
                        // ),
                        // AppSpacing.spacing_1.heightBox,
                      ],
                    ),
                  ),
                  AppSpacing.spacing_2.heightBox,
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Estimated cost',
                    style: context.textTheme.titleLarge,
                  ),
                  Text('${price.toStringAsFixed(2)} \$',
                      style: context.textTheme.titleLarge),
                ],
              ),
              AppSpacing.spacing_2.heightBox,
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: context.colorScheme.onPrimary,
                  backgroundColor: context.colorScheme.primary,
                ),
                onPressed: () {},
                child: const Center(child: Text('Checkout')),
              ),
            ],
          ),
        )
      ],
    );
  }
}

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
            'Gender',
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

class CountryModal extends StatefulWidget {
  const CountryModal({super.key});

  @override
  State<CountryModal> createState() => _CountryModalState();
}

class _CountryModalState extends State<CountryModal> {
  @override
  void initState() {
    super.initState();
    countries = {...getIt<Data>().countries};
  }

  bool regionTargeting = true;
  bool cityTargeting = false;

  Set<String> countries = {};
  Set<Province> provinces = {};
  Set<City> cities = {};
  @override
  Widget build(BuildContext context) {
    return AppBackDrop(
      showDivider: false,
      showHeaderContent: false,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Country',
              style: context.textTheme.titleLarge,
            ),
            AppSpacing.spacing_2.heightBox,
            Wrap(
              alignment: WrapAlignment.start,
              children: [
                for (final country in getIt<Data>().countries)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ChoiceChip(
                      label: Text(country),
                      selected: countries.contains(country),
                      onSelected: (value) {
                        setState(() {
                          if (value) {
                            countries.add(country);
                          } else {
                            countries.remove(country);
                          }
                        });
                      },
                    ),
                  ),
              ],
            ),
            AppSpacing.spacing_2.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Region targeting :',
                  style: context.textTheme.titleLarge,
                ),
                Switch(
                  value: regionTargeting && countries.length == 1,
                  onChanged: countries.length == 1
                      ? (value) {
                          setState(() {
                            regionTargeting = value;
                          });
                        }
                      : null,
                )
              ],
            ),
            if (regionTargeting && countries.length == 1)
              DropdownButton<Province>(
                isExpanded: true,
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('select a wilaya'),
                  ),
                  ...getIt<Data>().provinces.map(
                    (e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(
                          '${e.id}. ${e.name}',
                        ),
                      );
                    },
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    provinces.add(value);
                  });
                },
              ),
            AppSpacing.spacing_2.heightBox,
            Wrap(
              children: [
                for (final province in provinces)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ChoiceChip(
                      label: Text(province.name),
                      selected: provinces.contains(province),
                      onSelected: (value) {
                        setState(() {
                          if (value) {
                            provinces.add(province);
                          } else {
                            provinces.remove(province);
                          }
                        });
                      },
                    ),
                  ),
              ],
            ),
            AppSpacing.spacing_2.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'City targeting :',
                  style: context.textTheme.titleLarge,
                ),
                Switch(
                  value: cityTargeting && provinces.length == 1,
                  onChanged: provinces.length == 1
                      ? (value) {
                          setState(() {
                            cityTargeting = value;
                          });
                        }
                      : null,
                )
              ],
            ),
            if (cityTargeting && provinces.length == 1)
              DropdownButton<City>(
                isExpanded: true,
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('select a city'),
                  ),
                  ...getIt<Data>()
                      .provinces[int.parse(provinces.first.id) - 1]
                      .cities
                      .map(
                    (e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(
                          '${e.id}. ${e.name}',
                        ),
                      );
                    },
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    cities.add(value);
                  });
                },
              ),
            AppSpacing.spacing_2.heightBox,
            Wrap(
              children: [
                for (final city in cities)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ChoiceChip(
                      label: Text(city.name),
                      selected: cities.contains(city),
                      onSelected: (value) {
                        setState(() {
                          if (value) {
                            cities.add(city);
                          } else {
                            cities.remove(city);
                          }
                        });
                      },
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
      actions: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: context.colorScheme.onPrimary,
          backgroundColor: context.colorScheme.primary,
        ),
        onPressed: () {
          context.pop(result: {
            'countries': countries,
            'provinces': provinces,
            'cities': cities,
          });
        },
        child: const Center(
          child: Text('save'),
        ),
      ),
    );
  }
}
