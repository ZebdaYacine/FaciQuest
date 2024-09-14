import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:flutter/material.dart';

class ManageMySurveysView extends StatefulWidget {
  const ManageMySurveysView({super.key});

  @override
  State<ManageMySurveysView> createState() => _ManageMySurveysViewState();
}

class _ManageMySurveysViewState extends State<ManageMySurveysView> {
  var viewStyle = ViewStyle.grid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage My Surveys'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 2,
                      ),
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                    ),
                  ),
                ),
                AppSpacing.spacing_1.widthBox,
                SegmentedButton<ViewStyle>(
                  segments: ViewStyle.values.map(
                    (e) {
                      return ButtonSegment(
                        value: e,
                        icon: Icon(e.icon),
                      );
                    },
                  ).toList(),
                  selected: {viewStyle},
                  multiSelectionEnabled: false,
                  onSelectionChanged: (p0) {
                    viewStyle = p0.firstOrNull ?? viewStyle;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          AppSpacing.spacing_1.heightBox,
          if (viewStyle == ViewStyle.grid)
            const Expanded(child: GridSurveys())
          else
            const Expanded(child: ListSurveys()),
        ],
      ),
    );
  }
}

enum ViewStyle {
  grid,
  list;

  IconData get icon {
    switch (this) {
      case ViewStyle.grid:
        return Icons.grid_view;
      case ViewStyle.list:
        return Icons.list;
    }
  }
}

class GridSurveys extends StatelessWidget {
  const GridSurveys({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Badge(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    label: Text(
                      'Open',
                      style: context.textTheme.bodyMedium,
                    ),
                    backgroundColor: Colors.greenAccent,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.menu),
                  ),
                ],
              ),
              AppSpacing.spacing_1.heightBox,
              Text(
                '$index survey',
                style: context.textTheme.titleLarge,
                maxLines: 2,
              ),
              AppSpacing.spacing_1.heightBox,
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    color: context.primaryColor,
                    size: 16,
                  ),
                  AppSpacing.spacing_1.widthBox,
                  FittedBox(
                    child: Text(
                      'Updated : 2022-01-01',
                      style: context.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.bar_chart_rounded,
                    color: context.primaryColor,
                  ),
                  AppSpacing.spacing_1.widthBox,
                  Text(
                    '$index responses',
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
              AppSpacing.spacing_1.heightBox,
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(
                    color: context.primaryColor,
                  ),
                ),
                onPressed: () {},
                child: const Center(
                  child: Text('Analyze results'),
                ),
              )
            ],
          ),
        ));
      },
    );
  }
}

class ListSurveys extends StatelessWidget {
  const ListSurveys({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz_outlined),
          ),
          leading: Badge(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            label: Text(
              'Open',
              style: context.textTheme.bodyMedium,
            ),
            backgroundColor: Colors.greenAccent,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$index survey',
                    style: context.textTheme.titleLarge,
                    maxLines: 2,
                  ),
                  FittedBox(
                    child: Text(
                      'Updated : 2022-01-01',
                      style: context.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.bar_chart_rounded,
                    color: context.primaryColor,
                  ),
                  AppSpacing.spacing_1.widthBox,
                  Text(
                    '$index ',
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
