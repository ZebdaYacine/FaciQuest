import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core.dart';

enum ButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  destructive,
}

enum ButtonSize {
  small,
  medium,
  large,
}

class EnhancedButton extends StatefulWidget {
  const EnhancedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.suffixIcon,
    this.fullWidth = false,
    this.borderRadius,
    this.elevation = 0,
    this.customColor,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  final VoidCallback? onPressed;
  final Widget child;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final Widget? icon;
  final Widget? suffixIcon;
  final bool fullWidth;
  final BorderRadius? borderRadius;
  final double elevation;
  final Color? customColor;
  final Duration animationDuration;

  @override
  State<EnhancedButton> createState() => _EnhancedButtonState();
}

class _EnhancedButtonState extends State<EnhancedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: widget.elevation,
      end: widget.elevation * 0.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      _controller.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _onTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.colorScheme;
    final textTheme = context.textTheme;

    final isEnabled = widget.onPressed != null && !widget.isLoading;

    // Get button configuration based on variant
    final buttonConfig = _getButtonConfig(theme);

    // Get size configuration
    final sizeConfig = _getSizeConfig();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.fullWidth ? double.infinity : null,
            height: sizeConfig.height,
            decoration: BoxDecoration(
              gradient: buttonConfig.gradient,
              color: buttonConfig.backgroundColor,
              borderRadius: widget.borderRadius ?? sizeConfig.borderRadius,
              border: buttonConfig.border,
              boxShadow: isEnabled
                  ? [
                      BoxShadow(
                        color: (buttonConfig.shadowColor ?? theme.shadow).withOpacity(0.1),
                        blurRadius: _elevationAnimation.value * 2,
                        offset: Offset(0, _elevationAnimation.value),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: widget.borderRadius ?? sizeConfig.borderRadius,
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                onTap: isEnabled ? widget.onPressed : null,
                child: Padding(
                  padding: sizeConfig.padding,
                  child: Row(
                    mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null && !widget.isLoading) ...[
                        IconTheme(
                          data: IconThemeData(
                            color: buttonConfig.foregroundColor,
                            size: sizeConfig.iconSize,
                          ),
                          child: widget.icon!,
                        ),
                        SizedBox(width: sizeConfig.spacing),
                      ],
                      if (widget.isLoading) ...[
                        SizedBox(
                          width: sizeConfig.iconSize,
                          height: sizeConfig.iconSize,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: buttonConfig.foregroundColor,
                          ),
                        ),
                        SizedBox(width: sizeConfig.spacing),
                      ],
                      Flexible(
                        child: DefaultTextStyle(
                          style: sizeConfig.textStyle.copyWith(
                            color: isEnabled
                                ? buttonConfig.foregroundColor
                                : buttonConfig.foregroundColor?.withOpacity(0.6),
                          ),
                          child: widget.child,
                        ),
                      ),
                      if (widget.suffixIcon != null) ...[
                        SizedBox(width: sizeConfig.spacing),
                        IconTheme(
                          data: IconThemeData(
                            color: buttonConfig.foregroundColor,
                            size: sizeConfig.iconSize,
                          ),
                          child: widget.suffixIcon!,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _ButtonConfig _getButtonConfig(ColorScheme theme) {
    final baseColor = widget.customColor ?? theme.primary;

    switch (widget.variant) {
      case ButtonVariant.primary:
        return _ButtonConfig(
          backgroundColor: baseColor,
          foregroundColor: theme.onPrimary,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              baseColor,
              baseColor.withOpacity(0.8),
            ],
          ),
          shadowColor: baseColor,
        );

      case ButtonVariant.secondary:
        return _ButtonConfig(
          backgroundColor: theme.secondaryContainer,
          foregroundColor: theme.onSecondaryContainer,
        );

      case ButtonVariant.outline:
        return _ButtonConfig(
          backgroundColor: Colors.transparent,
          foregroundColor: baseColor,
          border: Border.all(
            color: theme.outline.withOpacity(0.3),
            width: 1.5,
          ),
        );

      case ButtonVariant.ghost:
        return _ButtonConfig(
          backgroundColor: Colors.transparent,
          foregroundColor: baseColor,
        );

      case ButtonVariant.destructive:
        return _ButtonConfig(
          backgroundColor: theme.error,
          foregroundColor: theme.onError,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.error,
              theme.error.withOpacity(0.8),
            ],
          ),
          shadowColor: theme.error,
        );
    }
  }

  _SizeConfig _getSizeConfig() {
    switch (widget.size) {
      case ButtonSize.small:
        return _SizeConfig(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ) ??
              const TextStyle(),
          iconSize: 16,
          spacing: 6,
          borderRadius: BorderRadius.circular(12),
        );

      case ButtonSize.medium:
        return _SizeConfig(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ) ??
              const TextStyle(),
          iconSize: 20,
          spacing: 8,
          borderRadius: BorderRadius.circular(16),
        );

      case ButtonSize.large:
        return _SizeConfig(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ) ??
              const TextStyle(),
          iconSize: 24,
          spacing: 10,
          borderRadius: BorderRadius.circular(20),
        );
    }
  }
}

class _ButtonConfig {
  const _ButtonConfig({
    this.backgroundColor,
    this.foregroundColor,
    this.gradient,
    this.border,
    this.shadowColor,
  });

  final Color? backgroundColor;
  final Color? foregroundColor;
  final Gradient? gradient;
  final Border? border;
  final Color? shadowColor;
}

class _SizeConfig {
  const _SizeConfig({
    required this.height,
    required this.padding,
    required this.textStyle,
    required this.iconSize,
    required this.spacing,
    required this.borderRadius,
  });

  final double height;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;
  final double iconSize;
  final double spacing;
  final BorderRadius borderRadius;
}

// Convenient pre-configured button widgets
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
    this.size = ButtonSize.large,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final Widget? icon;
  final bool fullWidth;
  final ButtonSize size;

  @override
  Widget build(BuildContext context) {
    return EnhancedButton(
      onPressed: onPressed,
      variant: ButtonVariant.primary,
      size: size,
      isLoading: isLoading,
      icon: icon,
      fullWidth: fullWidth,
      elevation: 4,
      child: child,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
    this.size = ButtonSize.large,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final Widget? icon;
  final bool fullWidth;
  final ButtonSize size;

  @override
  Widget build(BuildContext context) {
    return EnhancedButton(
      onPressed: onPressed,
      variant: ButtonVariant.outline,
      size: size,
      isLoading: isLoading,
      icon: icon,
      fullWidth: fullWidth,
      child: child,
    );
  }
}
