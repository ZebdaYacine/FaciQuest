import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';

import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class QuestionPreview extends StatelessWidget {
  const QuestionPreview({
    super.key,
    required this.question,
  });

  final QuestionEntity question;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!(question is TextQuestion || question is ImageQuestion)) ...[
          Text('${question.order}. ${question.title}'),
          AppSpacing.spacing_1.heightBox,
        ],
        switch (question) {
          StarRatingQuestion() => StarRatingQuestionPreview(
              question: question as StarRatingQuestion,
            ),
          MultipleChoiceQuestion() => MultipleChoiceQuestionPreview(
              question: question as MultipleChoiceQuestion,
            ),
          CheckboxesQuestion() => CheckboxesQuestionPreview(
              question: question as CheckboxesQuestion,
            ),
          DropdownQuestion() => DropdownQuestionPreview(
              question: question as DropdownQuestion,
            ),
          FileUploadQuestion() => FileUploadQuestionPreview(
              question: question as FileUploadQuestion,
            ),
          AudioRecordQuestion() => AudioRecordQuestionPreview(
              question: question as AudioRecordQuestion,
            ),
          ShortAnswerQuestion() => ShortTextQuestionPreview(
              question: question as ShortAnswerQuestion,
            ),
          CommentBoxQuestion() => CommentBoxQuestionPreview(
              question: question as CommentBoxQuestion,
            ),
          SliderQuestion() => SliderQuestionPreview(
              question: question as SliderQuestion,
            ),
          DateTimeQuestion() => DateTimeQuestionPreview(
              question: question as DateTimeQuestion,
            ),
          MatrixQuestion() => MatrixQuestionPreview(
              question: question as MatrixQuestion,
            ),
          ImageChoiceQuestion() => ImageChoiceQuestionPreview(
              question: question as ImageChoiceQuestion,
            ),
          NameQuestion() => NameQuestionPreview(
              question: question as NameQuestion,
            ),
          EmailAddressQuestion() => EmailAddressQuestionPreview(
              question: question as EmailAddressQuestion,
            ),
          PhoneQuestion() => PhoneQuestionPreview(
              question: question as PhoneQuestion,
            ),
          AddressQuestion() => AddressQuestionPreview(
              question: question as AddressQuestion,
            ),
          TextQuestion() => TextQuestionPreview(
              question: question as TextQuestion,
            ),
          ImageQuestion() => ImageQuestionPreview(
              question: question as ImageQuestion,
            ),
        }
      ],
    );
  }
}
