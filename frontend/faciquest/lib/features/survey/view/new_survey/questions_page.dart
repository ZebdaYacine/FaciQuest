import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionsPage extends StatelessWidget {
  const QuestionsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Questions Section',
                  style: context.textTheme.headlineLarge,
                ),
                const Text('Please enter details below'),
                AppSpacing.spacing_2.heightBox,
                BlocSelector<NewSurveyCubit, NewSurveyState,
                        List<QuestionEntity>>(
                    selector: (state) => state.survey.questions,
                    builder: (context, questions) {
                      return Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            if (index >= questions.length) {
                              return ElevatedButton.icon(
                                onPressed: () => showQuestionModal(context),
                                icon: const Icon(Icons.add),
                                label: const Center(
                                  child: Text('New Question'),
                                ),
                              );
                            }
                            return QuestionPreview(question: questions[index]);
                          },
                          separatorBuilder: (context, index) =>
                              AppSpacing.spacing_1.heightBox,
                          itemCount: questions.length + 1,
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
        Padding(
          padding: AppSpacing.spacing_2.padding,
          child: Row(
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: context.colorScheme.error,
                  ),
                  foregroundColor: context.colorScheme.error,
                ),
                onPressed: () => context.read<NewSurveyCubit>().back(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
              ),
              AppSpacing.spacing_0_5.widthBox,
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: context.colorScheme.onPrimary,
                    backgroundColor: context.colorScheme.primary,
                  ),
                  onPressed: () => context.pop(),
                  child: const Center(child: Text('Submit Survey')),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
