import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class NameQuestionPreview extends StatelessWidget {
  const NameQuestionPreview({
    required this.question,
    required this.answer,
    required this.onAnswerChanged,
    super.key,
  });
  final NameQuestion question;
  final NameAnswer? answer;
  final ValueChanged<NameAnswer>? onAnswerChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (question.showFirstName) ...[
          TextFormField(
            initialValue: answer?.firstName,
            decoration: InputDecoration(
              labelText: question.firstNameLabel,
              hintText: question.firstNameHint,
            ),
            onChanged: (value) {
              onAnswerChanged?.call(
                (answer ??
                        NameAnswer(
                          questionId: question.id,
                        ))
                    .copyWith(firstName: value),
              );
            },
          ),
        ],
        if (question.showLastName) ...[
          AppSpacing.spacing_1.heightBox,
          TextFormField(
            initialValue: answer?.lastName,
            decoration: InputDecoration(
              labelText: question.lastNameLabel,
              hintText: question.lastNameHint,
            ),
            onChanged: (value) {
              onAnswerChanged?.call(
                (answer ??
                        NameAnswer(
                          questionId: question.id,
                        ))
                    .copyWith(lastName: value),
              );
            },
          ),
        ],
        if (question.showMiddleName) ...[
          AppSpacing.spacing_1.heightBox,
          TextFormField(
            initialValue: answer?.middleName,
            decoration: InputDecoration(
              labelText: question.middleNameLabel,
              hintText: question.middleNameHint,
            ),
            onChanged: (value) {
              onAnswerChanged?.call(
                (answer ??
                        NameAnswer(
                          questionId: question.id,
                        ))
                    .copyWith(middleName: value),
              );
            },
          ),
        ]
      ],
    );
  }
}
