import 'package:flutter/material.dart';

import '../../core/animations/flowin_page_routes.dart';
import '../../core/animations/staggered_reveal.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../shared/widgets/flowin_button.dart';
import '../../shared/widgets/flowin_text_field.dart';
import '../../shared/widgets/flowin_toast.dart';
import '../../state/flowin_app_state.dart';
import '../../widgets/address_card.dart';
import '../../widgets/flowin_header.dart';
import '../../widgets/order_summary_card.dart';
import '../../widgets/payment_method_card.dart';
import '../payment/payment_confirmation_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  void _openEditAddress(BuildContext context, FlowinAppState appState) {
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
            Text('Update Drop Location', style: FlowinTypography.headlineMedium),
            const SizedBox(height: 14),
            FlowinTextField(
              label: 'Address Label',
              controller: titleCtrl,
              prefixIcon: Icons.bookmark_outline_rounded,
            ),
            const SizedBox(height: 12),
            FlowinTextField(
              label: 'Complete Street Address',
              controller: addrCtrl,
              prefixIcon: Icons.location_on_outlined,
              maxLines: 2,
            ),
            const SizedBox(height: 18),
            FlowinButton(
              label: 'Save Address',
              onPressed: () {
                appState.updateDeliveryAddress(
                  title: titleCtrl.text,
                  address: addrCtrl.text,
                );
                Navigator.pop(ctx);
                FlowinToast.show(
                  context,
                  title: 'Delivery Address Updated',
                  type: FlowinToastType.success,
                );
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

  void _openAddPaymentMethod(BuildContext context, FlowinAppState appState) {
    final labelCtrl = TextEditingController();
    final subCtrl = TextEditingController();

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
            Text('Add Payment Method', style: FlowinTypography.headlineMedium),
            const SizedBox(height: 14),
            FlowinTextField(
              label: 'Card or E-Wallet Name',
              hint: 'e.g. Mastercard •••• 8821',
              controller: labelCtrl,
              prefixIcon: Icons.credit_card_rounded,
            ),
            const SizedBox(height: 12),
            FlowinTextField(
              label: 'Details / Expiry',
              hint: 'e.g. Expires 11/29',
              controller: subCtrl,
              prefixIcon: Icons.info_outline_rounded,
            ),
            const SizedBox(height: 18),
            FlowinButton(
              label: 'Save & Select',
              onPressed: () {
                if (labelCtrl.text.trim().isEmpty) return;
                appState.addPaymentMethod(
                  labelCtrl.text.trim(),
                  subCtrl.text.trim().isEmpty
                      ? 'Verified payment account'
                      : subCtrl.text.trim(),
                );
                Navigator.pop(ctx);
                FlowinToast.show(
                  context,
                  title: 'Payment Method Added',
                  message: labelCtrl.text.trim(),
                  type: FlowinToastType.success,
                );
              },
            ),
          ],
        ),
      ),
    ).whenComplete(() {
      labelCtrl.dispose();
      subCtrl.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = FlowinScope.of(context);
    final headlineSummary = appState.cartItems.isNotEmpty
        ? '${appState.cartItemCount}x Gallon Items (${appState.cartItems.first.name})'
        : 'Express Gallon Order';

    return Scaffold(
      backgroundColor: FlowinColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const FlowinHeader(
              title: 'Checkout',
              rightIcon: Icon(Icons.lock_outline_rounded),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StaggeredReveal(
                      index: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Destination',
                            style: FlowinTypography.titleLarge,
                          ),
                          const SizedBox(height: 10),
                          AddressCard(
                            title: appState.deliveryTitle,
                            address: appState.deliveryAddress,
                            onEditPressed: () =>
                                _openEditAddress(context, appState),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    StaggeredReveal(
                      index: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Payment Method',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: FlowinTypography.titleLarge,
                                ),
                              ),
                              const SizedBox(width: 8),
                              TextButton.icon(
                                onPressed: () =>
                                    _openAddPaymentMethod(context, appState),
                                icon: const Icon(Icons.add_rounded, size: 17),
                                label: const Text('Add New'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          for (final method in appState.paymentMethods)
                            PaymentMethodCard(
                              title: method.label,
                              subtitle: method.isWallet
                                  ? 'Balance: ${FlowinFormat.currency(appState.walletBalance)}'
                                  : method.subtitle,
                              icon: method.icon,
                              accentColor: method.accentColor,
                              selected: appState.selectedPaymentId == method.id,
                              onTap: () =>
                                  appState.selectPaymentMethod(method.id),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    StaggeredReveal(
                      index: 2,
                      child: OrderSummaryCard(
                        itemName: headlineSummary,
                        itemPrice: appState.subtotal,
                        deliveryFee: appState.deliveryFee,
                        serviceTax: appState.tax,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: FlowinButton(
                label: 'Confirm & Pay • ${FlowinFormat.currency(appState.total)}',
                trailingIcon: Icons.check_circle_outline_rounded,
                onPressed: () {
                  appState.placeOrderFromCart();
                  Navigator.pushReplacement(
                    context,
                    FlowinPageRoute.fadeScale(
                      const PaymentConfirmationScreen(),
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
