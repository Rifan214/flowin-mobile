import 'package:flutter/material.dart';

import '../core/animations/app_haptics.dart';
import '../core/design_system/flowin_colors.dart';
import '../core/design_system/flowin_spacing.dart';
import '../core/design_system/flowin_typography.dart';
import '../models/order.dart';
import '../shared/widgets/hydration_product_stage.dart';
import '../state/flowin_app_state.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    this.onButtonPressed,
  });

  final Order order;
  final VoidCallback? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    final isInProgress = order.status == 'In Progress';
    final statusColor = isInProgress ? FlowinColors.primary : FlowinColors.success;
    final statusBg =
        isInProgress ? FlowinColors.cyanMist : FlowinColors.successSoft;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: FlowinColors.surface,
        borderRadius: FlowinRadii.card,
        boxShadow: FlowinShadows.cardSoft,
        border: Border.all(
          color: isInProgress
              ? FlowinColors.primary.withValues(alpha: 0.25)
              : FlowinColors.border.withValues(alpha: 0.7),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 68,
                height: 68,
                child: HydrationProductStage(
                  imagePath: order.image,
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
                            order.item,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: FlowinTypography.titleMedium,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: FlowinRadii.fullPill,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                order.status,
                                style: FlowinTypography.overline.copyWith(
                                  fontSize: 10,
                                  color: statusColor,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.storeName} • ${order.quantity}x Gallon',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FlowinTypography.caption,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          FlowinFormat.currency(order.totalPrice),
                          style: FlowinTypography.priceMedium.copyWith(
                            fontSize: 15,
                          ),
                        ),
                        Material(
                          color: isInProgress
                              ? FlowinColors.primary
                              : FlowinColors.cyanMist,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              AppHaptics.light();
                              onButtonPressed?.call();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isInProgress
                                        ? Icons.near_me_rounded
                                        : Icons.replay_rounded,
                                    size: 15,
                                    color: isInProgress
                                        ? Colors.white
                                        : FlowinColors.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    isInProgress ? 'Track' : 'Order Again',
                                    style: FlowinTypography.caption.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: isInProgress
                                          ? Colors.white
                                          : FlowinColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
