import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../screens/notification/notification_screen.dart';

class FlowinHeader extends StatelessWidget {
  final String title;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final VoidCallback? onLeftIconPressed;
  final Color? textColor;

  const FlowinHeader({
    super.key,
    this.title = 'Flowin',
    this.leftIcon,
    this.rightIcon,
    this.onLeftIconPressed,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        leftIcon != null
            ? IconButton(
                onPressed: onLeftIconPressed ?? () => Navigator.pop(context),
                icon: leftIcon!,
              )
            : const SizedBox(width: 48),

        const Spacer(),

        Text(
          title,
          style: textColor != null 
            ? AppTextStyles.appBarTitle.copyWith(color: textColor)
            : AppTextStyles.appBarTitle,
        ),

        const Spacer(),

        rightIcon != null
            ? rightIcon!
            : Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_none,
                      color: AppColors.primary,
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 8,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '4',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}