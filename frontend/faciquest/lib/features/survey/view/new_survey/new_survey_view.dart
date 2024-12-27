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
        listener: (context, state) {},
        child: BlocBuilder<NewSurveyCubit, NewSurveyState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  state.page.title,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: false,
                elevation: 0,
                backgroundColor: context.colorScheme.surface,
              ),
              body: Builder(
                builder: (context) {
                  if (state.status.isFailure && state.survey.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 48,
                            color: context.colorScheme.error,
                          ),
                          AppSpacing.spacing_2.heightBox,
                          Text(
                            state.msg ?? 'Error Occurred',
                            style: context.textTheme.titleMedium?.copyWith(
                              color: context.colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state.status.isLoading && state.survey.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: context.colorScheme.primary,
                      ),
                    );
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
              ),
            );
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
            padding: AppSpacing.spacing_3.padding,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create New Survey',
                    style: context.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Please enter details below',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppSpacing.spacing_3.heightBox,
                  const _NewSurveyForm(),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: AppSpacing.spacing_2.padding,
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () => context.read<NewSurveyCubit>().next(),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Next'),
              ),
              AppSpacing.spacing_1.heightBox,
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
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
                icon: const Icon(Icons.close_rounded),
                label: const Text('Cancel'),
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
    return Container(
      padding: AppSpacing.spacing_3.padding,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Survey Name *',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.spacing_1.heightBox,
          buildInputForm(
            'Enter survey name',
            initialValue: cubit.state.survey.name,
            onChange: cubit.onSurveyNameChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: context.colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.edit_rounded),
            ),
          ),
          AppSpacing.spacing_3.heightBox,
          Text(
            'Survey Description',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.spacing_1.heightBox,
          buildInputForm(
            'Enter survey description',
            initialValue: cubit.state.survey.description,
            maxLines: 3,
            onChange: cubit.onSurveyDescriptionChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: context.colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.description_rounded),
            ),
          ),
          AppSpacing.spacing_3.heightBox,
          Text(
            'Likert Scale *',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.spacing_1.heightBox,
          BlocSelector<NewSurveyCubit, NewSurveyState, LikertScale?>(
            selector: (state) => state.survey.likertScale,
            bloc: cubit,
            builder: (context, value) {
              return Container(
                padding: AppSpacing.spacing_1.horizontalPadding,
                decoration: BoxDecoration(
                  color: context.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton(
                  isExpanded: true,
                  value: value,
                  underline: const SizedBox.shrink(),
                  icon: const Icon(Icons.arrow_drop_down_rounded),
                  items: LikertScale.values.map(
                    (e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e.getValue()),
                      );
                    },
                  ).toList(),
                  onChanged: cubit.onSurveyLikertScaleChanged,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
