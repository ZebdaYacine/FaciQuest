import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';
import 'package:objectid/objectid.dart';

Future<void> showQuestionModal(
  BuildContext context, {
  QuestionEntity? question,
  LikertScale? likertScale,
  ValueChanged<QuestionEntity>? onSubmit,
}) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(builder: (context, setState) {
      return Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: AppBackDrop(
          titleText: 'questionModal.Add Question'.tr(),
          showHeaderContent: false,
          showDivider: false,
          headerActions: BackdropHeaderActions.none,
          paddingBody: 0.padding,
          body: EditView(
            question: question,
            likertScale: likertScale,
            onChang: (value) {
              question = value;
              setState(() {});
            },
          ),
          actions: FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: (question?.isValid ?? false)
                ? () {
                    onSubmit?.call(question!);
                    context.pop();
                  }
                : null,
            icon: const Icon(Icons.check_rounded),
            label: const Text('questionModal.Submit Question').tr(),
          ),
        ),
      );
    }),
  );
}

class EditView extends StatefulWidget {
  const EditView({
    super.key,
    this.question,
    this.likertScale,
    this.onChang,
  });

  final QuestionEntity? question;
  final LikertScale? likertScale;
  final ValueChanged<QuestionEntity>? onChang;

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> with BuildFormMixin {
  QuestionType? questionType;
  String title = '';
  bool isRequired = false;

  @override
  void initState() {
    super.initState();
    title = widget.question?.title ?? '';
    isRequired = widget.question?.isRequired ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: context.height * 0.7,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((widget.question.runtimeType != TextQuestion && widget.question.runtimeType != ImageQuestion)) ...[
                Text(
                  'questionModal.Question Title'.tr(),
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.primary,
                  ),
                ),
                AppSpacing.spacing_2.heightBox,
                TextFormField(
                  initialValue: widget.question?.title,
                  decoration: InputDecoration(
                    hintText: 'questionModal.Enter your question here'.tr(),
                    filled: true,
                    fillColor: context.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    title = value;
                    if (widget.question != null) {
                      widget.onChang?.call(widget.question!.copyWith(
                        title: title,
                        isRequired: isRequired,
                      ));
                    }
                  },
                ),
                AppSpacing.spacing_3.heightBox,
                // Required Question Checkbox
                if (widget.question?.runtimeType != TextQuestion && widget.question?.runtimeType != ImageQuestion)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: context.colorScheme.outline.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isRequired,
                          activeColor: context.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          onChanged: (value) {
                            setState(() {
                              isRequired = value ?? false;
                            });
                            if (widget.question != null) {
                              widget.onChang?.call(widget.question!.copyWith(
                                isRequired: isRequired,
                              ));
                            }
                          },
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'questionModal.required_question'.tr(),
                                style: context.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: context.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'questionModal.required_question_description'.tr(),
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: context.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
              AppSpacing.spacing_3.heightBox,
              Text(
                'questionModal.Question Type'.tr(),
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.primary,
                ),
              ),
              AppSpacing.spacing_2.heightBox,
              Container(
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButton(
                  value: widget.question?.type ?? questionType,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: QuestionType.values
                      .where(
                    (type) =>
                        type != QuestionType.audioRecord &&
                        type != QuestionType.dateTime &&
                        type != QuestionType.matrix,
                  )
                      .map(
                    (e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Row(
                          children: [
                            Icon(
                              e.icon,
                              color: context.colorScheme.primary,
                            ),
                            AppSpacing.spacing_2.widthBox,
                            Text(
                              "survey.QuestionType.${e.name}".tr(),
                              style: context.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (questionType) {
                    this.questionType = questionType;
                    if (questionType == null) return;
                    widget.onChang?.call(questionType.newQuestion(
                      widget.question?.copyWith(
                            title: title,
                          ) ??
                          StarRatingQuestion(
                            id: ObjectId().hexString,
                            title: title,
                            order: 0,
                            isRequired: isRequired,
                          ),
                      isRequired: isRequired,
                    ));
                    setState(() {});
                  },
                ),
              ),
              AppSpacing.spacing_4.heightBox,
              Text(
                'questionModal.Question Settings'.tr(),
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.primary,
                ),
              ),
              AppSpacing.spacing_2.heightBox,
              if (widget.question == null)
                Container(
                  padding: AppSpacing.spacing_3.padding,
                  decoration: BoxDecoration(
                    color: context.colorScheme.errorContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: context.colorScheme.error,
                      ),
                      AppSpacing.spacing_2.widthBox,
                      Expanded(
                        child: Text(
                          'questionModal.Please select a question type to configure settings'.tr(),
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: AppSpacing.spacing_3.padding,
                  decoration: BoxDecoration(
                    color: context.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: QuestionBuilder.create(
                    widget.question!,
                    (value) {
                      widget.onChang?.call(value.copyWith(
                        title: widget.question?.title ?? title,
                        isRequired: isRequired,
                      ));
                      setState(() {});
                    },
                    widget.likertScale,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper function to safely apply isRequired to any question type
QuestionEntity _applyIsRequired(QuestionEntity question, bool isRequired) {
  try {
    return question.copyWith(isRequired: isRequired);
  } catch (e) {
    // If copyWith doesn't support isRequired, create a new question with isRequired
    switch (question.type) {
      case QuestionType.starRating:
        return StarRatingQuestion(
          id: question.id,
          title: question.title,
          order: question.order,
          isRequired: isRequired,
        );
      case QuestionType.multipleChoice:
        return MultipleChoiceQuestion(
          id: question.id,
          title: question.title,
          order: question.order,
          isRequired: isRequired,
        );
      case QuestionType.shortAnswer:
        return ShortAnswerQuestion(
          id: question.id,
          title: question.title,
          order: question.order,
          isRequired: isRequired,
        );
      default:
        // For unsupported types, return the original question
        // TODO: Update other question types to support isRequired
        return question;
    }
  }
}

extension on QuestionType {
  QuestionEntity newQuestion(QuestionEntity question, {bool isRequired = false}) {
    switch (this) {
      case QuestionType.starRating:
        return StarRatingQuestion.copyFrom(question, isRequired: isRequired);
      case QuestionType.multipleChoice:
        return MultipleChoiceQuestion.copyFrom(question, isRequired: isRequired);
      case QuestionType.shortAnswer:
        return ShortAnswerQuestion.copyFrom(question);
      default:
        final baseQuestion = switch (this) {
          QuestionType.checkboxes => CheckboxesQuestion.copyFrom(question, isRequired: isRequired),
          QuestionType.dropdown => DropdownQuestion.copyFrom(question, isRequired: isRequired),
          QuestionType.commentBox => CommentBoxQuestion.copyFrom(question, isRequired: isRequired),
          QuestionType.fileUpload => FileUploadQuestion.copyFrom(question),
          QuestionType.audioRecord => AudioRecordQuestion.copyFrom(question),
          QuestionType.slider => SliderQuestion.copyFrom(question, isRequired: isRequired),
          QuestionType.dateTime => DateTimeQuestion.copyFrom(question),
          QuestionType.matrix => MatrixQuestion.copyFrom(question),
          QuestionType.imageChoice => ImageChoiceQuestion.copyFrom(question),
          QuestionType.nameType => NameQuestion.copyFrom(question),
          QuestionType.emailAddress => EmailAddressQuestion.copyFrom(question),
          QuestionType.phoneNumber => PhoneQuestion.copyFrom(question),
          QuestionType.address => AddressQuestion.copyFrom(question),
          QuestionType.text => TextQuestion.copyFrom(question),
          QuestionType.image => ImageQuestion.copyFrom(question),
          _ => question,
        };
        return _applyIsRequired(baseQuestion, isRequired);
    }
  }
}
