import 'package:flutter/material.dart';

import '../core/animations/app_haptics.dart';
import '../core/design_system/flowin_colors.dart';
import '../core/design_system/flowin_spacing.dart';
import '../core/design_system/flowin_typography.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    required this.title,
    required this.address,
    this.onEditPressed,
  });

  final String title;
  final String address;
  final VoidCallback? onEditPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: FlowinColors.surface,
        borderRadius: FlowinRadii.card,
        boxShadow: FlowinShadows.cardSoft,
        border: Border.all(color: FlowinColors.border.withValues(alpha: 0.8)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: FlowinColors.mistSurfaceGradient,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: FlowinColors.cyanMist),
            ),
            child: Image.asset(
              'assets/images/map_preview.png',
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Icon(
                Icons.location_on_rounded,
                color: FlowinColors.primary,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FlowinTypography.titleMedium.copyWith(fontSize: 14.5),
                ),
                const SizedBox(height: 3),
                Text(
                  address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: FlowinTypography.caption,
                ),
              ],
            ),
          ),
          if (onEditPressed != null)
            TextButton(
              onPressed: () {
                AppHaptics.light();
                onEditPressed!();
              },
              child: Text(
                'Edit',
                style: FlowinTypography.titleMedium.copyWith(
                  color: FlowinColors.primary,
                  fontSize: 13.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
