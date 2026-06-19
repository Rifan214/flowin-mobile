import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback? onButtonPressed;

  const OrderCard({
    super.key,
    required this.order,
    this.onButtonPressed,
  });

  String formatPrice(int price) {
    return price
        .toString()
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  @override
  Widget build(BuildContext context) {
    final bool inProgress =
        order.status == 'In Progress';

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(12),
                child: Image.asset(
                  order.image,
                  width: 54,
                  height: 54,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.storeName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.quantity}x ${order.item}',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFEAF3FF,
                  ),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    color: inProgress
                        ? AppColors.primary
                        : Colors.grey,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Divider(
            color: AppColors.border,
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TOTAL PRICE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                        'Rp ${formatPrice(order.totalPrice)}',
                      style: TextStyle(
                        color:
                            AppColors.primary,
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),

              FilledButton(
                onPressed: onButtonPressed,
                child: Text(
                  inProgress
                      ? 'Track'
                      : 'Pesan Lagi',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}