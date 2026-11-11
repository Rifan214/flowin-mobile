import 'package:flutter/material.dart';

import '../core/animations/app_haptics.dart';
import '../core/design_system/flowin_colors.dart';
import '../core/design_system/flowin_motion.dart';
import '../core/design_system/flowin_spacing.dart';
import '../core/design_system/flowin_typography.dart';

class FilterChipWidget extends StatelessWidget {
  const FilterChipWidget({
    super.key,
    required this.title,
    this.selected = false,
    this.onTap,
    this.icon,
  });

  final String title;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppHaptics.selection();
        onTap?.call();
      },
      child: AnimatedContainer(
        duration: FlowinMotion.resolve(context, FlowinDurations.fast),
        curve: FlowinCurves.emphasized,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        decoration: BoxDecoration(
          gradient: selected ? FlowinColors.oceanGradient : null,
          color: selected ? null : FlowinColors.surface,
          borderRadius: FlowinRadii.fullPill,
          border: Border.all(
            color: selected ? Colors.transparent : FlowinColors.border,
          ),
          boxShadow: selected ? FlowinShadows.primaryGlow : FlowinShadows.cardSoft,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 15,
                color: selected ? Colors.white : FlowinColors.primary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              title,
              style: FlowinTypography.caption.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : FlowinColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
