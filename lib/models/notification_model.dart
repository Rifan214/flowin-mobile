import 'package:flutter/material.dart';

class NotificationModel {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final bool isToday;
  final bool isRead;

  const NotificationModel({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.isToday,
    this.isRead = false,
  });

  NotificationModel copyWith({
    String? title,
    String? message,
    String? time,
    IconData? icon,
    bool? isToday,
    bool? isRead,
  }) {
    return NotificationModel(
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      icon: icon ?? this.icon,
      isToday: isToday ?? this.isToday,
      isRead: isRead ?? this.isRead,
    );
  }
}
