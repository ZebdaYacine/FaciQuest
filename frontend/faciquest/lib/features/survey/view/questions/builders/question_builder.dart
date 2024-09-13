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

  static final _builderMap = <Type,
      Function(QuestionEntity, ValueChanged<QuestionEntity>?,
          {LikertScale? likertScale})>{
    StarRatingQuestion: (question, onChanged, {LikertScale? likertScale}) =>
        StarRatingQuestionBuilder(
          question: question as StarRatingQuestion,
          onChanged: onChanged,
        ),
    MultipleChoiceQuestion: (question, onChanged, {LikertScale? likertScale}) =>
        MultipleChoiceQuestionBuilder(
          question: question as MultipleChoiceQuestion,
          onChanged: onChanged,
          likertScale: likertScale,
        ),
    CheckboxesQuestion: (question, onChanged, {LikertScale? likertScale}) =>
        CheckboxesQuestionBuilder(
          question: question as CheckboxesQuestion,
          likertScale: likertScale,
          onChanged: onChanged,
        ),
    DropdownQuestion: (question, onChanged, {LikertScale? likertScale}) =>
        DropdownQuestionBuilder(
          question: question as DropdownQuestion,
          likertScale: likertScale,
          onChanged: onChanged,
        ),
    FileUploadQuestion: (question, onChanged, {LikertScale? likertScale}) =>
        FileUploadQuestionBuilder(
          question: question as FileUploadQuestion,
          onChanged: onChanged,
        ),
    AudioRecordQuestion: (question, onChanged, {LikertScale? likertScale}) =>
        AudioRecordQuestionBuilder(
          question: question as AudioRecordQuestion,
          onChanged: onChanged,
        ),
    ShortAnswerQuestion: (question, onChanged, {LikertScale? likertScale}) =>
        ShortAnswerQuestionBuilder(
          question: question as ShortAnswerQuestion,
          onChanged: onChanged,
        ),
    CommentBoxQuestion: (question, onChanged, {LikertScale? likertScale}) =>
        CommentBoxQuestionBuilder(
          question: question as CommentBoxQuestion,
          onChanged: onChanged,
        ),
    SliderQuestion: (question, onChanged, {LikertScale? likertScale}) =>
        SliderQuestionBuilder(
          question: question as SliderQuestion,
          onChanged: onChanged,
        ),
    DateTimeQuestion: (question, onChanged, {LikertScale? likertScale}) =>
        DateTimeQuestionBuilder(
          question: question as DateTimeQuestion,
          onChanged: onChanged,
        ),
    MatrixQuestion: (question, onChanged, {LikertScale? likertScale}) =>
        MatrixQuestionBuilder(
          question: question as MatrixQuestion,
          onChanged: onChanged,
        ),
    ImageChoiceQuestion: (question, onChanged, {LikertScale? likertScale}) =>
        ImageChoiceQuestionBuilder(
          question: question as ImageChoiceQuestion,
          onChanged: onChanged,
        ),
    NameQuestion: (question, onChanged, {LikertScale? likertScale}) =>
        NameQuestionBuilder(
          question: question as NameQuestion,
          onChanged: onChanged,
        ),
    EmailAddressQuestion: (question, onChanged, {LikertScale? likertScale}) =>
        EmailAddressQuestionBuilder(
          question: question as EmailAddressQuestion,
          onChanged: onChanged,
        ),
    PhoneQuestion: (question, onChanged, {LikertScale? likertScale}) =>
        PhoneQuestionBuilder(
          question: question as PhoneQuestion,
          onChanged: onChanged,
        ),
    AddressQuestion: (question, onChanged, {LikertScale? likertScale}) =>
        AddressQuestionBuilder(
          question: question as AddressQuestion,
          onChanged: onChanged,
        ),
    TextQuestion: (question, onChanged, {LikertScale? likertScale}) =>
        TextQuestionBuilder(
          question: question as TextQuestion,
          onChanged: onChanged,
        ),
    ImageQuestion: (question, onChanged, {LikertScale? likertScale}) =>
        ImageQuestionBuilder(
          question: question as ImageQuestion,
          onChanged: onChanged,
        ),
  };

  factory QuestionBuilder.create(
    QuestionEntity question,
    ValueChanged<QuestionEntity>? onChanged,
    LikertScale? likertScale,
  ) {
    final builderFunction = _builderMap[question.runtimeType];
    if (builderFunction != null) {
      return builderFunction(
        question,
        onChanged,
        likertScale: likertScale,
      ) as QuestionBuilder;
    } else {
      throw UnimplementedError(
          'Unknown question type: ${question.runtimeType}');
    }
  }
}
