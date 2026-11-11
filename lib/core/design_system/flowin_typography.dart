import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'flowin_colors.dart';

/// Unified typography scale combining crisp geometric display headings
/// (`Plus Jakarta Sans`) with legible UI text (`Inter`) and offline-safe fallbacks.
class FlowinTypography {
  FlowinTypography._();

  static const List<String> _fallbackStack = [
    'Segoe UI',
    'Roboto',
    'Helvetica Neue',
    'sans-serif',
  ];

  static TextStyle _display({
    required double size,
    FontWeight weight = FontWeight.w700,
    double? height,
    double? letterSpacing,
    Color color = FlowinColors.ink,
    List<FontFeature>? fontFeatures,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
      fontFeatures: fontFeatures,
    ).copyWith(fontFamilyFallback: _fallbackStack);
  }

  static TextStyle _body({
    required double size,
    FontWeight weight = FontWeight.w400,
    double? height,
    double? letterSpacing,
    Color color = FlowinColors.ink,
    List<FontFeature>? fontFeatures,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
      fontFeatures: fontFeatures,
    ).copyWith(fontFamilyFallback: _fallbackStack);
  }

  static TextStyle get displayHero => _display(
        size: 30,
        weight: FontWeight.w800,
        height: 1.15,
        letterSpacing: -0.6,
      );

  static TextStyle get headlineLarge => _display(
        size: 24,
        weight: FontWeight.w700,
        height: 1.22,
        letterSpacing: -0.4,
      );

  static TextStyle get headlineMedium => _display(
        size: 20,
        weight: FontWeight.w700,
        height: 1.28,
        letterSpacing: -0.25,
      );

  static TextStyle get titleLarge => _display(
        size: 17,
        weight: FontWeight.w600,
        height: 1.32,
        letterSpacing: -0.15,
      );

  static TextStyle get titleMedium => _display(
        size: 15,
        weight: FontWeight.w600,
        height: 1.35,
      );

  static TextStyle get bodyLarge => _body(
        size: 15,
        weight: FontWeight.w500,
        height: 1.48,
      );

  static TextStyle get bodyMedium => _body(
        size: 13.5,
        weight: FontWeight.w400,
        height: 1.5,
        color: FlowinColors.inkSecondary,
      );

  static TextStyle get caption => _body(
        size: 12,
        weight: FontWeight.w500,
        height: 1.35,
        color: FlowinColors.inkSecondary,
      );

  static TextStyle get overline => _display(
        size: 11,
        weight: FontWeight.w700,
        letterSpacing: 1.2,
        color: FlowinColors.primary,
      );

  static TextStyle get priceLarge => _display(
        size: 22,
        weight: FontWeight.w800,
        letterSpacing: -0.3,
        color: FlowinColors.primary,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  static TextStyle get priceMedium => _display(
        size: 16,
        weight: FontWeight.w700,
        color: FlowinColors.primary,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  static TextStyle get button => _display(
        size: 15,
        weight: FontWeight.w600,
        letterSpacing: 0.1,
        color: Colors.white,
      );

  static TextTheme get textTheme => TextTheme(
        displaySmall: displayHero,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: caption,
        labelLarge: button,
        labelSmall: overline,
      );
}

