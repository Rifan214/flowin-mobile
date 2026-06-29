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
}