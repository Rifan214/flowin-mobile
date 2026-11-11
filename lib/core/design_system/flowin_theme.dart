import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'flowin_colors.dart';
import 'flowin_spacing.dart';
import 'flowin_typography.dart';

/// Material 3 foundation tailored with Flowin's custom tokens and non-default geometry.
class FlowinTheme {
  FlowinTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: FlowinColors.primary,
      brightness: Brightness.light,
      primary: FlowinColors.primary,
      onPrimary: Colors.white,
      secondary: FlowinColors.aqua,
      onSecondary: Colors.white,
      tertiary: FlowinColors.amber,
      surface: FlowinColors.surface,
      onSurface: FlowinColors.ink,
      error: FlowinColors.danger,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: FlowinColors.background,
      textTheme: FlowinTypography.textTheme,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: FlowinColors.ink),
      ),
      dividerTheme: const DividerThemeData(
        color: FlowinColors.divider,
        thickness: 1,
        space: 1,
      ),
      cardTheme: CardThemeData(
        color: FlowinColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: FlowinRadii.card),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FlowinColors.surfaceSubtle,
        hintStyle: FlowinTypography.bodyMedium.copyWith(color: FlowinColors.inkMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: FlowinRadii.input,
          borderSide: const BorderSide(color: FlowinColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: FlowinRadii.input,
          borderSide: const BorderSide(color: FlowinColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: FlowinRadii.input,
          borderSide: const BorderSide(color: FlowinColors.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: FlowinRadii.input,
          borderSide: const BorderSide(color: FlowinColors.danger, width: 1.4),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: FlowinColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: FlowinColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: FlowinRadii.card),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        side: const BorderSide(color: FlowinColors.inkMuted, width: 1.5),
      ),
    );
  }
}

