import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/subscription_plan.dart';
import '../main_navigation_screen.dart';

class SubscriptionSuccessScreen extends StatelessWidget {
  final SubscriptionPlan plan;

  const SubscriptionSuccessScreen({
    super.key,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),

              Image.asset(
                'assets/images/flowin_logo.png',
                width: 120,
              ),

              const SizedBox(height: 40),

              Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .05),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Center(
                  child: CircleAvatar(
                    radius: 42,
                    backgroundColor: AppColors.primary,
                    child: Icon(
                      Icons.check,
                      size: 52,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                "Subscription Active!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                "Your ${plan.title} subscription has been activated successfully.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 35),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Current Plan",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          plan.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    const Divider(),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        const Text(
                          "Price",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "\$${plan.price}/delivery",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const MainNavigationScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    "Back to Home",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}