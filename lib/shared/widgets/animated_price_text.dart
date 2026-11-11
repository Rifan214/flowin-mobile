import 'package:flutter/material.dart';

import '../../core/design_system/flowin_motion.dart';
import '../../state/flowin_app_state.dart';

/// Smoothly interpolates numeric currency values when cart/checkout totals update.
class AnimatedPriceText extends StatelessWidget {
  const AnimatedPriceText({
    super.key,
    required this.amount,
    required this.style,
  });

  final num amount;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final target = amount.toDouble();
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: target),
      duration: FlowinMotion.resolve(context, FlowinDurations.medium),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) => Text(
        FlowinFormat.currency(value),
        style: style,
      ),
    );
  }
}

