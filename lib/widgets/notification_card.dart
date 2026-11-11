import 'package:flutter/material.dart';

import '../core/design_system/flowin_colors.dart';
import '../core/design_system/flowin_spacing.dart';
import '../core/design_system/flowin_typography.dart';
import '../models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  final NotificationModel notification;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final unread = !notification.isRead;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: unread ? FlowinColors.cyanTint : FlowinColors.surface,
          borderRadius: FlowinRadii.card,
          boxShadow: FlowinShadows.cardSoft,
          border: Border.all(
            color: unread
                ? FlowinColors.primary.withValues(alpha: 0.28)
                : FlowinColors.border.withValues(alpha: 0.7),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: unread ? FlowinColors.primary : FlowinColors.cyanMist,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                notification.icon,
                size: 20,
                color: unread ? Colors.white : FlowinColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: FlowinTypography.titleMedium.copyWith(
                            fontSize: 14.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        notification.time,
                        style: FlowinTypography.caption.copyWith(fontSize: 11),
                      ),
                      if (unread) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: FlowinColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: FlowinTypography.bodyMedium.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
