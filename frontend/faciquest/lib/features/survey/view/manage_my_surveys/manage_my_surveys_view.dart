import 'package:awesome_extensions/awesome_extensions.dart' hide NavigatorExt;
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ManageMySurveysView extends StatefulWidget {
  const ManageMySurveysView({super.key});

  @override
  State<ManageMySurveysView> createState() => _ManageMySurveysViewState();
}

class _ManageMySurveysViewState extends State<ManageMySurveysView> {
  final cubit = ManageMySurveysCubit(getIt<SurveyRepository>());
  @override
  void initState() {
    super.initState();
    cubit.fetchSurveys();
  }

  var viewStyle = ViewStyle.grid;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage My Surveys'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.pushNamed(
              AppRoutes.newSurvey.name,
              pathParameters: {
                'id': '-1',
              },
            );
          },
          label: const Text('Create Survey'), // Text on the button
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: cubit.onSearchChanged,
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
            BlocBuilder<ManageMySurveysCubit, ManageMySurveysState>(
              builder: (context, state) {
                if (state.status.isFailure) {
                  return KErrorWidget(
                    message: state.msg,
                  );
                }
                if (viewStyle == ViewStyle.grid) {
                  return Expanded(
                    child: Skeletonizer(
                      enabled: state.status.isLoading,
                      child: GridSurveys(
                        surveys: state.status.isLoading
                            ? SurveyEntity.dummyList()
                            : state.filteredSurveys,
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: Skeletonizer(
                      enabled: state.status.isLoading,
                      child: ListSurveys(
                        surveys: state.status.isLoading
                            ? SurveyEntity.dummyList()
                            : state.filteredSurveys,
                      ),
                    ),
                  );
                }
              },
            )
          ],
        ),
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
  const GridSurveys({
    super.key,
    required this.surveys,
  });

  final List<SurveyEntity> surveys;

  @override
  Widget build(BuildContext context) {
    if (surveys.isEmpty) {
      return const Center(
        child: Text('No surveys found'),
      );
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.isPhone
            ? 2
            : context.isTablet
                ? 3
                : 4,
        childAspectRatio: 0.8,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: surveys.length,
      itemBuilder: (context, index) {
        final survey = surveys[index];
        return InkWell(
          onTap: () {
            context.pushNamed(
              AppRoutes.newSurvey.name,
              extra: SurveyAction.edit,
              pathParameters: {
                'id': survey.id,
              },
            );
          },
          child: Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SurveyBadge(
                      status: survey.status,
                    ),
                    SurveyActions(
                      surveyId: survey.id,
                    ),
                  ],
                ),
                AppSpacing.spacing_1.heightBox,
                Text(
                  '$index.${survey.name}',
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
                        'Updated : ${survey.updatedAt.toString().substring(0, 10)}',
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
                      '${survey.responseCount} responses',
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
          )),
        );
      },
    );
  }
}

class SurveyBadge extends StatelessWidget {
  const SurveyBadge({
    super.key,
    required this.status,
    this.large = false,
  });
  final SurveyStatus status;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Badge(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      label: Text(
        'Open',
        style: large
            ? context.textTheme.titleMedium
            : context.textTheme.bodyMedium,
      ),
      backgroundColor: Colors.greenAccent,
    );
  }
}

class SurveyActions extends StatelessWidget {
  const SurveyActions({
    super.key,
    required this.surveyId,
  });
  final String surveyId;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          const PopupMenuItem<SurveyAction>(
            value: SurveyAction.edit,
            child: Text('Edit Survey'),
          ),
          const PopupMenuItem(
            value: SurveyAction.preview,
            child: Text('Preview Survey'),
          ),
          const PopupMenuItem(
            value: SurveyAction.analyze,
            child: Text('Analyze Results'),
          ),
          const PopupMenuItem(
            value: SurveyAction.delete,
            child: Text('Delete'),
          ),
        ];
      },
      onSelected: (value) {
        context.pushNamed(
          AppRoutes.newSurvey.name,
          extra: value,
          pathParameters: {
            'id': surveyId,
          },
        );
      },
    );
  }
}

class ListSurveys extends StatelessWidget {
  const ListSurveys({super.key, required this.surveys});
  final List<SurveyEntity> surveys;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: surveys.length,
      itemBuilder: (context, index) {
        final survey = surveys[index];
        return ListTile(
          trailing: SurveyActions(surveyId: survey.id),
          leading: SurveyBadge(status: survey.status),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    survey.name,
                    style: context.textTheme.titleLarge,
                    maxLines: 2,
                  ),
                  FittedBox(
                    child: Text(
                      'Updated : ${survey.updatedAt.toString().substring(0, 10)}',
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
                    '${survey.responseCount}',
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
