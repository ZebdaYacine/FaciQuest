import 'package:faciquest/core/core.dart';
import 'package:flutter/material.dart';

mixin BuildFormMixin<T extends StatefulWidget> on State<T> {
  bool _isObscure = true;

  Widget buildInputForm(
    String label, {
    bool pass = false,
    Key? key,
    String? initialValue,
    ValueChanged<String>? onChange,
    bool? enabled,
    TextInputType? keyboardType,
    int? maxLines,
    InputDecoration? decoration,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    ValueChanged<String>? onFieldSubmitted,
    FormFieldValidator<String>? validator,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
  }) {
    final action = textInputAction ??
        ((maxLines ?? 1) > 1 ? TextInputAction.newline : TextInputAction.next);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        key: key,
        initialValue: initialValue,
        enabled: enabled,
        focusNode: focusNode,
        keyboardType: keyboardType,
        textInputAction: action,
        maxLines: _isObscure ? 1 : maxLines,
        obscureText: pass ? _isObscure : false,
        onChanged: onChange,
        validator: validator,
        autovalidateMode: autovalidateMode,
        onFieldSubmitted: onFieldSubmitted,
        decoration: decoration ??
            InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(
                  color: kTextFieldColor,
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryColor),
                ),
                suffixIcon: pass
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: _isObscure
                            ? const Icon(
                                Icons.visibility_off,
                                color: kTextFieldColor,
                              )
                            : const Icon(
                                Icons.visibility,
                                color: kPrimaryColor,
                              ),
                      )
                    : null),
      ),
    );
  }
}
