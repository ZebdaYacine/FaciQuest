import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(getIt<SurveyRepository>())..fetchSurveys(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            InkWell(
              onTap: () {
                AppRoutes.profile.push(context);
              },
              child: const CircleAvatar(
                child: Text('YG'),
              ),
            ),
            8.widthBox,
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.heightBox,
              Text(
                'Welcome to FaciQuest',
                style: context.textTheme.headlineMedium,
              ),
              8.heightBox,
              const Text('This is where you can view your surveys'),
              const Text('or create a new one'),
              8.heightBox,
              ElevatedButton(
                onPressed: () {
                  AppRoutes.manageMySurveys.push(context);
                },
                child: const Text('Manage Surveys'),
              ),
              Expanded(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    return Skeletonizer(
                      enabled: state.status.isLoading,
                      child: ListView.builder(
                        itemCount:
                            state.surveys.isEmpty ? 10 : state.surveys.length,
                        itemBuilder: (context, index) {
                          SurveyEntity? surveyEntity;
                          if (state.surveys.isEmpty) {
                            surveyEntity = null;
                          } else {
                            surveyEntity = state.surveys[index];
                          }

                          return _SurveyCard(
                            surveyEntity: surveyEntity,
                          );
                        },
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AppRoutes.newSurvey.push(
              context,
              pathParameters: {
                'id': '-1',
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _SurveyCard extends StatelessWidget {
  const _SurveyCard({
    super.key,
    this.surveyEntity,
  });

  final SurveyEntity? surveyEntity;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          AppRoutes.survey.push(
            context,
            pathParameters: {
              'id': surveyEntity?.id ?? '-1',
            },
          );
        },
        child: Padding(
          padding: 8.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                surveyEntity?.name ?? 'Survey Title',
                style: context.textTheme.headlineSmall,
              ),
              AppSpacing.spacing_0_5.heightBox,
              Text(
                surveyEntity?.description ?? 'Description of survey',
                style: context.textTheme.bodyMedium,
                maxLines: 2,
              ),
              Row(
                children: [
                  const Spacer(),
                  Text(
                    surveyEntity?.price
                            ?.toStringAsFixed(2)
                            .replaceAll('.', ',') ??
                        '10,00 DZD',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: Colors.green,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
