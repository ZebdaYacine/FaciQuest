import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GenericInputField extends StatefulWidget {
  const GenericInputField({
    super.key,
    this.maxLines,
    this.minLines,
    this.decoration,
    this.hintText,
    this.enabled,
    this.fillColor,
    this.filled,
    this.isDense,
    this.counter,
    this.suffix,
    this.prefix,
    this.suffixWidget,
    this.prefixWidget,
    this.helperText,
    this.controller,
    this.label,
    this.readOnly = false,
    this.autofocus = false,
    this.onTap,
    this.onChanged,
    this.keyboardType,
    this.focusNode,
    this.inputFormatters,
    this.textInputAction,
    this.maxLength,
    this.validator,
    this.initialValue,
    this.onFieldSubmitted,
    this.showCounter = false,
    this.errorMaxLines,
    this.errorMessage,
    this.textDirection,
  });
  final TextEditingController? controller;
  final int? maxLines;
  final int? minLines;

  /// The maximum number of lines the [errorMessage] can occupy.
  ///
  /// Defaults to null, which means that the [errorMessage] will be limited
  /// to a single line with [TextOverflow.ellipsis].
  final int? errorMaxLines;

  /// custom message to show if the input  does not match the pattern.
  final String? errorMessage;
  final InputDecoration? decoration;
  final String? hintText;
  final bool? enabled;
  final Color? fillColor;
  final bool? filled;
  final bool? isDense;
  final Widget? counter;
  final Widget? suffix;
  final Widget? prefix;
  final Widget? suffixWidget;
  final Widget? prefixWidget;
  final String? helperText;
  final String? label;
  final bool readOnly;
  final bool autofocus;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final String? Function(String?)? validator;
  final String? initialValue;
  final void Function(String)? onFieldSubmitted;
  final bool showCounter;
  final TextDirection? textDirection;

  @override
  State<GenericInputField> createState() => _GenericInputFieldState();
}

class _GenericInputFieldState extends State<GenericInputField> {
  String? _error;

  void validateField(String value) {
    if (widget.validator == null) {
      return;
    }
    setState(() {
      _error = null;
    });
    final error = widget.validator?.call(value);
    setState(() {
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null)
          Text(
            widget.label!,
            style: context.textTheme.titleMedium,
          ),
        if (widget.label != null) 8.heightBox,
        Directionality(
          textDirection: widget.textDirection ?? TextDirection.ltr,
          child: Flexible(
            child: TextFormField(
              initialValue: widget.initialValue,
              controller: widget.controller,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              validator: widget.validator,
              enabled: widget.enabled,
              readOnly: widget.readOnly,
              autofocus: widget.autofocus,
              onTap: widget.onTap,
              onChanged: (value) {
                validateField(value);
                widget.onChanged?.call(value);
              },
              // validator: widget.validator,
              onFieldSubmitted: widget.onFieldSubmitted,
              // validator: ,
              keyboardType: widget.keyboardType,
              focusNode: widget.focusNode,
              inputFormatters: widget.inputFormatters,
              maxLength: widget.maxLength,
              textInputAction: widget.textInputAction,
              buildCounter: (
                context, {
                required currentLength,
                required isFocused,
                required maxLength,
              }) =>
                  maxLength != null && widget.showCounter
                      ? Row(
                          children: [
                            Text('$currentLength / $maxLength'),
                            const Spacer(),
                          ],
                        )
                      : null,
              decoration: widget.decoration ??
                  InputDecoration(
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    hintText: widget.hintText,
                  ),
            ),
          ),
        ),
        // if (_error != null)
        //   Padding(
        //     padding: const EdgeInsets.only(top: 8),
        //     child: SDSText.bodySmallRegular(
        //       text: _error!,
        //       color: SDSPallet.labelsColoredLabelsNegative
        //           .getColor(context.isDarkTheme),
        //     ),
        //   ),
      ],
    );
  }
}
