import 'package:flutter/material.dart';

import '../design_system/flowin_typography.dart';

/// Legacy compatibility bridge delegating to [FlowinTypography].
class AppTextStyles {
  static TextStyle get headingLarge => FlowinTypography.headlineLarge;
  static TextStyle get headingMedium => FlowinTypography.headlineMedium;
  static TextStyle get greetingTitle => FlowinTypography.headlineLarge;
  static TextStyle get greetingSubtitle => FlowinTypography.bodyMedium;
  static TextStyle get appBarTitle => FlowinTypography.titleLarge;
  static TextStyle get productTitle => FlowinTypography.titleMedium;
  static TextStyle get cardTitle => FlowinTypography.titleMedium;
  static TextStyle get bannerTitle =>
      FlowinTypography.titleLarge.copyWith(color: Colors.white);
  static TextStyle get bannerSubtitle =>
      FlowinTypography.caption.copyWith(color: Colors.white70);
  static TextStyle get body => FlowinTypography.bodyLarge;
  static TextStyle get caption => FlowinTypography.caption;
  static TextStyle get price => FlowinTypography.priceMedium;
  static TextStyle get priceLabel => FlowinTypography.priceMedium;
  static TextStyle get button => FlowinTypography.button;
}
