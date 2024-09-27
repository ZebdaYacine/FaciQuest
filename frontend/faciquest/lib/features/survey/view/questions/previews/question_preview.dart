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
    this.answer,
    this.onAnswerChanged,
  });
  final int? index;
  final QuestionEntity question;
  final AnswerEntity? answer;
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
    _currentAnswer = widget.answer;
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
              onAnswerChanged: _handleAnswerChanged,
              answer: _currentAnswer as CheckboxesAnswer?,
            ),
          DropdownQuestion() => DropdownQuestionPreview(
              question: widget.question as DropdownQuestion,
              onAnswerChanged: _handleAnswerChanged,
              answer: _currentAnswer as DropdownAnswer?,
            ),
          FileUploadQuestion() => FileUploadQuestionPreview(
              question: widget.question as FileUploadQuestion,
              onAnswerChanged: _handleAnswerChanged,
              answer: _currentAnswer as FileUploadAnswer?,
            ),
          AudioRecordQuestion() => AudioRecordQuestionPreview(
              question: widget.question as AudioRecordQuestion,
              onAnswerChanged: _handleAnswerChanged,
              answer: _currentAnswer as AudioRecordAnswer?,
            ),
          ShortAnswerQuestion() => ShortTextQuestionPreview(
              question: widget.question as ShortAnswerQuestion,
              onAnswerChanged: _handleAnswerChanged,
              answer: _currentAnswer as ShortAnswerAnswer?,
            ),
          CommentBoxQuestion() => CommentBoxQuestionPreview(
              question: widget.question as CommentBoxQuestion,
              onAnswerChanged: _handleAnswerChanged,
              answer: _currentAnswer as CommentBoxAnswer?,
            ),
          SliderQuestion() => SliderQuestionPreview(
              question: widget.question as SliderQuestion,
              onAnswerChanged: _handleAnswerChanged,
              answer: _currentAnswer as SliderAnswer?,
            ),
          DateTimeQuestion() => DateTimeQuestionPreview(
              question: widget.question as DateTimeQuestion,
              onAnswerChanged: _handleAnswerChanged,
              answer: _currentAnswer as DateTimeAnswer?,
            ),
          MatrixQuestion() => MatrixQuestionPreview(
              question: widget.question as MatrixQuestion,
              onAnswerChanged: _handleAnswerChanged,
              answer: _currentAnswer as MatrixAnswer?,
            ),
          ImageChoiceQuestion() => ImageChoiceQuestionPreview(
              question: widget.question as ImageChoiceQuestion,
              onAnswerChanged: _handleAnswerChanged,
              answer: _currentAnswer as ImageChoiceAnswer?,
            ),
          NameQuestion() => NameQuestionPreview(
              question: widget.question as NameQuestion,
              onAnswerChanged: _handleAnswerChanged,
              answer: _currentAnswer as NameAnswer?,
            ),
          EmailAddressQuestion() => EmailAddressQuestionPreview(
              question: widget.question as EmailAddressQuestion,
              onAnswerChanged: _handleAnswerChanged,
              answer: _currentAnswer as EmailAddressAnswer?,
            ),
          PhoneQuestion() => PhoneQuestionPreview(
              question: widget.question as PhoneQuestion,
              onAnswerChanged: _handleAnswerChanged,
              answer: _currentAnswer as PhoneAnswer?,
            ),
          AddressQuestion() => AddressQuestionPreview(
              question: widget.question as AddressQuestion,
              onAnswerChanged: _handleAnswerChanged,
              answer: _currentAnswer as AddressAnswer?,
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
