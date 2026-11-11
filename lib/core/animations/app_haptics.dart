import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Platform-safe tactile feedback inspired by Wonderous `AppHaptics`.
class AppHaptics {
  AppHaptics._();

  static bool get _isMobileDevice =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  static void light() {
    if (_isMobileDevice) {
      HapticFeedback.lightImpact();
    }
  }

  static void medium() {
    if (_isMobileDevice) {
      HapticFeedback.mediumImpact();
    }
  }

  static void selection() {
    if (_isMobileDevice) {
      HapticFeedback.selectionClick();
    }
  }

  static void confirm() {
    if (_isMobileDevice) {
      HapticFeedback.heavyImpact();
    }
  }
}

