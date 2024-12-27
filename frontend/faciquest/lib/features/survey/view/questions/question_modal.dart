import 'package:awesome_extensions/awesome_extensions.dart';
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
          titleText: 'Add Question',
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
            label: const Text('Submit Question'),
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
              if ((widget.question.runtimeType != TextQuestion &&
                  widget.question.runtimeType != ImageQuestion)) ...[
                Text(
                  'Question Title',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.primary,
                  ),
                ),
                AppSpacing.spacing_2.heightBox,
                TextFormField(
                  initialValue: widget.question?.title,
                  decoration: InputDecoration(
                    hintText: 'Enter your question here',
                    filled: true,
                    fillColor: context.colorScheme.surfaceContainerHighest
                        .withOpacity(0.3),
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
                      ));
                    }
                  },
                ),
              ],
              AppSpacing.spacing_3.heightBox,
              Text(
                'Question Type',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.primary,
                ),
              ),
              AppSpacing.spacing_2.heightBox,
              Container(
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHighest
                      .withOpacity(0.3),
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
                              e.name,
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
                          ),
                    ));
                    setState(() {});
                  },
                ),
              ),
              AppSpacing.spacing_4.heightBox,
              Text(
                'Question Settings',
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
                          'Please select a question type to configure settings',
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
                    color: context.colorScheme.surfaceContainerHighest
                        .withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: QuestionBuilder.create(
                    widget.question!,
                    (value) {
                      widget.onChang?.call(value.copyWith(
                        title: widget.question?.title ?? title,
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

extension on QuestionType {
  QuestionEntity newQuestion(QuestionEntity question) {
    switch (this) {
      case QuestionType.starRating:
        return StarRatingQuestion.copyFrom(question);
      case QuestionType.multipleChoice:
        return MultipleChoiceQuestion.copyFrom(question);
      case QuestionType.checkboxes:
        return CheckboxesQuestion.copyFrom(question);
      case QuestionType.dropdown:
        return DropdownQuestion.copyFrom(question);
      case QuestionType.fileUpload:
        return FileUploadQuestion.copyFrom(question);
      case QuestionType.audioRecord:
        return AudioRecordQuestion.copyFrom(question);
      case QuestionType.shortAnswer:
        return ShortAnswerQuestion.copyFrom(question);
      case QuestionType.commentBox:
        return CommentBoxQuestion.copyFrom(question);
      case QuestionType.slider:
        return SliderQuestion.copyFrom(question);
      case QuestionType.dateTime:
        return DateTimeQuestion.copyFrom(question);
      case QuestionType.matrix:
        return MatrixQuestion.copyFrom(question);
      case QuestionType.imageChoice:
        return ImageChoiceQuestion.copyFrom(question);
      case QuestionType.nameType:
        return NameQuestion.copyFrom(question);
      case QuestionType.emailAddress:
        return EmailAddressQuestion.copyFrom(question);
      case QuestionType.phoneNumber:
        return PhoneQuestion.copyFrom(question);
      case QuestionType.address:
        return AddressQuestion.copyFrom(question);
      case QuestionType.text:
        return TextQuestion.copyFrom(question);
      case QuestionType.image:
        return ImageQuestion.copyFrom(question);
    }
  }
}
