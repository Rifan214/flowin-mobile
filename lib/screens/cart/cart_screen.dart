import 'package:flutter/material.dart';

import '../checkout/checkout_screen.dart';
import '../../core/constants/app_colors.dart';
import '../../data/dummy_cart.dart';
import '../../widgets/flowin_header.dart';
import '../../widgets/cart_item_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const FlowinHeader(),
            const SizedBox(height: 20),

            const Text(
              'Your Cart',
              style: TextStyle(
                fontSize: 30,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Review your hydration essentials',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 24),

            ...dummyCartItems.map(
              (item) => CartItemCard(
                item: item,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding:
                  const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color:
                    const Color(0xFFEAF2FF),
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
                border: Border.all(
                  color:
                      AppColors.primary,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_shipping,
                    color:
                        AppColors.primary,
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          'Delivery To',
                          style: TextStyle(
                            color: AppColors
                                .primary,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '2442 Riverside Dr, Suite 402',
                        ),
                      ],
                    ),
                  ),

                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Edit',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Container(
              padding:
                  const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),
              child: Column(
                children: [
                  _row(
                    'Subtotal',
                    '\$42.50',
                  ),
                  _row(
                    'Delivery Fee',
                    '\$4.99',
                  ),
                  _row(
                    'Service Tax (5%)',
                    '\$2.12',
                  ),
                  const Divider(),
                  _row(
                    'Total Amount',
                    '\$49.61',
                    true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const CheckoutScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Proceed to Checkout →',
                ),
              ),
            ),

            const SizedBox(height: 18),

            const Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'Estimated arrival: ',
                    ),
                    TextSpan(
                      text:
                          'Today, 4 PM - 6 PM',
                      style: TextStyle(
                        color:
                            AppColors
                                .primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  static Widget _row(
    String title,
    String value, [
    bool total = false,
  ]) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize:
                  total ? 18 : 16,
              fontWeight: total
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize:
                  total ? 24 : 16,
              color: total
                  ? AppColors.primary
                  : Colors.black,
              fontWeight: total
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}