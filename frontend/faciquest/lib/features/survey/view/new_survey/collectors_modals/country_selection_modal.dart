import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:flutter/material.dart';

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
              'collectors.targeting.location.country'.tr(),
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
                  'collectors.targeting.location.region_targeting'.tr(),
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
                  DropdownMenuItem(
                    value: null,
                    child: Text(
                        'collectors.targeting.location.select_wilaya'.tr()),
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
                  'collectors.targeting.location.city_targeting'.tr(),
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
                  DropdownMenuItem(
                    value: null,
                    child:
                        Text('collectors.targeting.location.select_city'.tr()),
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
        child: Text('actions.save'.tr()),
      ),
    );
  }
}
