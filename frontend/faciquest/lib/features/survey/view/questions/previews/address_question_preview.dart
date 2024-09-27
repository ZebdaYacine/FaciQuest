import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/features.dart';
import 'package:flutter/material.dart';

class AddressQuestionPreview extends StatelessWidget {
  const AddressQuestionPreview({
    required this.question,
    required this.onAnswerChanged,
    required this.answer,
    super.key,
  });
  final AddressQuestion question;
  final AddressAnswer? answer;
  final ValueChanged<AddressAnswer>? onAnswerChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (question.showStreetAddress1) ...[
          Text(question.streetAddress1Label),
          TextFormField(
            initialValue: answer?.streetAddress1,
            decoration: InputDecoration(
              hintText: question.streetAddress1Hint,
            ),
            onChanged: (value) {
              onAnswerChanged?.call(
                (answer ??
                        AddressAnswer(
                          questionId: question.id,
                        ))
                    .copyWith(streetAddress1: value),
              );
            },
          ),
        ],
        if (question.showStreetAddress2) ...[
          AppSpacing.spacing_1.heightBox,
          Text(question.streetAddress2Label),
          TextFormField(
            initialValue: answer?.streetAddress2,
            decoration: InputDecoration(
              hintText: question.streetAddress2Hint,
            ),
            onChanged: (value) {
              onAnswerChanged?.call(
                (answer ??
                        AddressAnswer(
                          questionId: question.id,
                        ))
                    .copyWith(streetAddress2: value),
              );
            },
          )
        ],
        Wrap(
          children: [
            if (question.showCity) ...[
              Text(question.cityLabel),
              TextFormField(
                initialValue: answer?.city,
                decoration: InputDecoration(
                  hintText: question.cityHint,
                ),
                onChanged: (value) {
                  onAnswerChanged?.call(
                    (answer ??
                            AddressAnswer(
                              questionId: question.id,
                            ))
                        .copyWith(city: value),
                  );
                },
              ),
            ],
            if (question.showState) ...[
              Text(question.stateLabel),
              TextFormField(
                initialValue: answer?.state,
                decoration: InputDecoration(
                  hintText: question.stateHint,
                ),
                onChanged: (value) {
                  onAnswerChanged?.call(
                    (answer ??
                            AddressAnswer(
                              questionId: question.id,
                            ))
                        .copyWith(state: value),
                  );
                },
              ),
            ],
            if (question.showPostalCode) ...[
              Text(question.postalCodeLabel),
              TextFormField(
                initialValue: answer?.postalCode,
                decoration: InputDecoration(
                  hintText: question.postalCodeHint,
                ),
                onChanged: (value) {
                  onAnswerChanged?.call(
                    (answer ??
                            AddressAnswer(
                              questionId: question.id,
                            ))
                        .copyWith(postalCode: value),
                  );
                },
              ),
            ],
            if (question.showCountry) ...[
              Text(question.countryLabel),
              TextFormField(
                initialValue: answer?.country,
                decoration: InputDecoration(
                  hintText: question.countryHint,
                ),
                onChanged: (value) {
                  onAnswerChanged?.call(
                    (answer ??
                            AddressAnswer(
                              questionId: question.id,
                            ))
                        .copyWith(country: value),
                  );
                },
              ),
            ]
          ],
        )
      ],
    );
  }
}
