import 'package:flutter/material.dart';

import '../../core/animations/flowin_page_routes.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../models/subscription_plan.dart';
import '../../shared/widgets/flowin_button.dart';
import '../../shared/widgets/flowin_text_field.dart';
import '../../shared/widgets/flowin_toast.dart';
import '../../state/flowin_app_state.dart';
import '../../widgets/address_card.dart';
import '../../widgets/flowin_header.dart';
import '../../widgets/payment_method_card.dart';
import 'subscription_payment_screen.dart';

class SubscriptionCheckoutScreen extends StatefulWidget {
  const SubscriptionCheckoutScreen({super.key, required this.plan});

  final SubscriptionPlan plan;

  @override
  State<SubscriptionCheckoutScreen> createState() =>
      _SubscriptionCheckoutScreenState();
}

class _SubscriptionCheckoutScreenState
    extends State<SubscriptionCheckoutScreen> {
  String _preferredSlot = 'Morning (08:00 - 11:00)';
  bool _agreedTerms = true;

  static const List<String> _slots = [
    'Morning (08:00 - 11:00)',
    'Afternoon (13:00 - 16:00)',
    'Evening (17:00 - 20:00)',
  ];

  void _editAddress(FlowinAppState appState) {
    final titleCtrl = TextEditingController(text: appState.deliveryTitle);
    final addrCtrl = TextEditingController(text: appState.deliveryAddress);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          22,
          18,
          22,
          MediaQuery.viewInsetsOf(ctx).bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Delivery Address', style: FlowinTypography.headlineMedium),
            const SizedBox(height: 12),
            FlowinTextField(label: 'Label', controller: titleCtrl),
            const SizedBox(height: 12),
            FlowinTextField(
              label: 'Street Address',
              controller: addrCtrl,
              maxLines: 2,
            ),
            const SizedBox(height: 18),
            FlowinButton(
              label: 'Update Address',
              onPressed: () {
                appState.updateDeliveryAddress(
                  title: titleCtrl.text,
                  address: addrCtrl.text,
                );
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    ).whenComplete(() {
      titleCtrl.dispose();
      addrCtrl.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = FlowinScope.of(context);

    return Scaffold(
      backgroundColor: FlowinColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const FlowinHeader(
              title: 'Plan Checkout',
              rightIcon: Icon(Icons.help_outline_rounded),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Plan Recap Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: FlowinColors.mistSurfaceGradient,
                        borderRadius: FlowinRadii.card,
                        border: Border.all(color: FlowinColors.cyanMist),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              gradient: FlowinColors.oceanGradient,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.autorenew_rounded,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.plan.title,
                                  style: FlowinTypography.titleLarge,
                                ),
                                Text(
                                  widget.plan.description,
                                  style: FlowinTypography.caption,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            FlowinFormat.currency(widget.plan.price),
                            style: FlowinTypography.priceMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Delivery Destination',
                      style: FlowinTypography.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    AddressCard(
                      title: appState.deliveryTitle,
                      address: appState.deliveryAddress,
                      onEditPressed: () => _editAddress(appState),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Preferred Delivery Window',
                      style: FlowinTypography.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _slots.map((slot) {
                        final active = _preferredSlot == slot;
                        return ChoiceChip(
                          label: Text(slot),
                          selected: active,
                          selectedColor: FlowinColors.cyanMist,
                          onSelected: (_) =>
                              setState(() => _preferredSlot = slot),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Payment Method',
                      style: FlowinTypography.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    for (final method in appState.paymentMethods.take(3))
                      PaymentMethodCard(
                        title: method.label,
                        subtitle: method.isWallet
                            ? 'Balance: ${FlowinFormat.currency(appState.walletBalance)}'
                            : method.subtitle,
                        icon: method.icon,
                        accentColor: method.accentColor,
                        selected: appState.selectedPaymentId == method.id,
                        onTap: () => appState.selectPaymentMethod(method.id),
                      ),

                    Row(
                      children: [
                        Checkbox(
                          value: _agreedTerms,
                          onChanged: (v) =>
                              setState(() => _agreedTerms = v ?? false),
                        ),
                        Expanded(
                          child: Text(
                            'I agree to recurring refills & can pause or cancel anytime.',
                            style: FlowinTypography.caption,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
              child: FlowinButton(
                label: 'Review & Activate',
                trailingIcon: Icons.arrow_forward_rounded,
                onPressed: () {
                  if (!_agreedTerms) {
                    FlowinToast.show(
                      context,
                      title: 'Confirm Subscription Terms',
                      message: 'Tick the recurring refill box to continue.',
                      type: FlowinToastType.warning,
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    FlowinPageRoute.sharedAxis(
                      SubscriptionPaymentScreen(
                        plan: widget.plan,
                        deliverySlot: _preferredSlot,
                      ),
                    ),
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
