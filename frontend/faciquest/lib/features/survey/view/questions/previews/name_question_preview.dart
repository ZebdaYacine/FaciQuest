import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/context_extension.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class NameQuestionPreview extends StatelessWidget {
  const NameQuestionPreview({
    required this.question,
    super.key,
  });
  final NameQuestion question;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (question.showFirstName) ...[
          TextField(
            decoration: InputDecoration(
              labelText: question.firstNameLabel,
              hintText: question.firstNameHint,
            ),
          ),
        ],
        if (question.showLastName) ...[
          AppSpacing.spacing_1.heightBox,
          TextField(
            decoration: InputDecoration(
              labelText: question.lastNameLabel,
              hintText: question.lastNameHint,
            ),
          ),
        ],
        if (question.showMiddleName) ...[
          AppSpacing.spacing_1.heightBox,
          TextField(
            decoration: InputDecoration(
              labelText: question.middleNameLabel,
              hintText: question.middleNameHint,
            ),
          ),
        ]
      ],
    );
  }
}
