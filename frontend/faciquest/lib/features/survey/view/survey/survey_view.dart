import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SurveyView extends StatelessWidget {
  const SurveyView({
    super.key,
    required this.surveyId,
  });
  final String surveyId;

  @override
  Widget build(BuildContext context) {
    final cubit = SurveyCubit(
      surveyId: surveyId,
      repository: getIt<SurveyRepository>(),
    )..getSurvey();
    return Builder(
      builder: (_) {
        return BlocProvider(
          create: (context) => cubit,
          child: BlocBuilder<SurveyCubit, SurveyState>(
            buildWhen: (previous, current) => previous.survey != current.survey,
            builder: (context, state) {
              if (state.status.isLoading) return const _LoadingState();
              if (state.status.isFailure) return const _FailureState();
              if (state.survey.isEmpty) return const _EmptyState();
              return Scaffold(
                appBar: AppBar(
                  title: Text(state.survey.name),
                  centerTitle: false,
                ),
                body: ListView.separated(
                  separatorBuilder: (context, index) =>
                      AppSpacing.spacing_1.heightBox,
                  itemCount: state.survey.questions.length + 1,
                  padding: AppSpacing.spacing_2.padding,
                  itemBuilder: (context, index) {
                    if (index >= state.survey.questions.length) {
                      return BlocBuilder<SurveyCubit, SurveyState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state.submissionStatus.isLoading
                                ? null
                                : cubit.submit,
                            child: Center(
                              child: state.submissionStatus.isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text('Submit'),
                            ),
                          );
                        },
                      );
                    }
                    final question = state.survey.questions[index];
                    final answer = state.answers.firstWhereOrNull(
                      (element) => element.questionId == question.id,
                    );
                    return QuestionPreview(
                      question: question,
                      isPreview: false,
                      index: index + 1,
                      answer: answer,
                      onAnswerChanged: cubit.onAnswerChanged,
                    );
                  },
                ),
              );
            },
          ),
        );
      }
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Title ....'),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Survey not found'),
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
        title: const Text('Failure'),
      ),
    );
  }
}
