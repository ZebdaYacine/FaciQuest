import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';

import '../core.dart';

class TextFieldBuilder extends StatefulWidget {
  const TextFieldBuilder({
    super.key,
    required this.label,
    this.labelInitialValue,
    this.placeholderInitialValue,
    this.show,
    this.onShowChanged,
    this.onLabelChanged,
    this.onPlaceholderChanged,
  });
  final String label;
  final String? labelInitialValue;

  final String? placeholderInitialValue;
  final bool? show;
  final ValueChanged<bool?>? onShowChanged;
  final ValueChanged<String?>? onLabelChanged;
  final ValueChanged<String?>? onPlaceholderChanged;

  @override
  State<TextFieldBuilder> createState() => _TextFieldBuilderState();
}

class _TextFieldBuilderState extends State<TextFieldBuilder>
    with BuildFormMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: context.textTheme.bodyLarge,
            ),
            Spacer(),
            Text('Show'),
            Checkbox(
              value: widget.show,
              onChanged: widget.onShowChanged,
            ),
          ],
        ),
        buildInputForm(
          'Label :',
          key: UniqueKey(),
          initialValue: widget.labelInitialValue,
          onChange: widget.onLabelChanged,
        ),
        buildInputForm(
          'Placeholder :',
          key: UniqueKey(),
          initialValue: widget.placeholderInitialValue,
          onChange: widget.onPlaceholderChanged,
        ),
      ],
    );
  }
}
