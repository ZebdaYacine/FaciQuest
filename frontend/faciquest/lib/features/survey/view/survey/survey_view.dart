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
    return BlocProvider(
      create: (context) => SurveyCubit(),
      child: BlocBuilder<SurveyCubit, SurveyState>(
        builder: (context, state) {
          if (state.status.isLoading) return const _LoadingState();
          if (state.status.isFailure) return const _FailureState();
          if (state.survey.isEmpty) return const _EmptyState();
          return Scaffold(
            appBar: AppBar(
              title: Text(state.survey.name),
              centerTitle: false,
            ),
            body: ListView.builder(
              itemCount: state.survey.questions.length,
              itemBuilder: (context, index) {
                final question = state.survey.questions[index];
                return QuestionPreview(
                  question: question,
                  isPreview: false,
                  
                );
              },
            ),
          );
        },
      ),
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
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}

class _FailureState extends StatelessWidget {
  const _FailureState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
