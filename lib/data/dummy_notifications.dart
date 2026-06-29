import 'package:flutter/material.dart';

import '../models/notification_model.dart';

const List<NotificationModel> dummyNotifications = [

  NotificationModel(
    title: 'Driver Assigned',
    message:
        'Michael is assigned to your delivery #FW-8832. Estimated arrival in 45 mins.',
    time: '10:42 AM',
    icon: Icons.local_shipping,
    isToday: true,
  ),

  NotificationModel(
    title: 'Order Confirmed',
    message:
        'Your order for 3x Premium Alkaline Water Carboys has been received.',
    time: '09:15 AM',
    icon: Icons.check_circle,
    isToday: true,
  ),

  NotificationModel(
    title: 'Payment Successful',
    message:
        'Payment of \$45.00 for order #FW-8810 was successfully processed.',
    time: 'Yesterday',
    icon: Icons.credit_card,
    isToday: false,
  ),

  NotificationModel(
    title: 'Empty Bottles Collected',
    message:
        'We successfully picked up 4 empty bottles from your location.',
    time: 'Yesterday',
    icon: Icons.delete_outline,
    isToday: false,
  ),
];