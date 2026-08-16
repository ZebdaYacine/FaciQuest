import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
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
                  "survey.${state.page.title}".tr(),
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: false,
                elevation: 0,
                backgroundColor: context.colorScheme.surface,
              ),
              body: Column(
                children: [
                  if (surveyId.isNotEmpty &&
                      surveyId != '-1' &&
                      state.survey.isNotEmpty)
                    _SurveyWorkspaceNavigation(currentPage: state.page),
                  Expanded(
                    child: AdaptiveContentWidth(
                      child: Builder(
                        builder: (context) {
                          if (state.status.isFailure && state.survey.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: AppSpacing.spacing_3.padding,
                                child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 480),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline_rounded,
                                        size: 56,
                                        color: context.colorScheme.error,
                                      ),
                                      AppSpacing.spacing_2.heightBox,
                                      Text(
                                        'survey.error.title'.tr(),
                                        textAlign: TextAlign.center,
                                        style: context.textTheme.titleLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      AppSpacing.spacing_1.heightBox,
                                      Text(
                                        'survey.error.message'.tr(),
                                        textAlign: TextAlign.center,
                                        style: context.textTheme.bodyLarge
                                            ?.copyWith(
                                          color: context
                                              .colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      AppSpacing.spacing_3.heightBox,
                                      FilledButton.icon(
                                        onPressed: () => context
                                            .read<NewSurveyCubit>()
                                            .fetchSurvey(),
                                        icon: const Icon(Icons.refresh_rounded),
                                        label: Text(
                                            'survey.error.button.retry'.tr()),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else if (state.status.isLoading &&
                              state.survey.isEmpty) {
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
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SurveyWorkspaceNavigation extends StatelessWidget {
  const _SurveyWorkspaceNavigation({required this.currentPage});

  final NewSurveyPages currentPage;

  @override
  Widget build(BuildContext context) {
    const destinations = [
      NewSurveyPages.summary,
      NewSurveyPages.surveyDetails,
      NewSurveyPages.questions,
      NewSurveyPages.collectResponses,
      NewSurveyPages.analyseResults,
    ];

    return Material(
      color: context.colorScheme.surface,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: context.colorScheme.outlineVariant),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            spacing: 8,
            children: destinations.map((page) {
              return ChoiceChip(
                selected: page == currentPage,
                onSelected: (_) =>
                    context.read<NewSurveyCubit>().goToPage(page),
                avatar: Icon(page.icon, size: 18),
                label: Text('survey.${page.title}'.tr()),
                showCheckmark: false,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

extension on NewSurveyPages {
  IconData get icon {
    switch (this) {
      case NewSurveyPages.summary:
        return Icons.dashboard_outlined;
      case NewSurveyPages.surveyDetails:
        return Icons.tune_rounded;
      case NewSurveyPages.questions:
        return Icons.quiz_outlined;
      case NewSurveyPages.collectResponses:
        return Icons.campaign_outlined;
      case NewSurveyPages.analyseResults:
        return Icons.analytics_outlined;
    }
  }
}

class _SurveyDetails extends StatelessWidget {
  const _SurveyDetails(this.surveyId);
  final String surveyId;

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: AdaptivePageBody(
                  maxWidth: 760,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'survey_details.create_new'.tr(),
                        style: context.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.primary,
                        ),
                      ),
                      Text(
                        'sections.enter_details'.tr(),
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
              padding: EdgeInsets.fromLTRB(
                AppSpacing.spacing_2,
                AppSpacing.spacing_2,
                AppSpacing.spacing_2,
                AppSpacing.spacing_2 + MediaQuery.paddingOf(context).bottom,
              ),
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: AdaptiveContentWidth(
                maxWidth: 760,
                child: Column(
                  children: [
                    Builder(
                      builder: (formContext) => FilledButton.icon(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                        ),
                        onPressed: () {
                          if (Form.of(formContext).validate()) {
                            context.read<NewSurveyCubit>().next();
                          }
                        },
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: Text('actions.next'.tr()),
                      ),
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
                      label: Text('actions.cancel'.tr()),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
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
        color:
            context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'survey_details.name'.tr(),
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.spacing_1.heightBox,
          buildInputForm(
            'survey_details.enter_name'.tr(),
            initialValue: cubit.state.survey.name,
            onChange: cubit.onSurveyNameChanged,
            textInputAction: TextInputAction.next,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'survey_details.name_required'.tr()
                : null,
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
            'survey_details.description'.tr(),
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.spacing_1.heightBox,
          buildInputForm(
            'survey_details.enter_description'.tr(),
            initialValue: cubit.state.survey.description,
            maxLines: 3,
            onChange: cubit.onSurveyDescriptionChanged,
            textInputAction: TextInputAction.done,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'survey_details.description_required'.tr()
                : null,
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
            'survey_details.likert_scale'.tr(),
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
                        child: Text("survey.QuestionType.${e.getValue()}".tr()),
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
