import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewSurveyView extends StatelessWidget {
  const NewSurveyView({
    super.key,
    required this.surveyAction,
    required this.surveyId,
  });

  final SurveyAction surveyAction;
  final String surveyId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewSurveyCubit(
        action: surveyAction,
        surveyId: surveyId,
        repository: getIt<SurveyRepository>(),
      )..fetchSurvey(),
      child: BlocListener<NewSurveyCubit, NewSurveyState>(
        listener: (context, state) {
          // if (state.status.isSuccess) {
          //   showModalBottomSheet(
          //     context: context,
          //     builder: (context) => const AppBackDrop(
          //       showHeaderContent: false,
          //       showDivider: false,
          //     ),
          //   );
          // }
        },
        child: BlocBuilder<NewSurveyCubit, NewSurveyState>(
          builder: (context, state) {
            return Scaffold(
                appBar: AppBar(
                  title: Text(state.page.title),
                  centerTitle: false,
                ),
                body: Builder(
                  builder: (context) {
                    if (state.status.isFailure && state.survey.isEmpty) {
                      return Center(child: Text(state.msg ?? 'Error Occurred'));
                    } else if (state.status.isLoading && state.survey.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    switch (state.page) {
                      case NewSurveyPages.surveyDetails:
                        return _SurveyDetails(surveyId);
                      case NewSurveyPages.questions:
                        return const QuestionsPage();
                      case NewSurveyPages.collectResponses:
                        return const CollectResponsesPage();
                      case NewSurveyPages.analyseResults:
                        return const AnalyseResultsPage();
                      case NewSurveyPages.summary:
                        return SummaryPage(
                          survey: state.survey,
                        );
                    }
                  },
                ));
          },
        ),
      ),
    );
  }
}

class _SurveyDetails extends StatelessWidget {
  const _SurveyDetails(this.surveyId);
  final String surveyId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: AppSpacing.spacing_2.padding,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create New Survey',
                    style: context.textTheme.headlineLarge,
                  ),
                  const Text('Please enter details below'),
                  AppSpacing.spacing_2.heightBox,
                  const _NewSurveyForm(),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: AppSpacing.spacing_2.padding,
          child: Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: context.colorScheme.onPrimary,
                  backgroundColor: context.colorScheme.primary,
                ),
                onPressed: () => context.read<NewSurveyCubit>().next(),
                child: const Center(child: Text('Next')),
              ),
              AppSpacing.spacing_0_5.heightBox,
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: context.colorScheme.error,
                  ),
                  foregroundColor: context.colorScheme.error,
                ),
                onPressed: () {
                  if (surveyId.isEmpty || surveyId == '-1') {
                    context.pop();
                  } else {
                    context.read<NewSurveyCubit>().goToSummary();
                  }
                },
                child: const Center(child: Text('Cancel')),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _NewSurveyForm extends StatefulWidget {
  const _NewSurveyForm();

  @override
  State<_NewSurveyForm> createState() => __NewSurveyFormState();
}

class __NewSurveyFormState extends State<_NewSurveyForm> with BuildFormMixin {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NewSurveyCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Survey Name *', style: context.textTheme.bodyLarge),
        buildInputForm(
          'Survey Name',
          initialValue: cubit.state.survey.name,
          onChange: cubit.onSurveyNameChanged,
        ),
        AppSpacing.spacing_2.heightBox,
        Text('Survey Description', style: context.textTheme.bodyLarge),
        buildInputForm(
          'Survey Description',
          initialValue: cubit.state.survey.description,
          maxLines: 3,
          onChange: cubit.onSurveyDescriptionChanged,
        ),
        // AppSpacing.spacing_2.heightBox,
        // Text('Survey Language *', style: context.textTheme.bodyLarge),
        // AppSpacing.spacing_1.heightBox,
        // DropdownButton(
        //   value: 'English',
        //   isExpanded: true,
        //   items: const <DropdownMenuItem<String>>[
        //     DropdownMenuItem(value: 'العربية', child: Text('العربية')),
        //     DropdownMenuItem(
        //       value: 'English',
        //       child: Text('English'),
        //     ),
        //     DropdownMenuItem(
        //       value: 'French',
        //       child: Text('French'),
        //     ),
        //     DropdownMenuItem(
        //       value: 'Spanish',
        //       child: Text('Spanish'),
        //     ),
        //   ],
        //   onChanged: (value) {},
        // ),
        AppSpacing.spacing_2.heightBox,
        Text('Lakert Scale *', style: context.textTheme.bodyLarge),
        AppSpacing.spacing_1.heightBox,
        BlocSelector<NewSurveyCubit, NewSurveyState, LikertScale?>(
          selector: (state) => state.survey.likertScale,
          bloc: cubit,
          builder: (context, value) {
            return DropdownButton(
              isExpanded: true,
              value: value,
              items: LikertScale.values.map(
                (e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e.getValue()),
                  );
                },
              ).toList(),
              onChanged: cubit.onSurveyLikertScaleChanged,
            );
          },
        )
      ],
    );
  }
}
