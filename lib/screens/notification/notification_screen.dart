import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../data/dummy_notifications.dart';
import '../../widgets/notification_card.dart';
import '../../widgets/flowin_header.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todayNotifications = dummyNotifications
        .where((item) => item.isToday)
        .toList();

    final yesterdayNotifications = dummyNotifications
        .where((item) => !item.isToday)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FlowinHeader(
                leftIcon: Icon(Icons.arrow_back_ios_new),
                rightIcon: SizedBox(width: 48),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  const Text(
                    "Notifications",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "All notifications marked as read",
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Mark all as read",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const Divider(),

              const SizedBox(height: 20),

              const Text(
                "TODAY",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 16),

              ...todayNotifications.map(
                (notification) => NotificationCard(
                  notification: notification,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          notification.title,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                "YESTERDAY",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 16),

              ...yesterdayNotifications.map(
                (notification) => NotificationCard(
                  notification: notification,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          notification.title,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}