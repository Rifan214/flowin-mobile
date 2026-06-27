import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/subscription_plan.dart';
import '../../widgets/address_card.dart';
import '../../widgets/order_summary_card.dart';
import '../../widgets/payment_method_card.dart';
import 'subscription_payment_screen.dart';

class SubscriptionCheckoutScreen extends StatelessWidget {
  final SubscriptionPlan plan;

  const SubscriptionCheckoutScreen({
    super.key,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F8FC),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 56,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(18),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      SubscriptionPaymentScreen(
                    plan: plan,
                  ),
                ),
              );
            },
            child: const Text(
              'Confirm Payment',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Row(
                children: [

                  IconButton(
                    onPressed: () {
                      Navigator.pop(
                          context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                  ),

                  const Spacer(),

                  const Text(
                    "Checkout",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          AppColors.primary,
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.help_outline,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                children: [

                  const Text(
                    "Delivery Address",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Edit",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const AddressCard(),

              const SizedBox(height: 28),

              const Text(
                "Subscription Plan",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              Container(
                padding:
                    const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(
                          18),
                  border: Border.all(
                    color:
                        AppColors.border,
                  ),
                ),
                child: Row(
                  children: [

                    Container(
                      width: 62,
                      height: 62,
                      decoration:
                          BoxDecoration(
                        color: AppColors
                            .primary
                            .withValues(alpha: .1),
                        borderRadius:
                            BorderRadius
                                .circular(
                                    14),
                      ),
                      child: const Icon(
                        Icons.water_drop,
                        color:
                            AppColors.primary,
                        size: 32,
                      ),
                    ),

                    const SizedBox(
                        width: 18),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [

                          Text(
                            plan.title,
                            style:
                                const TextStyle(
                              fontSize:
                                  22,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          const SizedBox(
                              height: 6),

                          Text(
                            plan.description,
                            style:
                                const TextStyle(
                              color: Colors
                                  .grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      "\$${plan.price}",
                      style:
                          const TextStyle(
                        fontSize: 28,
                        fontWeight:
                            FontWeight
                                .bold,
                        color:
                            AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                "Payment Method",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              const PaymentMethodCard(
                title: "•••• 4242",
                subtitle:
                    "Expires 12/26",
                selected: true,
              ),

              const PaymentMethodCard(
                title:
                    "Digital Wallet",
                subtitle:
                    "Apple Pay / Google Pay",
                selected: false,
              ),

              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "+ Add New Method",
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "Order Summary",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              OrderSummaryCard(
                itemName:
                    "${plan.title} Subscription",
                itemPrice:
                    plan.price.toDouble(),
              ),

              const SizedBox(height: 24),

              const Center(
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .center,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "END-TO-END ENCRYPTED PAYMENT",
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 120,
              ),
            ],
          ),
        ),
      ),
    );
  }
}