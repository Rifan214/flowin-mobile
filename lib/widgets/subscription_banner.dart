import 'package:flutter/material.dart';

import '../core/constants/app_text_styles.dart';

class SubscriptionBanner extends StatelessWidget {
  const SubscriptionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0D6EFD),
            Color(0xFF2E86FF),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly\nSubscription',
            style: AppTextStyles.bannerTitle,
          ),
          const SizedBox(height: 10),
          const Text(
            'Save up to 20% on weekly deliveries.',
            style: AppTextStyles.bannerSubtitle,
          ),
          const Spacer(),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            onPressed: () {},
            child: const Text(
              'Explore Plans',
              style: TextStyle(
                color: Color(0xFF0D6EFD),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}