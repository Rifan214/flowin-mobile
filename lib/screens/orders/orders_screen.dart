import 'package:flutter/material.dart';

import '../cart/cart_screen.dart';
import '../tracking/live_delivery_tracking_screen.dart';
import '../main_navigation_screen.dart';
import '../../data/dummy_orders.dart';
import '../../widgets/flowin_header.dart';
import '../../widgets/order_card.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const FlowinHeader(),
            const SizedBox(height: 20),

            const Text(
              'Recent Orders',
              style: TextStyle(
                fontSize: 28,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                _buildFilter(
                  'All',
                  true,
                ),
                const SizedBox(width: 10),
                _buildFilter(
                  'In Progress',
                  false,
                ),
                const SizedBox(width: 10),
                _buildFilter(
                  'Completed',
                  false,
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount:
                    dummyOrders.length,
                itemBuilder:
                    (context, index) {
                  return OrderCard(
                    order: dummyOrders[index],
                    onButtonPressed: () {
                      final order = dummyOrders[index];

                      if (order.status == 'In Progress') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const LiveDeliveryTrackingScreen(),
                          ),
                        );
                      } else {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const MainNavigationScreen(
                              initialIndex: 2,
                            ),
                          ),
                          (route) => false,
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildFilter(
    String title,
    bool active,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: active
            ? Colors.blue
            : const Color(
                0xFFE9EDF5,
              ),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: active
              ? Colors.white
              : Colors.black54,
          fontWeight:
              FontWeight.w600,
        ),
      ),
    );
  }
}