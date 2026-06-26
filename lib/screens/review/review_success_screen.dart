import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../main_navigation_screen.dart';

class ReviewSuccessScreen extends StatelessWidget {
  const ReviewSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Column(
            children: [
              const SizedBox(height: 30),

              Image.asset(
                'assets/images/flowin_logo.png',
                width: 170,
              ),

              const Spacer(),

              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.08),
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
                      color: Colors.white,
                      size: 52,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 60),

              const Text(
                "Rating Berhasil",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton(
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
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 55),

              Opacity(
                opacity: .35,
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.water_drop_outlined,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Flowin",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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