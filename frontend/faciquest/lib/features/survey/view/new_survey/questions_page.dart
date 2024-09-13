import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
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
                          return Card(
                            key: Key('$index'),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    showQuestionModal(
                                      context,
                                      question: state.survey.questions[index],
                                      likertScale: state.survey.likertScale,
                                    );
                                  },
                                  child: IgnorePointer(
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
                                Positioned(
                                  right: 0,
                                  child: questionActions(
                                    context,
                                    index,
                                    state,
                                    cubit,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: state.survey.questions.length,
                      ),
                    );
                  },
                ),
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
                child: BlocBuilder<NewSurveyCubit, NewSurveyState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: context.colorScheme.onPrimary,
                        backgroundColor: context.colorScheme.primary,
                      ),
                      onPressed: !state.survey.isValid || state.status.isLoading
                          ? null
                          : () => cubit.submitSurvey(),
                      child: Center(
                          child: state.status.isLoading
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator())
                              : const Text('Submit Survey')),
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Column questionActions(BuildContext context, int index, NewSurveyState state,
      NewSurveyCubit cubit) {
    return Column(
      children: [
        IconButton.filled(
          icon: const Icon(Icons.change_circle_outlined),
          onPressed: () async {
            final newQuestions = await showMoveBottomSheet(
              context,
              index: index,
              questions: state.survey.questions,
            );

            if (newQuestions == null) return;
            cubit.newQuestionsList(newQuestions);
          },
        ),
        AppSpacing.spacing_1.widthBox,
        IconButton.filled(
          icon: const Icon(Icons.copy),
          onPressed: () async {
            final newQuestions = await showMoveBottomSheet(
              context,
              index: index,
              questions: state.survey.questions,
              copy: true,
            );

            if (newQuestions == null) return;
            cubit.newQuestionsList(newQuestions);
          },
        ),
        AppSpacing.spacing_1.widthBox,
        IconButton.outlined(
          style: IconButton.styleFrom(
            foregroundColor: context.colorScheme.error,
          ),
          icon: const Icon(
            Icons.delete,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Delete Question'),
                  content: const Text(
                      'Are you sure you want to delete this question?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () {
                          cubit.removeQuestion(
                            index,
                          );
                          Navigator.pop(context);
                        },
                        child: const Text('Delete')),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  Future<List<QuestionEntity>?> showMoveBottomSheet(
    BuildContext context, {
    List<QuestionEntity>? questions,
    required int index,
    bool copy = false,
  }) {
    int? newIndex = index;
    MoveQuestionAction? action = MoveQuestionAction.after;
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AppBackDrop(
            headerActions: BackdropHeaderActions.none,
            showDivider: false,
            showHeaderContent: false,
            // showHeader: false,
            body: MoveQuestionBottomSheetBody(
              questions: questions ?? [],
              action: action,
              index: newIndex,
              copy: copy,
              onActionChanged: (value) {
                action = value;
                setState(() {});
              },
              onIndexChanged: (value) {
                newIndex = value;
                setState(() {});
              },
            ),
            actions: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: context.colorScheme.onPrimary,
                backgroundColor: context.colorScheme.primary,
              ),
              onPressed: () {
                if (action == null || newIndex == null) return;

                // Ensure there are enough questions to perform the action
                if ((questions ?? []).length <= 1) {
                  return;
                }

                // Create a copy of the list
                final temp = List<QuestionEntity>.from(questions ?? []);
                final item = temp.elementAt(index);

                // If the item is being moved, remove it from the current position
                if (!copy) {
                  temp.removeAt(index);
                }

                // Adjust the newIndex based on the action
                switch (action!) {
                  case MoveQuestionAction.after:
                    newIndex = newIndex! + 1;
                    break;

                  case MoveQuestionAction.before:
                    newIndex = newIndex! - 1;
                    break;
                }

                // Ensure the newIndex stays within the valid range of the list
                newIndex = newIndex!.clamp(0, temp.length);

                // Insert the item at the new position
                temp.insert(newIndex!, item);

                // Pop with the result
                context.pop(result: temp);
              },
              child: Center(child: Text('${copy ? 'Copy' : 'Move'} Question')),
            ),
          );
        });
      },
    );
  }
}

class MoveQuestionBottomSheetBody extends StatelessWidget {
  const MoveQuestionBottomSheetBody({
    super.key,
    this.questions = const [],
    this.onActionChanged,
    this.onIndexChanged,
    this.action,
    this.index,
    this.copy = false,
  });
  final List<QuestionEntity> questions;
  final ValueChanged<MoveQuestionAction?>? onActionChanged;
  final ValueChanged<int?>? onIndexChanged;
  final MoveQuestionAction? action;
  final int? index;
  final bool copy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${copy ? 'Copy' : 'Move'} this question to ....',
          style: context.textTheme.titleLarge,
        ),
        AppSpacing.spacing_2.heightBox,
        Row(
          children: [
            DropdownButton<MoveQuestionAction>(
              isExpanded: false,
              value: action,
              items: const [
                DropdownMenuItem(
                  value: MoveQuestionAction.after,
                  child: Text('After'),
                ),
                DropdownMenuItem(
                  value: MoveQuestionAction.before,
                  child: Text('Before'),
                ),
              ],
              onChanged: onActionChanged,
            ),
            AppSpacing.spacing_2.widthBox,
            Expanded(
              child: DropdownButton<int>(
                value: index,
                isExpanded: true,
                items: questions.mapIndexed(
                  (index, element) {
                    return DropdownMenuItem(
                      value: index,
                      child: Text('${index + 1}. ${element.title}'),
                    );
                  },
                ).toList(),
                onChanged: onIndexChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

enum MoveQuestionAction {
  after,
  before,
}
