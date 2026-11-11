import 'package:flutter/material.dart';

import '../design_system/flowin_theme.dart';

/// Legacy compatibility bridge delegating to [FlowinTheme].
class AppTheme {
  static ThemeData get lightTheme => FlowinTheme.light;
}
