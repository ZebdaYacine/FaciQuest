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
    builder: (context) => StatefulBuilder(builder: (context, setState) {
      return AppBackDrop(
        titleText: 'Question',
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
        actions: FilledButton(
          onPressed: (question?.isValid ?? false)
              ? () {
                  onSubmit?.call(question!);
                  context.pop();
                }
              : null,
          child: const Center(child: Text('Submit')),
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((widget.question.runtimeType != TextQuestion &&
                  widget.question.runtimeType != ImageQuestion))
                TextFormField(
                  initialValue: widget.question?.title,
                  decoration: const InputDecoration(
                    hintText: 'Put Question here',
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
              AppSpacing.spacing_1.heightBox,
              DropdownButton(
                value: widget.question?.type ?? questionType,
                isExpanded: true,
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
                          Icon(e.icon),
                          AppSpacing.spacing_1.widthBox,
                          Text(e.name),
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
              Text(
                'Settings :',
                style: context.textTheme.headlineSmall,
              ),
              AppSpacing.spacing_1.heightBox,
              if (widget.question == null)
                Text(
                  'Please select a widget.question type',
                  style: context.textTheme.bodySmall,
                )
              else
                QuestionBuilder.create(
                  widget.question!,
                  (value) {
                    widget.onChang?.call(value.copyWith(
                      title: widget.question?.title ?? title,
                    ));
                    setState(() {});
                  },
                  widget.likertScale,
                )
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
