import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core.dart';

class EnhancedTextField extends StatefulWidget {
  const EnhancedTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.focusNode,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.fillColor,
    this.borderRadius,
    this.contentPadding,
    this.errorText,
    this.helperText,
    this.isLoading = false,
  });

  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final Color? fillColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final String? errorText;
  final String? helperText;
  final bool isLoading;

  @override
  State<EnhancedTextField> createState() => _EnhancedTextFieldState();
}

class _EnhancedTextFieldState extends State<EnhancedTextField> with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _hasText = false;
  late AnimationController _animationController;
  late Animation<double> _labelAnimation;
  late Animation<Color?> _borderColorAnimation;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);

    if (widget.controller != null) {
      widget.controller!.addListener(_onTextChange);
      _hasText = widget.controller!.text.isNotEmpty;
    }

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _labelAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _borderColorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.blue,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller != null) {
      widget.controller!.removeListener(_onTextChange);
    }
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });

    if (_isFocused || _hasText) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onTextChange() {
    final hasText = widget.controller!.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });

      if (_hasText || _isFocused) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.colorScheme;
    final textTheme = context.textTheme;

    final borderRadius = widget.borderRadius ?? BorderRadius.circular(16);
    final contentPadding = widget.contentPadding ??
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        );

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: theme.primary.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: theme.shadow.withOpacity(0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
              ),
              child: TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
                onChanged: widget.onChanged,
                onFieldSubmitted: widget.onSubmitted,
                validator: widget.validator,
                enabled: widget.enabled && !widget.isLoading,
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                maxLength: widget.maxLength,
                inputFormatters: widget.inputFormatters,
                autofocus: widget.autofocus,
                textCapitalization: widget.textCapitalization,
                style: widget.style ??
                    textTheme.bodyLarge?.copyWith(
                      color: widget.enabled ? theme.onSurface : theme.onSurface.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                    ),
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  hintText: widget.hintText,
                  prefixIcon: widget.prefixIcon != null
                      ? Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: widget.prefixIcon,
                        )
                      : null,
                  suffixIcon: widget.isLoading
                      ? Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.primary,
                          ),
                        )
                      : widget.suffixIcon,
                  filled: true,
                  fillColor: widget.fillColor ?? (_isFocused ? theme.surface : theme.surfaceContainerLowest),
                  contentPadding: contentPadding,
                  labelStyle: textTheme.bodyMedium?.copyWith(
                    color: _isFocused ? theme.primary : theme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  hintStyle: textTheme.bodyMedium?.copyWith(
                    color: theme.onSurfaceVariant.withOpacity(0.6),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: borderRadius,
                    borderSide: BorderSide(
                      color: theme.outline.withOpacity(0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: borderRadius,
                    borderSide: BorderSide(
                      color: theme.outline.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: borderRadius,
                    borderSide: BorderSide(
                      color: theme.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: borderRadius,
                    borderSide: BorderSide(
                      color: theme.error,
                      width: 1.5,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: borderRadius,
                    borderSide: BorderSide(
                      color: theme.error,
                      width: 2,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: borderRadius,
                    borderSide: BorderSide(
                      color: theme.outline.withOpacity(0.1),
                    ),
                  ),
                  errorText: widget.errorText,
                  counterText: '',
                ),
              ),
            ),
            if (widget.helperText != null) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.helperText!,
                  style: textTheme.bodySmall?.copyWith(
                    color: theme.onSurfaceVariant.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

// Specialized text fields for common use cases
class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    this.controller,
    this.labelText = 'Password',
    this.hintText = 'Enter your password',
    this.onChanged,
    this.validator,
    this.showStrengthIndicator = false,
  });

  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final bool showStrengthIndicator;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;
  double _strength = 0.0;

  void _calculateStrength(String password) {
    if (!widget.showStrengthIndicator) return;

    double strength = 0;
    if (password.length >= 8) strength += 0.2;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.2;
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.2;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.2;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.2;

    setState(() {
      _strength = strength;
    });
  }

  Color _getStrengthColor(BuildContext context) {
    if (_strength <= 0.2) return context.colorScheme.error;
    if (_strength <= 0.4) return Colors.orange;
    if (_strength <= 0.6) return Colors.yellow.shade700;
    if (_strength <= 0.8) return Colors.lightGreen;
    return Colors.green;
  }

  String _getStrengthText() {
    if (_strength <= 0.2) return 'Very Weak';
    if (_strength <= 0.4) return 'Weak';
    if (_strength <= 0.6) return 'Fair';
    if (_strength <= 0.8) return 'Good';
    return 'Strong';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EnhancedTextField(
          controller: widget.controller,
          labelText: widget.labelText,
          hintText: widget.hintText,
          obscureText: _obscureText,
          prefixIcon: Icon(
            Icons.lock_outline_rounded,
            color: context.colorScheme.primary,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: context.colorScheme.onSurfaceVariant,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          onChanged: (value) {
            _calculateStrength(value);
            widget.onChanged?.call(value);
          },
          validator: widget.validator,
        ),
        if (widget.showStrengthIndicator && _strength > 0) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: _strength,
                        backgroundColor: context.colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getStrengthColor(context),
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getStrengthText(),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: _getStrengthColor(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return EnhancedTextField(
      controller: controller,
      hintText: hintText,
      prefixIcon: Icon(
        Icons.search_rounded,
        color: context.colorScheme.onSurfaceVariant,
      ),
      suffixIcon: controller?.text.isNotEmpty == true
          ? IconButton(
              icon: Icon(
                Icons.clear_rounded,
                color: context.colorScheme.onSurfaceVariant,
              ),
              onPressed: () {
                controller?.clear();
                onChanged?.call('');
              },
            )
          : null,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      borderRadius: BorderRadius.circular(24),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
    );
  }
}
