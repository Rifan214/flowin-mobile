import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../data/dummy_subscription.dart';
import '../../widgets/subscription_card.dart';
import 'subscription_checkout_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() =>
      _SubscriptionScreenState();
}

class _SubscriptionScreenState
    extends State<SubscriptionScreen> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Flowin',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primary,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  28,
                  20,
                  20,
                ),
                child: Column(
                  children: [
                    const Text(
                      'Choose Your Flow',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      'Select a hydration plan that fits your lifestyle. Cancel anytime.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 32),

                    ListView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount:
                          dummySubscriptions.length,
                      itemBuilder:
                          (context, index) {
                        return SubscriptionCard(
                          plan:
                              dummySubscriptions[index],
                          isSelected:
                              selectedIndex == index,
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    SubscriptionCheckoutScreen(
                                  plan:
                                      dummySubscriptions[
                                          index],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: FilledButton(
                        style:
                            FilledButton.styleFrom(
                          backgroundColor:
                              AppColors.primary,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SubscriptionCheckoutScreen(
                                plan:
                                    dummySubscriptions[
                                        selectedIndex],
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Subscribe Now',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}