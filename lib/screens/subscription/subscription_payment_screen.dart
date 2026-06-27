import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/subscription_plan.dart';
import 'subscription_success_screen.dart';

class SubscriptionPaymentScreen extends StatefulWidget {
  final SubscriptionPlan plan;

  const SubscriptionPaymentScreen({
    super.key,
    required this.plan,
  });

  @override
  State<SubscriptionPaymentScreen> createState() =>
      _SubscriptionPaymentScreenState();
}

class _SubscriptionPaymentScreenState
    extends State<SubscriptionPaymentScreen> {

  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 3),
      () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                SubscriptionSuccessScreen(
              plan: widget.plan,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),

      body: SafeArea(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 28,
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [

                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: AppColors.primary
                        .withValues(alpha: .1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.credit_card,
                    size: 58,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 40),

                const Text(
                  "Processing Payment",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  "Please wait while we activate your ${widget.plan.title} subscription.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.grey,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 40),

                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(
                            20),
                  ),
                  child: Column(
                    children: [

                      Row(
                        children: [

                          const Icon(
                            Icons.water_drop,
                            color: AppColors.primary,
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              widget.plan.title,
                              style:
                                  const TextStyle(
                                fontSize: 22,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ),

                          Text(
                            "\$${widget.plan.price}",
                            style:
                                const TextStyle(
                              fontSize: 24,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  AppColors.primary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      const Divider(),

                      const SizedBox(height: 16),

                      Row(
                        children: const [

                          Icon(
                            Icons.lock,
                            color: Colors.green,
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              "Secure payment is being processed",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                const CircularProgressIndicator(
                  color: AppColors.primary,
                ),

                const SizedBox(height: 24),

                const Text(
                  "Processing...",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}