import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/core/widgets/widgets.dart';
import 'package:faciquest/features/survey/survey.dart';

import 'package:flutter/material.dart';

Future<void> showQuestionModal(
  BuildContext context, {
  QuestionEntity? question,
}) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => AppBackDrop(
      titleText: 'Question',
      headerActions: BackdropHeaderActions.none,
      paddingBody: 0.padding,
      body: EditView(
        question: question,
      ),
      actions: FilledButton(
        onPressed: () {},
        child: const Center(child: Text('Submit')),
      ),
    ),
  );
}

class EditView extends StatefulWidget {
  const EditView({
    super.key,
    this.question,
  });

  final QuestionEntity? question;

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> with BuildFormMixin {
  QuestionEntity? question;
  QuestionType? questionType;
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
              if ((question.runtimeType != TextQuestion &&
                  question.runtimeType != ImageQuestion))
                buildInputForm(
                  'Q*:',
                ),
              AppSpacing.spacing_1.heightBox,
              DropdownButton(
                value: questionType,
                isExpanded: true,
                items: QuestionType.values.map(
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
                  question = questionType.newQuestion(
                    question ??
                        const StarRatingQuestion(
                          title: '',
                          order: 0,
                        ),
                  );
                  setState(() {});
                },
              ),
              Text(
                'Settings :',
                style: context.textTheme.headlineSmall,
              ),
              AppSpacing.spacing_1.heightBox,
              if (question == null)
                Text(
                  'Please select a question type',
                  style: context.textTheme.bodySmall,
                )
              else
                QuestionBuilder.create(
                  question!,
                  (value) {
                    question = value;
                    setState(() {});
                  },
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
