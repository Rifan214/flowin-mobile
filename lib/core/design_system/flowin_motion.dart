import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Centralized motion durations, easing curves, and reduced-motion accessibility helpers.
class FlowinDurations {
  FlowinDurations._();

  static const Duration fast = Duration(milliseconds: 160);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration cinematic = Duration(milliseconds: 750);
  static const Duration toastVisible = Duration(milliseconds: 2800);
  static const Duration waveCycle = Duration(milliseconds: 3600);
}

class FlowinCurves {
  FlowinCurves._();

  static const Curve emphasized = Cubic(0.2, 0.0, 0.0, 1.0);
  static const Curve decelerate = Curves.easeOutCubic;
  static const Curve spring = Curves.easeOutBack;
  static const Curve smoothWave = Curves.easeInOutSine;
  static const Curve fluidElastic = CenteredElasticOutCurve(0.55);
}

/// Reduced-motion utility modeled on Wonderous `AppStyle.disableAnimations`.
class FlowinMotion {
  FlowinMotion._();

  static bool isReduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  static Duration resolve(BuildContext context, Duration duration) =>
      isReduced(context) ? Duration.zero : duration;

  /// Smooth stagger delay capped to avoid long waits on dense lists.
  static Duration staggerDelay(
    BuildContext context,
    int index, {
    int stepMs = 45,
    int maxSteps = 8,
  }) {
    if (isReduced(context)) return Duration.zero;
    final cappedIndex = index.clamp(0, maxSteps);
    return Duration(milliseconds: cappedIndex * stepMs);
  }
}

/// Centered elastic curve adapted from Flutter Vignettes `fluid_nav_bar`.
class CenteredElasticOutCurve extends Curve {
  final double period;
  const CenteredElasticOutCurve([this.period = 0.4]);

  @override
  double transformInternal(double t) {
    return math.pow(2.0, -10.0 * t) * math.sin(t * 2.0 * math.pi / period) + 0.5;
  }
}

