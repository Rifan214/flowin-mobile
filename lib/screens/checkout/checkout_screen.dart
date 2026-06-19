import 'package:flutter/material.dart';

import '../payment/payment_confirmation_screen.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/address_card.dart';
import '../../widgets/order_summary_card.dart';
import '../../widgets/payment_method_card.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 56,
          child: FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const PaymentConfirmationScreen(),
                ),
              );
            },
            child: const Text(
              'Confirm Payment',
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
                    onPressed: () =>
                        Navigator.pop(
                            context),
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                  ),

                  const Spacer(),

                  const Text(
                    'Checkout',
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
                    'Delivery Address',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  TextButton(
                    onPressed: () {
                    },
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const AddressCard(),

              const SizedBox(height: 30),

              const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              const PaymentMethodCard(
                title: '•••• 4242',
                subtitle:
                    'Expires 12/26',
                selected: true,
              ),

              const PaymentMethodCard(
                title:
                    'Digital Wallet',
                subtitle:
                    'Apple Pay / Google Pay',
                selected: false,
              ),

              const SizedBox(height: 10),

              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    '+ Add New Method',
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              const OrderSummaryCard(),

              const SizedBox(height: 24),

              const Center(
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'END-TO-END ENCRYPTED PAYMENT',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}