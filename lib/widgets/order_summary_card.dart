import 'package:flutter/material.dart';

import '../core/animations/ticket_fold_card.dart';
import '../core/design_system/flowin_colors.dart';
import '../core/design_system/flowin_typography.dart';
import '../shared/widgets/animated_price_text.dart';

/// Expandable 3D ticket-fold order summary card.
class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({
    super.key,
    this.itemName = 'Pure Hydration Refill',
    this.itemPrice = 58000,
    this.deliveryFee = 5000,
    this.serviceTax = 2900,
  });

  final String itemName;
  final double itemPrice;
  final double deliveryFee;
  final double serviceTax;

  double get _total => itemPrice + deliveryFee + serviceTax;

  @override
  Widget build(BuildContext context) {
    return TicketFoldCard(
      initiallyExpanded: true,
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Receipt', style: FlowinTypography.titleLarge),
          const SizedBox(height: 2),
          Text(
            itemName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FlowinTypography.caption,
          ),
        ],
      ),
      foldedSummary: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Total Payable',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FlowinTypography.titleMedium.copyWith(fontSize: 15),
            ),
          ),
          const SizedBox(width: 8),
          AnimatedPriceText(
            amount: _total,
            style: FlowinTypography.priceLarge.copyWith(fontSize: 19),
          ),
        ],
      ),
      expandedDetails: Column(
        children: [
          _ReceiptRow(label: 'Items Subtotal', amount: itemPrice),
          const SizedBox(height: 8),
          _ReceiptRow(label: 'Express Courier Fee', amount: deliveryFee),
          const SizedBox(height: 8),
          _ReceiptRow(label: 'Service & Sanitation Tax', amount: serviceTax),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Sanitized Bottle Return',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FlowinTypography.caption.copyWith(
                    color: FlowinColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Included',
                style: FlowinTypography.caption.copyWith(
                  color: FlowinColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({required this.label, required this.amount});

  final String label;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FlowinTypography.bodyMedium,
          ),
        ),
        const SizedBox(width: 8),
        AnimatedPriceText(
          amount: amount,
          style: FlowinTypography.titleMedium.copyWith(fontSize: 13.5),
        ),
      ],
    );
  }
}
