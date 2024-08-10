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
                      child: Text(e.name),
                    );
                  },
                ).toList(),
                onChanged: (questionType) {
                  this.questionType = questionType;
                  switch (questionType) {
                    case null:
                      return;
                    case QuestionType.starRating:
                      question = StarRatingQuestion(
                        title: question?.title ?? '',
                      );
                    case QuestionType.multipleChoice:
                      question = MultipleChoiceQuestion(
                        title: question?.title ?? '',
                      );
                    case QuestionType.checkboxes:
                      question = CheckboxesQuestion(
                        title: question?.title ?? '',
                      );
                    case QuestionType.dropdown:
                    // question = const DropdownQuestion();
                    case QuestionType.fileUpload:
                    // question = const FileUploadQuestion();
                    case QuestionType.imageChoice:
                    // question = const ImageChoiceQuestion();
                    case QuestionType.commentBox:
                    // question = const CommentBoxQuestion();
                    case QuestionType.slider:
                    // question = const SliderQuestion();
                    case QuestionType.dateTime:
                    // question = const DateTimeQuestion();
                  }
                  setState(() {});
                },
              ),
              Text(
                'Settings :',
                style: context.textTheme.headlineSmall,
              ),
              switch (question) {
                null => Text('Select a Type first'),
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
              }
            ],
          ),
        ),
      ),
    );
  }
}
