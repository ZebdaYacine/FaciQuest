import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';

import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class QuestionPreview extends StatefulWidget {
  const QuestionPreview({
    super.key,
    required this.question,
    this.index,
    this.isPreview = true,
    this.initialAnswer,
    this.onAnswerChanged,
  });
  final int? index;
  final QuestionEntity question;
  final AnswerEntity? initialAnswer;
  final ValueChanged<AnswerEntity>? onAnswerChanged;
  final bool isPreview;

  @override
  State<QuestionPreview> createState() => _QuestionPreviewState();
}

class _QuestionPreviewState extends State<QuestionPreview> {
  late AnswerEntity? _currentAnswer;
  @override
  void initState() {
    super.initState();
    _currentAnswer = widget.initialAnswer;
  }

  void _handleAnswerChanged(AnswerEntity answer) {
    setState(() {
      _currentAnswer = answer;
    });
    widget.onAnswerChanged?.call(answer);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!(widget.question is TextQuestion ||
            widget.question is ImageQuestion)) ...[
          Text(
            '${widget.index}. ${widget.question.title}',
            style: context.headlineSmall,
          ),
          AppSpacing.spacing_1.heightBox,
        ],
        switch (widget.question) {
          StarRatingQuestion() => StarRatingQuestionPreview(
              question: widget.question as StarRatingQuestion,
              onAnswerChanged: _handleAnswerChanged,
              answer: _currentAnswer as StarRatingAnswer?,
            ),
          MultipleChoiceQuestion() => MultipleChoiceQuestionPreview(
              question: widget.question as MultipleChoiceQuestion,
              onAnswerChanged: _handleAnswerChanged,
              answer: _currentAnswer as MultipleChoiceAnswer?,
            ),
          CheckboxesQuestion() => CheckboxesQuestionPreview(
              question: widget.question as CheckboxesQuestion,
            ),
          DropdownQuestion() => DropdownQuestionPreview(
              question: widget.question as DropdownQuestion,
            ),
          FileUploadQuestion() => FileUploadQuestionPreview(
              question: widget.question as FileUploadQuestion,
            ),
          AudioRecordQuestion() => AudioRecordQuestionPreview(
              question: widget.question as AudioRecordQuestion,
            ),
          ShortAnswerQuestion() => ShortTextQuestionPreview(
              question: widget.question as ShortAnswerQuestion,
            ),
          CommentBoxQuestion() => CommentBoxQuestionPreview(
              question: widget.question as CommentBoxQuestion,
            ),
          SliderQuestion() => SliderQuestionPreview(
              question: widget.question as SliderQuestion,
            ),
          DateTimeQuestion() => DateTimeQuestionPreview(
              question: widget.question as DateTimeQuestion,
            ),
          MatrixQuestion() => MatrixQuestionPreview(
              question: widget.question as MatrixQuestion,
            ),
          ImageChoiceQuestion() => ImageChoiceQuestionPreview(
              question: widget.question as ImageChoiceQuestion,
            ),
          NameQuestion() => NameQuestionPreview(
              question: widget.question as NameQuestion,
            ),
          EmailAddressQuestion() => EmailAddressQuestionPreview(
              question: widget.question as EmailAddressQuestion,
            ),
          PhoneQuestion() => PhoneQuestionPreview(
              question: widget.question as PhoneQuestion,
            ),
          AddressQuestion() => AddressQuestionPreview(
              question: widget.question as AddressQuestion,
            ),
          TextQuestion() => TextQuestionPreview(
              question: widget.question as TextQuestion,
            ),
          ImageQuestion() => ImageQuestionPreview(
              question: widget.question as ImageQuestion,
            ),
        }
      ],
    );
  }
}
