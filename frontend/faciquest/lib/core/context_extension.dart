import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  ColorScheme get colorScheme => theme.colorScheme;
}

/// padding extensions
extension PaddingExt on num {
  /// any number to padding.all
  EdgeInsets get padding => EdgeInsets.all(toDouble());

  /// any number to horizontalPadding
  EdgeInsets get horizontalPadding => EdgeInsets.symmetric(
        horizontal: toDouble(),
      );

  /// any number to verticalPadding
  EdgeInsets get verticalPadding => EdgeInsets.symmetric(
        vertical: toDouble(),
      );

  /// any number to only top Padding
  EdgeInsets get topPadding => EdgeInsets.only(top: toDouble());

  /// any number to only bottom Padding
  EdgeInsets get bottomPadding => EdgeInsets.only(bottom: toDouble());

  /// any number to only left Padding
  EdgeInsets get leftPadding => EdgeInsets.only(left: toDouble());

  /// any number to only right Padding
  EdgeInsets get rightPadding => EdgeInsets.only(right: toDouble());
}
