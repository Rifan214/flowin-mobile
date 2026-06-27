import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class OrderSummaryCard extends StatelessWidget {
  final String itemName;
  final double itemPrice;
  final double deliveryFee;
  final double serviceTax;

  const OrderSummaryCard({
    super.key,
    this.itemName = '3× 5 Gallon Spring Water',
    this.itemPrice = 24.00,
    this.deliveryFee = 2.50,
    this.serviceTax = 1.45,
  });

  double get total =>
      itemPrice + deliveryFee + serviceTax;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          _row(
            itemName,
            '\$${itemPrice.toStringAsFixed(2)}',
          ),

          _row(
            'Delivery Fee',
            '\$${deliveryFee.toStringAsFixed(2)}',
          ),

          _row(
            'Service Tax',
            '\$${serviceTax.toStringAsFixed(2)}',
          ),

          const Divider(),

          _row(
            'Total Amount',
            '\$${total.toStringAsFixed(2)}',
            totalRow: true,
          ),
        ],
      ),
    );
  }

  Widget _row(
    String title,
    String value, {
    bool totalRow = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize:
                    totalRow ? 18 : 16,
                fontWeight: totalRow
                    ? FontWeight.bold
                    : FontWeight.w500,
              ),
            ),
          ),

          Text(
            value,
            style: TextStyle(
              fontSize:
                  totalRow ? 28 : 18,
              fontWeight:
                  FontWeight.bold,
              color: totalRow
                  ? AppColors.primary
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}