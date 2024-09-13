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
    final cubit = context.read<NewSurveyCubit>();
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
                BlocBuilder<NewSurveyCubit, NewSurveyState>(
                    builder: (context, state) {
                  return Expanded(
                    child: ReorderableListView.builder(
                      footer: ElevatedButton.icon(
                        onPressed: () => showQuestionModal(
                          context,
                          likertScale: state.survey.likertScale,
                          onSubmit: (value) {
                            cubit.newQuestion(
                              value.copyWith(),
                            );
                          },
                        ),
                        icon: const Icon(Icons.add),
                        label: const Center(
                          child: Text('New Question'),
                        ),
                      ),
                      buildDefaultDragHandles: true,
                      onReorder: (oldIndex, newIndex) {
                        cubit.reorder(oldIndex, newIndex);
                      },
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          key: Key('$index'),
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            showQuestionModal(
                              context,
                              question: state.survey.questions[index],
                              likertScale: state.survey.likertScale,
                            );
                          },
                          child: IgnorePointer(
                            child: Card(
                              child: ListTile(
                                contentPadding: 0.padding,
                                minLeadingWidth: 8,
                                leading: const SizedBox(
                                  width: 8,
                                  child: Icon(Icons.drag_indicator),
                                ),
                                title: QuestionPreview(
                                  question: state.survey.questions[index],
                                  index: index + 1,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: state.survey.questions.length,
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

class ReOrderableHandle extends StatelessWidget {
  const ReOrderableHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.reorder);
  }
}
