import 'package:flutter/material.dart';

import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../shared/widgets/flowin_toast.dart';
import '../../state/flowin_app_state.dart';
import '../../widgets/flowin_header.dart';
import '../../widgets/notification_card.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = FlowinScope.of(context);
    final list = appState.notifications;
    final todayIndices = <int>[];
    final earlierIndices = <int>[];
    for (int i = 0; i < list.length; i++) {
      if (list[i].isToday) {
        todayIndices.add(i);
      } else {
        earlierIndices.add(i);
      }
    }

    return Scaffold(
      backgroundColor: FlowinColors.background,
      body: SafeArea(
        child: Column(
          children: [
            FlowinHeader(
              title: 'Notifications',
              actions: [
                if (appState.unreadNotificationsCount > 0)
                  TextButton(
                    onPressed: () {
                      appState.markAllNotificationsRead();
                      FlowinToast.show(
                        context,
                        title: 'All Caught Up',
                        message: 'Every notification marked as read.',
                        type: FlowinToastType.info,
                      );
                    },
                    child: Text(
                      'Mark all',
                      style: FlowinTypography.caption.copyWith(
                        color: FlowinColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 42),
              ],
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  if (todayIndices.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        'TODAY',
                        style: FlowinTypography.overline.copyWith(
                          color: FlowinColors.inkSecondary,
                        ),
                      ),
                    ),
                    for (final i in todayIndices)
                      NotificationCard(
                        notification: list[i],
                        onTap: () => appState.markNotificationRead(i),
                      ),
                    const SizedBox(height: 16),
                  ],
                  if (earlierIndices.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        'EARLIER',
                        style: FlowinTypography.overline.copyWith(
                          color: FlowinColors.inkSecondary,
                        ),
                      ),
                    ),
                    for (final i in earlierIndices)
                      NotificationCard(
                        notification: list[i],
                        onTap: () => appState.markNotificationRead(i),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
