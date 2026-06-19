import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class PaymentMethodCard
    extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;

  const PaymentMethodCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color:
                  const Color(0xFFF1F4FA),
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.credit_card,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          Radio<bool>(
            value: true,
            groupValue: selected,
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }
}