import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:faciquest/core/core.dart';
import 'package:faciquest/features/survey/survey.dart';
import 'package:flutter/material.dart';

class AddressQuestionBuilder extends QuestionBuilder {
  const AddressQuestionBuilder({
    required super.question,
    super.onChanged,
    super.key,
  });

  @override
  State<AddressQuestionBuilder> createState() => _AddressQuestionBuilderState();
}

class _AddressQuestionBuilderState extends State<AddressQuestionBuilder>
    with BuildFormMixin {
  onChange({
    String? streetAddress1Label,
    String? streetAddress1Hint,
    bool? showStreetAddress1,

    //
    String? streetAddress2Label,
    String? streetAddress2Hint,
    bool? showStreetAddress2,

    //
    String? cityLabel,
    String? cityHint,
    bool? showCity,

    //
    String? stateLabel,
    String? stateHint,
    bool? showState,

    //
    String? postalCodeLabel,
    String? postalCodeHint,
    bool? showPostalCode,

    //
    String? countryLabel,
    bool? showCountry,
  }) {
    widget.onChanged?.call((widget.question as AddressQuestion).copyWith(
      streetAddress1Label: streetAddress1Label,
      streetAddress1Hint: streetAddress1Hint,
      showStreetAddress1: showStreetAddress1,
      streetAddress2Label: streetAddress2Label,
      streetAddress2Hint: streetAddress2Hint,
      showStreetAddress2: showStreetAddress2,
      cityLabel: cityLabel,
      cityHint: cityHint,
      showCity: showCity,
      stateLabel: stateLabel,
      stateHint: stateHint,
      showState: showState,
      postalCodeLabel: postalCodeLabel,
      postalCodeHint: postalCodeHint,
      showPostalCode: showPostalCode,
      countryLabel: countryLabel,
      showCountry: showCountry,
    ));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldBuilder(
          label: 'Street Address 1',
          show: (widget.question as AddressQuestion).showStreetAddress1,
          labelInitialValue:
              (widget.question as AddressQuestion).streetAddress1Label,
          placeholderInitialValue:
              (widget.question as AddressQuestion).streetAddress1Hint,
          onLabelChanged: (value) {
            onChange(streetAddress1Label: value);
          },
          onPlaceholderChanged: (value) {
            onChange(streetAddress1Hint: value);
          },
          onShowChanged: (value) {
            onChange(showStreetAddress1: value);
          },
        ),
        AppSpacing.spacing_1.heightBox,
        TextFieldBuilder(
          label: 'Street Address 2',
          show: (widget.question as AddressQuestion).showStreetAddress2,
          labelInitialValue:
              (widget.question as AddressQuestion).streetAddress2Label,
          placeholderInitialValue:
              (widget.question as AddressQuestion).streetAddress2Hint,
          onLabelChanged: (value) {
            onChange(streetAddress2Label: value);
          },
          onPlaceholderChanged: (value) {
            onChange(streetAddress2Hint: value);
          },
          onShowChanged: (value) {
            onChange(showStreetAddress2: value);
          },
        ),
        AppSpacing.spacing_1.heightBox,
        TextFieldBuilder(
          label: 'City/Town',
          show: (widget.question as AddressQuestion).showCity,
          labelInitialValue: (widget.question as AddressQuestion).cityLabel,
          placeholderInitialValue:
              (widget.question as AddressQuestion).cityHint,
          onLabelChanged: (value) {
            onChange(cityLabel: value);
          },
          onPlaceholderChanged: (value) {
            onChange(cityHint: value);
          },
          onShowChanged: (value) {
            onChange(showCity: value);
          },
        ),
        AppSpacing.spacing_1.heightBox,
        TextFieldBuilder(
          label: 'State/Province',
          show: (widget.question as AddressQuestion).showState,
          labelInitialValue: (widget.question as AddressQuestion).stateLabel,
          placeholderInitialValue:
              (widget.question as AddressQuestion).stateHint,
          onLabelChanged: (value) {
            onChange(stateLabel: value);
          },
          onPlaceholderChanged: (value) {
            onChange(stateHint: value);
          },
          onShowChanged: (value) {
            onChange(showState: value);
          },
        ),
        AppSpacing.spacing_1.heightBox,
        TextFieldBuilder(
          label: 'ZIP/Postal code',
          show: (widget.question as AddressQuestion).showPostalCode,
          labelInitialValue:
              (widget.question as AddressQuestion).postalCodeLabel,
          placeholderInitialValue:
              (widget.question as AddressQuestion).postalCodeHint,
          onLabelChanged: (value) {
            onChange(postalCodeLabel: value);
          },
          onPlaceholderChanged: (value) {
            onChange(postalCodeHint: value);
          },
          onShowChanged: (value) {
            onChange(showPostalCode: value);
          },
        ),
        AppSpacing.spacing_1.heightBox,
        Row(
          children: [
            Text(
              'Country :',
              style: context.textTheme.bodyLarge,
            ),
            const Spacer(),
            const Text('Show'),
            Checkbox(
              value: (widget.question as AddressQuestion).showCountry,
              onChanged: (value) => onChange(showCountry: value),
            ),
          ],
        ),
        buildInputForm(
          'Label :',
          initialValue: (widget.question as AddressQuestion).countryLabel,
          onChange: (value) => onChange(countryLabel: value),
        ),
        // TODO add default country
      ],
    );
  }
}
