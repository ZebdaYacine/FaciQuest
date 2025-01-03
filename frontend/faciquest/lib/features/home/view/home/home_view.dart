import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
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
          elevation: 0,
          backgroundColor: context.colorScheme.surface,
          actions: [
            Padding(
              padding: AppSpacing.spacing_2.rightPadding,
              child: InkWell(
                onTap: () {
                  AppRoutes.profile.push(context);
                },
                child: CircleAvatar(
                  backgroundColor: context.colorScheme.primaryContainer,
                  child: Text(
                    'YG',
                    style: TextStyle(
                      color: context.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                context.colorScheme.surface,
                context.colorScheme.surface.withOpacity(0.95),
              ],
            ),
          ),
          child: Padding(
            padding: AppSpacing.spacing_3.padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacing.spacing_2.heightBox,
                Text(
                  'home.welcome_title'.tr(),
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.primary,
                  ),
                ),
                AppSpacing.spacing_1.heightBox,
                Text(
                  'home.welcome_subtitle'.tr(),
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                AppSpacing.spacing_3.heightBox,
                FilledButton.icon(
                  onPressed: () {
                    AppRoutes.manageMySurveys.push(context);
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(200, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.edit_document),
                  label: Text('home.manage_surveys'.tr()),
                ),
                AppSpacing.spacing_3.heightBox,
                Text(
                  'home.available_surveys'.tr(),
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.spacing_2.heightBox,
                Expanded(
                  child: BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      if (state.status.isFailure) {
                        return const _FailureState();
                      }
                      if (state.status.isSuccess && state.surveys.isEmpty) {
                        return const _EmptyState();
                      }
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
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            AppRoutes.newSurvey.push(
              context,
              pathParameters: {
                'id': '-1',
              },
            );
          },
          icon: const Icon(Icons.add),
          label: Text('home.new_survey'.tr()),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: context.colorScheme.primary.withOpacity(0.5),
          ),
          AppSpacing.spacing_2.heightBox,
          Text(
            'home.empty_state.no_surveys'.tr(),
            style: context.textTheme.titleLarge?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _FailureState extends StatelessWidget {
  const _FailureState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: context.colorScheme.error,
          ),
          AppSpacing.spacing_2.heightBox,
          Text(
            'home.error_state.error_message'.tr(),
            style: context.textTheme.titleLarge?.copyWith(
              color: context.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _SurveyCard extends StatelessWidget {
  const _SurveyCard({
    this.surveyEntity,
  });

  final SurveyEntity? surveyEntity;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: AppSpacing.spacing_2.bottomPadding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          AppRoutes.survey.push(
            context,
            pathParameters: {
              'id': surveyEntity?.id ?? '-1',
            },
          );
        },
        child: Padding(
          padding: AppSpacing.spacing_3.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                surveyEntity?.name ?? 'Survey Title',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.primary,
                ),
              ),
              AppSpacing.spacing_1.heightBox,
              Text(
                surveyEntity?.description ?? 'Description of survey',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              AppSpacing.spacing_2.heightBox,
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      surveyEntity?.price
                              ?.toStringAsFixed(2)
                              .replaceAll('.', ',') ??
                          '10,00 DZD',
                      style: context.textTheme.titleMedium?.copyWith(
                        color: context.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: context.colorScheme.primary,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
