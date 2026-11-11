import 'package:flutter/material.dart';

import '../design_system/flowin_colors.dart';

/// Legacy compatibility bridge delegating to [FlowinColors].
class AppColors {
  static const Color primary = FlowinColors.primary;
  static const Color secondary = FlowinColors.amber;
  static const Color background = FlowinColors.background;
  static const Color surface = FlowinColors.surface;
  static const Color textPrimary = FlowinColors.ink;
  static const Color textSecondary = FlowinColors.inkSecondary;
  static const Color border = FlowinColors.border;
  static const Color chipSelected = FlowinColors.cyanMist;
  static const Color bannerBlue = FlowinColors.primaryBright;
  static const Color success = FlowinColors.success;
}
