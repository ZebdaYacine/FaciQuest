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
        child: Center(child: Text('Submit')),
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
                  question = questionType
                      .newQuestion(question ?? StarRatingQuestion(title: ''));
                  setState(() {});
                },
              ),
              Text(
                'Settings :',
                style: context.textTheme.headlineSmall,
              ),
              AppSpacing.spacing_1.heightBox,
              switch (question) {
                null => Text(
                    'Select a Type first',
                    style: context.textTheme.bodyLarge
                        ?.copyWith(color: Colors.red),
                  ),
                StarRatingQuestion() => StarRatingQuestionBuilder(
                    question: question as StarRatingQuestion,
                    onChanged: (value) {
                      question = value;
                      setState(() {});
                    },
                  ),
                MultipleChoiceQuestion() => MultipleChoiceQuestionBuilder(
                    question: question as MultipleChoiceQuestion,
                    onChanged: (value) {
                      question = value;
                      setState(() {});
                    },
                  ),
                CheckboxesQuestion() => CheckboxesQuestionBuilder(
                    question: question as CheckboxesQuestion,
                    onChanged: (value) {
                      question = value;
                      setState(() {});
                    },
                  ),
                DropdownQuestion() => DropdownQuestionBuilder(
                    question: question as DropdownQuestion,
                    onChanged: (value) {
                      question = value;
                      setState(() {});
                    },
                  ),
                FileUploadQuestion() => FileUploadQuestionBuilder(
                    question: question as FileUploadQuestion,
                    onChanged: (value) {
                      question = value;
                      setState(() {});
                    },
                  ),
                AudioRecordQuestion() => AudioRecordQuestionBuilder(
                    question: question as AudioRecordQuestion,
                    onChanged: (value) {
                      question = value;
                      setState(() {});
                    },
                  ),
                ShortAnswerQuestion() => ShortAnswerQuestionBuilder(
                    question: question as ShortAnswerQuestion,
                    onChanged: (value) {
                      question = value;
                      setState(() {});
                    },
                  ),
                CommentBoxQuestion() => CommentBoxQuestionBuilder(
                    question: question as CommentBoxQuestion,
                    onChanged: (value) {
                      question = value;
                      setState(() {});
                    },
                  ),
                SliderQuestion() => SliderQuestionBuilder(
                    question: question as SliderQuestion,
                    onChanged: (value) {
                      question = value;
                      setState(() {});
                    },
                  ),
                DateTimeQuestion() => DateTimeQuestionBuilder(
                    question: question as DateTimeQuestion,
                    onChanged: (value) {
                      question = value;
                      setState(() {});
                    },
                  ),
                MatrixQuestion() => MatrixQuestionBuilder(
                    question: question as MatrixQuestion,
                    onChanged: (value) {
                      question = value;
                      setState(() {});
                    },
                  ),
                ImageChoiceQuestion() => ImageChoiceQuestionBuilder(
                    question: question as ImageChoiceQuestion,
                    onChanged: (value) {
                      question = value;
                      setState(() {});
                    },
                  ),
                NameQuestion() => NameQuestionBuilder(
                    question: question as NameQuestion,
                    onChanged: (value) {
                      question = value;
                      setState(() {});
                    },
                  ),
                EmailAddressQuestion() => EmailAddressQuestionBuilder(
                    question: question as EmailAddressQuestion,
                    onChanged: (value) {
                      question = value;
                      setState(() {});
                    },
                  ),
              }
            ],
          ),
        ),
      ),
    );
  }
}

extension on QuestionType {
  QuestionEntity? newQuestion(QuestionEntity question) {
    switch (this) {
      case QuestionType.starRating:
        return StarRatingQuestion(title: question.title);
      case QuestionType.multipleChoice:
        return MultipleChoiceQuestion(title: question.title);
      case QuestionType.checkboxes:
        return CheckboxesQuestion(title: question.title);
      case QuestionType.dropdown:
        return DropdownQuestion(title: question.title);
      case QuestionType.fileUpload:
        return FileUploadQuestion(title: question.title);
      case QuestionType.audioRecord:
        return AudioRecordQuestion(title: question.title);
      case QuestionType.shortAnswer:
        return ShortAnswerQuestion(title: question.title);
      case QuestionType.commentBox:
        return CommentBoxQuestion(title: question.title);
      case QuestionType.slider:
        return SliderQuestion(title: question.title);
      case QuestionType.dateTime:
        return DateTimeQuestion(title: question.title);
      case QuestionType.matrix:
        return MatrixQuestion(title: question.title);
      case QuestionType.imageChoice:
        return ImageChoiceQuestion(title: question.title);
      case QuestionType.nameType:
        return NameQuestion(title: question.title);
      case QuestionType.emailAddress:
        return EmailAddressQuestion(title: question.title);
      case QuestionType.phoneNumber:
      // TODO: Handle this case.
      case QuestionType.address:
      // TODO: Handle this case.
      case QuestionType.text:
      // TODO: Handle this case.
      case QuestionType.image:
      // TODO: Handle this case.
    }
    return null;
  }
}
