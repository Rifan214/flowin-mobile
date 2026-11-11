import 'package:flutter/material.dart';

/// Semantic color palette and curated gradients for Flowin ("Ocean Mist & Deep Current").
class FlowinColors {
  FlowinColors._();

  // Brand & Hydro Spectrum
  static const Color deepOcean = Color(0xFF0A3270);
  static const Color primary = Color(0xFF1565D8);
  static const Color primaryBright = Color(0xFF2186F7);
  static const Color aqua = Color(0xFF00B4D8);
  static const Color aquaBright = Color(0xFF38D9F5);
  static const Color cyanMist = Color(0xFFE6F3FF);
  static const Color cyanTint = Color(0xFFF1F7FF);

  // Neutral Canvas & Ink
  static const Color background = Color(0xFFF3F7FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSubtle = Color(0xFFF8FBFF);
  static const Color ink = Color(0xFF0F1D36);
  static const Color inkSecondary = Color(0xFF526480);
  static const Color inkMuted = Color(0xFF8B9BB4);
  static const Color border = Color(0xFFDCE6F4);
  static const Color divider = Color(0xFFEAF0F8);

  // Accents & Status
  static const Color amber = Color(0xFFFF9F1C);
  static const Color amberSoft = Color(0xFFFFF4E0);
  static const Color success = Color(0xFF0E9F6E);
  static const Color successSoft = Color(0xFFE6F8F1);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSoft = Color(0xFFFEF3C7);
  static const Color danger = Color(0xFFE11D48);
  static const Color dangerSoft = Color(0xFFFFECF0);

  // Shadows
  static const Color shadowBase = Color(0xFF0A2540);

  // Gradients
  static const LinearGradient oceanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0B3B8C),
      Color(0xFF1565D8),
      Color(0xFF0EA5E9),
    ],
  );

  static const LinearGradient deepSplashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF072559),
      Color(0xFF0E49A6),
      Color(0xFF0096C7),
    ],
  );

  static const LinearGradient mistSurfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFEBF4FF),
      Color(0xFFF8FBFF),
    ],
  );

  static const RadialGradient productStageGradient = RadialGradient(
    center: Alignment(0, -0.1),
    radius: 0.9,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFEAF4FF),
    ],
  );

  static const LinearGradient amberGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF9F1C),
      Color(0xFFFFB703),
    ],
  );
}

