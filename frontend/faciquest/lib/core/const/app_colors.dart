import 'dart:ui';
import 'package:flutter/material.dart';

// Primary Colors - Modern teal/green palette
const kPrimaryColor = Color(0xFF2DD4BF); // Teal-400
const kPrimaryDarkColor = Color(0xFF0F766E); // Teal-700
const kPrimaryLightColor = Color(0xFF5EEAD4); // Teal-200
const kPrimaryContainerColor = Color(0xFFCCFDF9); // Teal-100

// Secondary Colors - Complementary purple palette
const kSecondaryColor = Color(0xFF8B5CF6); // Violet-500
const kSecondaryDarkColor = Color(0xFF6D28D9); // Violet-700
const kSecondaryLightColor = Color(0xFFC4B5FD); // Violet-300
const kSecondaryContainerColor = Color(0xFFF3F4F6); // Gray-100

// Neutral Colors - Modern gray scale
const kSurfaceColor = Color(0xFFFFFFFF); // White
const kSurfaceVariantColor = Color(0xFFF8FAFC); // Slate-50
const kSurfaceContainerLowestColor = Color(0xFFF1F5F9); // Slate-100
const kSurfaceContainerLowColor = Color(0xFFE2E8F0); // Slate-200
const kSurfaceContainerColor = Color(0xFFCBD5E1); // Slate-300
const kSurfaceContainerHighColor = Color(0xFF94A3B8); // Slate-400
const kSurfaceContainerHighestColor = Color(0xFF64748B); // Slate-500

// Text Colors - Improved contrast
const kOnSurfaceColor = Color(0xFF0F172A); // Slate-900
const kOnSurfaceVariantColor = Color(0xFF475569); // Slate-600
const kOnPrimaryColor = Color(0xFFFFFFFF); // White
const kOnSecondaryColor = Color(0xFFFFFFFF); // White

// Status Colors - Accessible and modern
const kErrorColor = Color(0xFFEF4444); // Red-500
const kErrorContainerColor = Color(0xFFFEF2F2); // Red-50
const kOnErrorColor = Color(0xFFFFFFFF); // White
const kOnErrorContainerColor = Color(0xFF991B1B); // Red-800

const kWarningColor = Color(0xFFF59E0B); // Amber-500
const kWarningContainerColor = Color(0xFFFFF7ED); // Orange-50
const kSuccessColor = Color(0xFF10B981); // Emerald-500
const kSuccessContainerColor = Color(0xFFF0FDF4); // Green-50

// Legacy colors (deprecated but kept for backwards compatibility)
@Deprecated('Use kOnSurfaceVariantColor instead')
const kDarkGreyColor = Color(0xFF6B7280); // Gray-500
@Deprecated('Use kSurfaceColor instead')
const kWhiteColor = Color(0xFFFFFFFF);
@Deprecated('Use kOnSurfaceColor instead')
const kZambeziColor = Color(0xFF374151); // Gray-700
@Deprecated('Use kOnSurfaceColor instead')
const kBlackColor = Color(0xFF111827); // Gray-900
@Deprecated('Use kOnSurfaceVariantColor instead')
const kTextFieldColor = Color(0xFF6B7280); // Gray-500

// Gradient definitions
const kPrimaryGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [kPrimaryColor, kPrimaryDarkColor],
);

const kSecondaryGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [kSecondaryColor, kSecondaryDarkColor],
);

const kSurfaceGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [kSurfaceColor, kSurfaceVariantColor],
);

// Utility functions for dynamic colors
class AppColors {
  AppColors._();

  static Color primary(BuildContext context) => kPrimaryColor;
  static Color onPrimary(BuildContext context) => kOnPrimaryColor;
  static Color secondary(BuildContext context) => kSecondaryColor;
  static Color onSecondary(BuildContext context) => kOnSecondaryColor;
  static Color surface(BuildContext context) => kSurfaceColor;
  static Color onSurface(BuildContext context) => kOnSurfaceColor;
  static Color error(BuildContext context) => kErrorColor;
  static Color onError(BuildContext context) => kOnErrorColor;

  // Dynamic colors that adapt to theme mode
  static Color adaptiveText(BuildContext context, {double opacity = 1.0}) {
    return kOnSurfaceColor.withOpacity(opacity);
  }

  static Color adaptiveTextSecondary(BuildContext context, {double opacity = 0.7}) {
    return kOnSurfaceVariantColor.withOpacity(opacity);
  }
}
