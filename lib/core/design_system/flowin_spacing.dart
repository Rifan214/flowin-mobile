import 'package:flutter/material.dart';

import 'flowin_colors.dart';

/// Base-4 spacing tokens for consistent rhythm across all Flowin screens.
class FlowinSpacing {
  FlowinSpacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;

  static const double pageGutter = 20;
  static const double cardPadding = 16;
  static const double sectionGap = 24;

  /// Bottom scroll buffer so content clears the floating fluid nav bar.
  static const double navBarClearance = 108;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: pageGutter);
  static const EdgeInsets cardInsets = EdgeInsets.all(cardPadding);
}

/// Geometry & border-radius scale.
class FlowinRadii {
  FlowinRadii._();

  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 22;
  static const double xl = 28;
  static const double pill = 999;

  static final BorderRadius card = BorderRadius.circular(lg);
  static final BorderRadius innerCard = BorderRadius.circular(md);
  static final BorderRadius button = BorderRadius.circular(md);
  static final BorderRadius input = BorderRadius.circular(md);
  static final BorderRadius sheet = const BorderRadius.vertical(top: Radius.circular(28));
  static final BorderRadius fullPill = BorderRadius.circular(pill);
}

/// Layered navy-tinted elevation shadows (adapted from Wonderous & coastal depth hierarchy).
class FlowinShadows {
  FlowinShadows._();

  static List<BoxShadow> get cardSoft => [
        BoxShadow(
          color: FlowinColors.shadowBase.withValues(alpha: 0.055),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: FlowinColors.shadowBase.withValues(alpha: 0.02),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get cardElevated => [
        BoxShadow(
          color: FlowinColors.shadowBase.withValues(alpha: 0.09),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
        BoxShadow(
          color: FlowinColors.primary.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ];

  static List<BoxShadow> get floatingNav => [
        BoxShadow(
          color: FlowinColors.shadowBase.withValues(alpha: 0.14),
          blurRadius: 28,
          offset: const Offset(0, 12),
        ),
      ];

  static List<BoxShadow> get primaryGlow => [
        BoxShadow(
          color: FlowinColors.primary.withValues(alpha: 0.28),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ];
}

