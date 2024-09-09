import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class AddressQuestionPreview extends StatelessWidget {
  const AddressQuestionPreview({
    required this.question,
    super.key,
  });
  final AddressQuestion question;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (question.showStreetAddress1) ...[
          Text(question.streetAddress1Label),
          TextField(
            decoration: InputDecoration(
              hintText: question.streetAddress1Hint,
            ),
          )
        ],
        if (question.showStreetAddress2) ...[
          AppSpacing.spacing_1.heightBox,
          Text(question.streetAddress2Label),
          TextField(
            decoration: InputDecoration(
              hintText: question.streetAddress2Hint,
            ),
          )
        ],
        Wrap(
          children: [
            if (question.showCity) ...[
              Text(question.cityLabel),
              TextField(
                decoration: InputDecoration(
                  hintText: question.cityHint,
                ),
              ),
            ],
            if (question.showState) ...[
              Text(question.stateLabel),
              TextField(
                decoration: InputDecoration(
                  hintText: question.stateHint,
                ),
              ),
            ],
            if (question.showPostalCode) ...[
              Text(question.postalCodeLabel),
              TextField(
                decoration: InputDecoration(
                  hintText: question.postalCodeHint,
                ),
              ),
            ],
            if (question.showCountry) ...[
              Text(question.countryLabel),
              TextField(
                decoration: InputDecoration(
                  hintText: question.countryHint,
                ),
              ),
            ]
          ],
        )
      ],
    );
  }
}
