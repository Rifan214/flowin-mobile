import 'package:flutter/material.dart';

import '../core/animations/app_haptics.dart';
import '../core/design_system/flowin_colors.dart';
import '../core/design_system/flowin_spacing.dart';
import '../core/design_system/flowin_typography.dart';
import '../models/cart_item.dart';
import '../shared/widgets/animated_price_text.dart';
import '../shared/widgets/hydration_product_stage.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    this.onIncrement,
    this.onDecrement,
    this.onRemove,
  });

  final CartItem item;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: FlowinColors.surface,
        borderRadius: FlowinRadii.card,
        boxShadow: FlowinShadows.cardSoft,
        border: Border.all(color: FlowinColors.border.withValues(alpha: 0.7)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: HydrationProductStage(
              imagePath: item.image,
              borderRadius: 14,
              padding: const EdgeInsets.all(6),
              showShadowPedestal: false,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FlowinTypography.titleMedium,
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 30,
                        minHeight: 30,
                      ),
                      onPressed: () {
                        AppHaptics.medium();
                        onRemove?.call();
                      },
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 19,
                        color: FlowinColors.inkMuted,
                      ),
                    ),
                  ],
                ),
                Text(
                  item.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FlowinTypography.caption,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: AnimatedPriceText(
                            amount: item.lineTotal,
                            style: FlowinTypography.priceMedium
                                .copyWith(fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: FlowinColors.surfaceSubtle,
                        borderRadius: FlowinRadii.fullPill,
                        border: Border.all(color: FlowinColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _StepperBtn(
                            icon: item.quantity <= 1
                                ? Icons.delete_outline_rounded
                                : Icons.remove_rounded,
                            onTap: () {
                              AppHaptics.selection();
                              onDecrement?.call();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 180),
                              transitionBuilder: (child, anim) =>
                                  ScaleTransition(scale: anim, child: child),
                              child: Text(
                                '${item.quantity}',
                                key: ValueKey(item.quantity),
                                style: FlowinTypography.titleMedium.copyWith(
                                  fontSize: 13.5,
                                ),
                              ),
                            ),
                          ),
                          _StepperBtn(
                            icon: Icons.add_rounded,
                            isPrimary: true,
                            onTap: () {
                              AppHaptics.selection();
                              onIncrement?.call();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperBtn extends StatelessWidget {
  const _StepperBtn({
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPrimary ? FlowinColors.primary : Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 28,
          height: 28,
          child: Icon(
            icon,
            size: 16,
            color: isPrimary ? Colors.white : FlowinColors.ink,
          ),
        ),
      ),
    );
  }
}
