import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class SurveyView extends StatelessWidget {
  const SurveyView({
    super.key,
    required this.surveyId,
  });
  final String surveyId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurveyCubit(
        surveyId: surveyId,
        repository: getIt<SurveyRepository>(),
      )..getSurvey(),
      child: const _SurveyContent(),
    );
  }
}

class _SurveyContent extends StatelessWidget {
  const _SurveyContent();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SurveyCubit, SurveyState>(
      listenWhen: (previous, current) => previous.submissionStatus != current.submissionStatus,
      listener: (context, state) {
        if (state.submissionStatus.isSuccess) {
          _showSuccessDialog(context);
          Future.delayed(2.seconds, () {
            if (context.mounted) {
              context.pop();
              context.pop();
            }
          });
        }
      },
      child: BlocBuilder<SurveyCubit, SurveyState>(
        // buildWhen: (previous, current) => previous.survey != current.survey,
        builder: (context, state) {
          if (state.status.isLoading) return const _LoadingState();
          if (state.status.isFailure) return const _FailureState();
          if (state.survey.isEmpty) return const _EmptyState();

          return _SurveyQuestions(state: state);
        },
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => AppBackDrop(
        showHeaderContent: false,
        showDivider: false,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LottieBuilder.asset(
              'assets/lottie/success.json',
              height: 200,
              fit: BoxFit.contain,
              repeat: false,
              animate: true,
            ),
            AppSpacing.spacing_3.heightBox,
            Text(
              'survey.submit.success.title'.tr(),
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.primary,
              ),
            ),
            AppSpacing.spacing_2.heightBox,
            Text(
              'survey.submit.success.message'.tr(),
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.spacing_3.heightBox,
          ],
        ),
      ),
    );
  }
}

class _SurveyQuestions extends StatelessWidget {
  const _SurveyQuestions({required this.state});

  final SurveyState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SurveyCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.survey.name,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: context.colorScheme.surface,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.colorScheme.surface,
              context.colorScheme.surface,
            ],
          ),
        ),
        child: PageView.builder(
          itemCount: state.survey.questions.length,
          itemBuilder: (context, index) {
            final question = state.survey.questions[index];
            final answer = context.read<SurveyCubit>().state.answers[question.id];

            return SingleChildScrollView(
              padding: AppSpacing.spacing_3.padding,
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: (index + 1) / state.survey.questions.length,
                    backgroundColor: context.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  AppSpacing.spacing_2.heightBox,
                  Text(
                    'survey.question.progress'.tr(args: ['${index + 1}', '${state.survey.questions.length}']),
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppSpacing.spacing_3.heightBox,
                  QuestionPreview(
                    key: ValueKey(question.id),
                    question: question,
                    isPreview: false,
                    index: index + 1,
                    answer: answer,
                    onAnswerChanged: cubit.onAnswerChanged,
                  ),
                  AppSpacing.spacing_4.heightBox,
                  if (index == state.survey.questions.length - 1) _SubmitSection(cubit: cubit),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SubmitSection extends StatelessWidget {
  const _SubmitSection({required this.cubit});

  final SurveyCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurveyCubit, SurveyState>(
      buildWhen: (previous, current) => previous.submissionStatus != current.submissionStatus,
      builder: (context, state) {
        return Container(
          padding: AppSpacing.spacing_3.padding,
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.shadow.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'survey.submit.ready.title'.tr(),
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.primary,
                ),
              ),
              AppSpacing.spacing_2.heightBox,
              Text(
                'survey.submit.ready.message'.tr(),
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.spacing_3.heightBox,
              FilledButton.icon(
                onPressed: state.submissionStatus.isLoading ? null : cubit.submit,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: state.submissionStatus.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Icon(Icons.check_circle_outline_rounded),
                label: Text(
                  state.submissionStatus.isLoading
                      ? 'survey.submit.button.loading'.tr()
                      : 'survey.submit.button.default'.tr(),
                  style: context.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.colorScheme.surface,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: context.colorScheme.primary,
            ),
            AppSpacing.spacing_3.heightBox,
            Text(
              'survey.loading'.tr(),
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.colorScheme.surface,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: context.colorScheme.primary,
            ),
            AppSpacing.spacing_3.heightBox,
            Text(
              'survey.empty'.tr(),
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FailureState extends StatelessWidget {
  const _FailureState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.colorScheme.surface,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: context.colorScheme.error,
            ),
            AppSpacing.spacing_3.heightBox,
            Text(
              'survey.error'.tr(),
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
