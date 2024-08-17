import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

abstract class QuestionBuilder extends StatefulWidget {
  final QuestionEntity question;
  final ValueChanged<QuestionEntity>? onChanged;

  const QuestionBuilder({
    required this.question,
    this.onChanged,
    super.key,
  });

  static final _builderMap =
      <Type, Function(QuestionEntity, ValueChanged<QuestionEntity>?)>{
    StarRatingQuestion: (question, onChanged) => StarRatingQuestionBuilder(
          question: question as StarRatingQuestion,
          onChanged: onChanged,
        ),
    MultipleChoiceQuestion: (question, onChanged) =>
        MultipleChoiceQuestionBuilder(
          question: question as MultipleChoiceQuestion,
          onChanged: onChanged,
        ),
    CheckboxesQuestion: (question, onChanged) => CheckboxesQuestionBuilder(
          question: question as CheckboxesQuestion,
          onChanged: onChanged,
        ),
    DropdownQuestion: (question, onChanged) => DropdownQuestionBuilder(
          question: question as DropdownQuestion,
          onChanged: onChanged,
        ),
    FileUploadQuestion: (question, onChanged) => FileUploadQuestionBuilder(
          question: question as FileUploadQuestion,
          onChanged: onChanged,
        ),
    AudioRecordQuestion: (question, onChanged) => AudioRecordQuestionBuilder(
          question: question as AudioRecordQuestion,
          onChanged: onChanged,
        ),
    ShortAnswerQuestion: (question, onChanged) => ShortAnswerQuestionBuilder(
          question: question as ShortAnswerQuestion,
          onChanged: onChanged,
        ),
    CommentBoxQuestion: (question, onChanged) => CommentBoxQuestionBuilder(
          question: question as CommentBoxQuestion,
          onChanged: onChanged,
        ),
    SliderQuestion: (question, onChanged) => SliderQuestionBuilder(
          question: question as SliderQuestion,
          onChanged: onChanged,
        ),
    DateTimeQuestion: (question, onChanged) => DateTimeQuestionBuilder(
          question: question as DateTimeQuestion,
          onChanged: onChanged,
        ),
    MatrixQuestion: (question, onChanged) => MatrixQuestionBuilder(
          question: question as MatrixQuestion,
          onChanged: onChanged,
        ),
    ImageChoiceQuestion: (question, onChanged) => ImageChoiceQuestionBuilder(
          question: question as ImageChoiceQuestion,
          onChanged: onChanged,
        ),
    NameQuestion: (question, onChanged) => NameQuestionBuilder(
          question: question as NameQuestion,
          onChanged: onChanged,
        ),
    EmailAddressQuestion: (question, onChanged) => EmailAddressQuestionBuilder(
          question: question as EmailAddressQuestion,
          onChanged: onChanged,
        ),
    PhoneQuestion: (question, onChanged) => PhoneQuestionBuilder(
          question: question as PhoneQuestion,
          onChanged: onChanged,
        ),
  };

  factory QuestionBuilder.create(
      QuestionEntity question, ValueChanged<QuestionEntity>? onChanged) {
    final builderFunction = _builderMap[question.runtimeType];
    if (builderFunction != null) {
      return builderFunction(question, onChanged) as QuestionBuilder;
    } else {
      throw UnimplementedError(
          'Unknown question type: ${question.runtimeType}');
    }
  }
}
