import 'package:flutter/material.dart';

import '../core/animations/app_haptics.dart';
import '../core/design_system/flowin_colors.dart';
import '../core/design_system/flowin_motion.dart';
import '../core/design_system/flowin_spacing.dart';
import '../core/design_system/flowin_typography.dart';
import '../models/subscription_plan.dart';
import '../state/flowin_app_state.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  final SubscriptionPlan plan;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppHaptics.selection();
        onTap();
      },
      child: AnimatedContainer(
        duration: FlowinMotion.resolve(context, FlowinDurations.medium),
        curve: FlowinCurves.emphasized,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? FlowinColors.cyanTint : FlowinColors.surface,
          borderRadius: FlowinRadii.card,
          boxShadow: isSelected ? FlowinShadows.primaryGlow : FlowinShadows.cardSoft,
          border: Border.all(
            color: isSelected
                ? FlowinColors.primary
                : (plan.isPopular
                    ? FlowinColors.aqua.withValues(alpha: 0.45)
                    : FlowinColors.border),
            width: isSelected ? 2.0 : 1.1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (plan.badge.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: plan.isPopular
                                ? FlowinColors.oceanGradient
                                : FlowinColors.amberGradient,
                            borderRadius: FlowinRadii.fullPill,
                          ),
                          child: Text(
                            plan.badge.toUpperCase(),
                            style: FlowinTypography.overline.copyWith(
                              color: Colors.white,
                              fontSize: 9.5,
                            ),
                          ),
                        ),
                      Text(
                        plan.title,
                        style: FlowinTypography.titleLarge,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      FlowinFormat.currency(plan.price),
                      style: FlowinTypography.priceLarge.copyWith(fontSize: 20),
                    ),
                    Text(
                      '/ cycle',
                      style: FlowinTypography.caption.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(plan.description, style: FlowinTypography.bodyMedium),
            const SizedBox(height: 12),
            ...plan.features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: FlowinColors.success,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: FlowinTypography.caption.copyWith(
                          color: FlowinColors.ink,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
