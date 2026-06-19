import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class OrderSummaryCard
    extends StatelessWidget {
  const OrderSummaryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          _row(
            '3× 5 Gallon Spring Water',
            '\$24.00',
          ),
          _row(
            'Delivery Fee',
            '\$2.50',
          ),
          _row(
            'Service Tax',
            '\$1.45',
          ),

          const Divider(),

          _row(
            'Total Amount',
            '\$27.95',
            total: true,
          ),
        ],
      ),
    );
  }

  Widget _row(
    String title,
    String value, {
    bool total = false,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        children: [
          Text(title),

          const Spacer(),

          Text(
            value,
            style: TextStyle(
              fontSize:
                  total ? 32 : 18,
              fontWeight:
                  FontWeight.bold,
              color: total
                  ? AppColors.primary
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}