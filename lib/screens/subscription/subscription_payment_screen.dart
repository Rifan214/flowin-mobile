import 'package:flutter/material.dart';

import '../../core/animations/flowin_page_routes.dart';
import '../../core/animations/ticket_fold_card.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../models/subscription_plan.dart';
import '../../shared/widgets/flowin_button.dart';
import '../../state/flowin_app_state.dart';
import '../../widgets/flowin_header.dart';
import 'subscription_success_screen.dart';

class SubscriptionPaymentScreen extends StatelessWidget {
  const SubscriptionPaymentScreen({
    super.key,
    required this.plan,
    this.deliverySlot = 'Morning (08:00 - 11:00)',
  });

  final SubscriptionPlan plan;
  final String deliverySlot;

  @override
  Widget build(BuildContext context) {
    final appState = FlowinScope.of(context);

    return Scaffold(
      backgroundColor: FlowinColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const FlowinHeader(
              title: 'Confirm Plan',
              rightIcon: SizedBox(width: 42),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                child: Column(
                  children: [
                    TicketFoldCard(
                      initiallyExpanded: true,
                      header: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(plan.title, style: FlowinTypography.titleLarge),
                          Text(plan.description, style: FlowinTypography.caption),
                        ],
                      ),
                      foldedSummary: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Cycle Total',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: FlowinTypography.titleMedium,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            FlowinFormat.currency(plan.price),
                            style: FlowinTypography.priceLarge,
                          ),
                        ],
                      ),
                      expandedDetails: Column(
                        children: [
                          _InfoLine(label: 'Slot', value: deliverySlot),
                          const SizedBox(height: 8),
                          _InfoLine(
                            label: 'Destination',
                            value: appState.deliveryTitle,
                          ),
                          const SizedBox(height: 8),
                          _InfoLine(
                            label: 'Payment',
                            value: appState.selectedPaymentMethod.label,
                          ),
                          const SizedBox(height: 8),
                          const _InfoLine(
                            label: 'Priority Shipping',
                            value: 'FREE (Member Perk)',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
              child: FlowinButton(
                label: 'Activate Subscription',
                icon: Icons.verified_rounded,
                onPressed: () {
                  appState.activateSubscription(plan);
                  Navigator.pushAndRemoveUntil(
                    context,
                    FlowinPageRoute.fadeScale(
                      SubscriptionSuccessScreen(plan: plan),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: FlowinTypography.bodyMedium),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: FlowinTypography.titleMedium.copyWith(fontSize: 13.5),
          ),
        ),
      ],
    );
  }
}
