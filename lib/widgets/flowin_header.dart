import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';

class FlowinHeader extends StatelessWidget {
  const FlowinHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu,
            color: AppColors.primary,
          ),
        ),

        const Spacer(),

        Text(
          'Flowin',
          style: AppTextStyles.appBarTitle,
        ),

        const Spacer(),

        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}