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
                          subtitle: const Text('Algeria'),
                          onTap: () {},
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.person_outline_rounded),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          title: const Text('Gender'),
                          subtitle: const Text('Both'),
                          onTap: () {},
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.people_outline),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          title: const Text('Age Range'),
                          subtitle: const Text('18 - 99+'),
                          onTap: () {},
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.monetization_on_outlined),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          title: const Text('Income Range'),
                          subtitle: const Text(r'0$ - $200k'),
                          onTap: () {},
                        ),
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

