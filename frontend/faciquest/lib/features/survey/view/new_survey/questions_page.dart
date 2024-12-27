import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:collection/collection.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionsPage extends StatelessWidget {
  const QuestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          child: _QuestionsContent(),
        ),
        _BottomActions(),
      ],
    );
  }
}

class _QuestionsContent extends StatelessWidget {
  const _QuestionsContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.spacing_3.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Questions Section',
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
          const Expanded(
            child: _QuestionsList(),
          ),
        ],
      ),
    );
  }
}

class _QuestionsList extends StatelessWidget {
  const _QuestionsList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewSurveyCubit, NewSurveyState>(
      builder: (context, state) {
        return ReorderableListView.builder(
          footer: _AddQuestionButton(likertScale: state.survey.likertScale),
          buildDefaultDragHandles: true,
          onReorder: (oldIndex, newIndex) {
            context.read<NewSurveyCubit>().reorder(oldIndex, newIndex);
          },
          itemBuilder: (context, index) {
            final question = state.survey.questions[index];
            return _QuestionCard(
              key: Key(question.id),
              index: index,
              question: question,
              likertScale: state.survey.likertScale,
            );
          },
          itemCount: state.survey.questions.length,
        );
      },
    );
  }
}

class _AddQuestionButton extends StatelessWidget {
  const _AddQuestionButton({required this.likertScale});

  final LikertScale? likertScale;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppSpacing.spacing_2.verticalPadding,
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          padding: AppSpacing.spacing_2.padding,
        ),
        onPressed: () => showQuestionModal(
          context,
          likertScale: likertScale,
          onSubmit: (value) {
            context.read<NewSurveyCubit>().newQuestion(value.copyWith());
          },
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add New Question'),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    super.key,
    required this.index,
    required this.question,
    required this.likertScale,
  });

  final int index;
  final QuestionEntity question;
  final LikertScale? likertScale;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: AppSpacing.spacing_1.verticalPadding,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 150),
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _showEditModal(context),
              child: IgnorePointer(
                child: Row(
                  children: [
                    const Icon(Icons.drag_indicator_rounded),
                    Expanded(
                      child: QuestionPreview(
                        question: question,
                        index: index + 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: _QuestionActions(index: index),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditModal(BuildContext context) {
    showQuestionModal(
      context,
      question: question,
      likertScale: likertScale,
      onSubmit: (value) {
        context.read<NewSurveyCubit>().refreshList(value, index);
      },
    );
  }
}

class _QuestionActions extends StatelessWidget {
  const _QuestionActions({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MoveButton(index: index),
          AppSpacing.spacing_1.widthBox,
          _CopyButton(index: index),
          AppSpacing.spacing_1.widthBox,
          _DeleteButton(index: index),
        ],
      ),
    );
  }
}

class _MoveButton extends StatelessWidget {
  const _MoveButton({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewSurveyCubit, NewSurveyState>(
      builder: (context, state) {
        return IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: context.colorScheme.primaryContainer,
            foregroundColor: context.colorScheme.primary,
          ),
          icon: const Icon(Icons.change_circle_outlined),
          onPressed: () async {
            final newQuestions = await showMoveBottomSheet(
              context,
              index: index,
              questions: state.survey.questions,
            );

            if (newQuestions == null) return;
            context.read<NewSurveyCubit>().newQuestionsList(newQuestions);
          },
        );
      },
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewSurveyCubit, NewSurveyState>(
      builder: (context, state) {
        return IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: context.colorScheme.secondaryContainer,
            foregroundColor: context.colorScheme.secondary,
          ),
          icon: const Icon(Icons.copy_rounded),
          onPressed: () async {
            final newQuestions = await showMoveBottomSheet(
              context,
              index: index,
              questions: state.survey.questions,
              copy: true,
            );

            if (newQuestions == null) return;
            context.read<NewSurveyCubit>().newQuestionsList(newQuestions);
          },
        );
      },
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      style: IconButton.styleFrom(
        backgroundColor: context.colorScheme.errorContainer,
        foregroundColor: context.colorScheme.error,
      ),
      icon: const Icon(Icons.delete_rounded),
      onPressed: () => _showDeleteDialog(context),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Delete Question',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this question?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: context.colorScheme.error,
              ),
              onPressed: () {
                context.read<NewSurveyCubit>().removeQuestion(index);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class _BottomActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Row(
        children: [
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: AppSpacing.spacing_2.horizontalPadding,
              side: BorderSide(
                color: context.colorScheme.error,
              ),
              foregroundColor: context.colorScheme.error,
            ),
            onPressed: () => context.read<NewSurveyCubit>().back(),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Back'),
          ),
          AppSpacing.spacing_2.widthBox,
          const Expanded(
            flex: 2,
            child: _SubmitButton(),
          ),
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewSurveyCubit, NewSurveyState>(
      builder: (context, state) {
        return FilledButton.icon(
          style: FilledButton.styleFrom(
            padding: AppSpacing.spacing_2.horizontalPadding,
            minimumSize: const Size.fromHeight(48),
          ),
          onPressed: !state.survey.isValid || state.status.isLoading
              ? null
              : () => context.read<NewSurveyCubit>().submitSurvey(),
          icon: state.status.isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: context.colorScheme.onPrimary,
                  ),
                )
              : const Icon(Icons.check_rounded),
          label: const Text('Submit Survey'),
        );
      },
    );
  }
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
          actions: FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: () {
              if (action == null || newIndex == null) return;

              if ((questions ?? []).isEmpty) {
                return;
              }

              final temp = List<QuestionEntity>.from(questions ?? []);
              final item = temp.elementAt(index);

              if (!copy) {
                temp.removeAt(index);
              }

              switch (action!) {
                case MoveQuestionAction.after:
                  newIndex = newIndex! + 1;
                  break;
                case MoveQuestionAction.before:
                  newIndex = newIndex! - 1;
                  break;
              }

              newIndex = newIndex!.clamp(0, temp.length);
              temp.insert(newIndex!, item);
              context.pop(result: temp);
            },
            icon: Icon(copy ? Icons.copy_rounded : Icons.move_up_rounded),
            label: Text('${copy ? 'Copy' : 'Move'} Question'),
          ),
        );
      });
    },
  );
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
          '${copy ? 'Copy' : 'Move'} this question to...',
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpacing.spacing_3.heightBox,
        Row(
          children: [
            Container(
              padding: AppSpacing.spacing_1.horizontalPadding,
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<MoveQuestionAction>(
                isExpanded: false,
                value: action,
                underline: const SizedBox(),
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
            ),
            AppSpacing.spacing_2.widthBox,
            Expanded(
              child: Container(
                padding: AppSpacing.spacing_1.horizontalPadding,
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<int>(
                  value: index,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: questions.mapIndexed(
                    (index, element) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text(
                          '${index + 1}. ${element.title}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: onIndexChanged,
                ),
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
