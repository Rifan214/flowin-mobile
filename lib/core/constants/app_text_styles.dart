import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );

  static const TextStyle greetingTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle greetingSubtitle = TextStyle(
    fontSize: 15,
    color: AppColors.textSecondary,
  );

  static const TextStyle productTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle productSubtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle priceLabel = TextStyle(
    fontSize: 11,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle productPrice = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );

  static const TextStyle bannerTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static const TextStyle bannerSubtitle = TextStyle(
    fontSize: 14,
    color: Colors.white,
  );

  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
  );
}