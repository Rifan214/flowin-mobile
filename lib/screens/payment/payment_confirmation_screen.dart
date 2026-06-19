import 'package:flutter/material.dart';

import '../main_navigation_screen.dart';
import '../tracking/live_delivery_tracking_screen.dart';
import '../../core/constants/app_colors.dart';

class PaymentConfirmationScreen
    extends StatelessWidget {
  const PaymentConfirmationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // SUCCESS ICON
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withValues(
                                alpha: 0.05,
                              ),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration:
                                const BoxDecoration(
                              color:
                                  AppColors.primary,
                              shape:
                                  BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color:
                                  Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      const Text(
                        'Order Confirmed!',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Your fresh supply is on its way.\nWe\'ve sent the details to your email.',
                        textAlign:
                            TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ORDER INFO
                      Container(
                        padding:
                            const EdgeInsets.all(
                          18,
                        ),
                        decoration:
                            BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                          border: Border.all(
                            color: AppColors
                                .border,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Order ID',
                                  style:
                                      TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                ),

                                const Spacer(),

                                Text(
                                  '#AQ-8829104',
                                  style:
                                      TextStyle(
                                    color:
                                        AppColors
                                            .primary,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    fontSize:
                                        24,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            Divider(
                              color: AppColors
                                  .border,
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            const Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Estimated\nDelivery',
                                    textAlign:
                                        TextAlign
                                            .center,
                                    style:
                                        TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                      color: Colors
                                          .grey,
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Today, 2:00 PM - 4:00 PM',
                                    textAlign:
                                        TextAlign
                                            .center,
                                    style:
                                        TextStyle(
                                      fontSize:
                                          20,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // TRACK BUTTON
                      SizedBox(
                        width:
                            double.infinity,
                        height: 58,
                        child:
                            FilledButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const LiveDeliveryTrackingScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.local_shipping,
                          ),
                          label: const Text(
                            'Track My Delivery',
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // BACK HOME
                      SizedBox(
                        width:
                            double.infinity,
                        height: 58,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator
                                .pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const MainNavigationScreen(),
                              ),
                              (route) =>
                                  false,
                            );
                          },
                          child: const Text(
                            'Back to Home',
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      Row(
                        children: [
                          Expanded(
                            child:
                                _infoCard(
                              Icons.eco,
                              'ECO-IMPACT',
                              '2 Plastic bottles saved',
                            ),
                          ),

                          const SizedBox(
                            width: 12,
                          ),

                          Expanded(
                            child:
                                _infoCard(
                              Icons.verified,
                              'PURITY CHECK',
                              'Certified Mineral Grade',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: [
                          Icon(
                            Icons.water_drop,
                            color:
                                Colors.grey[400],
                          ),
                          const SizedBox(
                              width: 4),
                          Text(
                            'Flowin',
                            style:
                                TextStyle(
                              color: Colors
                                  .grey[400],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _infoCard(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}