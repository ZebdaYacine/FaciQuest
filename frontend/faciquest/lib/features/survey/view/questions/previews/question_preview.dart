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
    switch (question) {
      case StarRatingQuestion():
        return StarRatingQuestionPreview(
            question: question as StarRatingQuestion);

      case MultipleChoiceQuestion():
        return MultipleChoiceQuestionPreview(
            question: question as MultipleChoiceQuestion);

      case CheckboxesQuestion():
        return CheckboxesQuestionPreview(
            question: question as CheckboxesQuestion);

      case DropdownQuestion():
        return DropdownQuestionPreview(question: question as DropdownQuestion);

      case FileUploadQuestion():
        return FileUploadQuestionPreview(
            question: question as FileUploadQuestion);

      case AudioRecordQuestion():
        return AudioRecordQuestionPreview(
            question: question as AudioRecordQuestion);

      case ShortAnswerQuestion():
        return ShortTextQuestionPreview(
            question: question as ShortAnswerQuestion);

      case CommentBoxQuestion():
        return CommentBoxQuestionPreview(
            question: question as CommentBoxQuestion);

      case SliderQuestion():
        return SliderQuestionPreview(question: question as SliderQuestion);

      case DateTimeQuestion():
        return DateTimeQuestionPreview(question: question as DateTimeQuestion);

      case MatrixQuestion():
        return MatrixQuestionPreview(question: question as MatrixQuestion);

      case ImageChoiceQuestion():
        return ImageChoiceQuestionPreview(
            question: question as ImageChoiceQuestion);

      case NameQuestion():
        return NameQuestionPreview(question: question as NameQuestion);

      case EmailAddressQuestion():
        return EmailAddressQuestionPreview(
            question: question as EmailAddressQuestion);

      case PhoneQuestion():
        return PhoneQuestionPreview(question: question as PhoneQuestion);

      case AddressQuestion():
        return AddressQuestionPreview(question: question as AddressQuestion);

      case TextQuestion():
        return TextQuestionPreview(question: question as TextQuestion);

      case ImageQuestion():
        return ImageQuestionPreview(question: question as ImageQuestion);
    }
  }
}
