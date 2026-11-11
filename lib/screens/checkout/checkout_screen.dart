import 'package:flutter/material.dart';

import '../../core/animations/flowin_page_routes.dart';
import '../../core/animations/staggered_reveal.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../shared/widgets/flowin_button.dart';
import '../../state/flowin_app_state.dart';
import '../../widgets/add_payment_method_sheet.dart';
import '../../widgets/address_card.dart';
import '../../widgets/delivery_address_editor_sheet.dart';
import '../../widgets/flowin_header.dart';
import '../../widgets/order_summary_card.dart';
import '../../widgets/payment_method_card.dart';
import '../payment/payment_confirmation_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  void _openEditAddress(BuildContext context) {
    DeliveryAddressEditorSheet.show(context);
  }

  void _openAddPaymentMethod(BuildContext context) {
    AddPaymentMethodSheet.show(context, submitLabel: 'Save & Select');
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
                            onEditPressed: () => _openEditAddress(context),
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
                                    _openAddPaymentMethod(context),
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
