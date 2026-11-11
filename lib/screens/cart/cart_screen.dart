import 'package:flutter/material.dart';

import '../../core/animations/flowin_page_routes.dart';
import '../../core/animations/motion_state_scenes.dart';
import '../../core/animations/staggered_reveal.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../shared/widgets/animated_price_text.dart';
import '../../shared/widgets/flowin_button.dart';
import '../../shared/widgets/flowin_toast.dart';
import '../../state/flowin_app_state.dart';
import '../../widgets/cart_item_card.dart';
import '../../widgets/delivery_address_editor_sheet.dart';
import '../../widgets/flowin_header.dart';
import '../checkout/checkout_screen.dart';
import '../main_navigation_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _openEditAddressSheet(BuildContext context) {
    DeliveryAddressEditorSheet.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final appState = FlowinScope.of(context);
    final items = appState.cartItems;

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          FlowinHeader(
            title: 'My Cart',
            actions: [
              if (items.isNotEmpty)
                TextButton(
                  onPressed: () {
                    appState.clearCart();
                    FlowinToast.show(
                      context,
                      title: 'Cart Cleared',
                      message: 'Your hydration basket is now empty.',
                      type: FlowinToastType.info,
                    );
                  },
                  child: Text(
                    'Clear',
                    style: FlowinTypography.caption.copyWith(
                      color: FlowinColors.danger,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              else
                const SizedBox(width: 42),
            ],
          ),

          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        28,
                        0,
                        28,
                        FlowinSpacing.navBarClearance,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const HydrationVesselGraphic(size: 124),
                          const SizedBox(height: 18),
                          Text(
                            'Your Basket is Empty',
                            style: FlowinTypography.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add pure mountain gallons or alkaline refills to schedule an express drop.',
                            textAlign: TextAlign.center,
                            style: FlowinTypography.bodyMedium,
                          ),
                          const SizedBox(height: 22),
                          FlowinButton(
                            label: 'Explore Water Catalog',
                            icon: Icons.water_drop_rounded,
                            expand: false,
                            onPressed: () =>
                                MainNavigationScreen.goToTab(context, 0),
                          ),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      4,
                      20,
                      FlowinSpacing.navBarClearance,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Editable Delivery Location Banner
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: FlowinColors.surface,
                            borderRadius: FlowinRadii.card,
                            boxShadow: FlowinShadows.cardSoft,
                            border: Border.all(
                              color: FlowinColors.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: FlowinColors.cyanMist,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.location_on_rounded,
                                  color: FlowinColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      appState.deliveryTitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: FlowinTypography.titleMedium
                                          .copyWith(fontSize: 13.5),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      appState.deliveryAddress,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: FlowinTypography.caption,
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    _openEditAddressSheet(context),
                                child: Text(
                                  'Edit',
                                  style: FlowinTypography.titleMedium.copyWith(
                                    color: FlowinColors.primary,
                                    fontSize: 13.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Swipeable Cart Items
                        ...List.generate(items.length, (index) {
                          final item = items[index];
                          return StaggeredReveal(
                            index: index,
                            child: Dismissible(
                              key: ValueKey('cart_${item.name}_$index'),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.only(right: 22),
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                  color: FlowinColors.dangerSoft,
                                  borderRadius: FlowinRadii.card,
                                ),
                                child: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: FlowinColors.danger,
                                ),
                              ),
                              onDismissed: (_) {
                                final removed =
                                    appState.removeCartItemAt(index);
                                if (removed != null) {
                                  FlowinToast.show(
                                    context,
                                    title: 'Removed ${removed.name}',
                                    message: 'Updated cart subtotal.',
                                    type: FlowinToastType.info,
                                    actionLabel: 'Undo',
                                    onAction: () => appState.restoreCartItem(
                                      index,
                                      removed,
                                    ),
                                  );
                                }
                              },
                              child: CartItemCard(
                                item: item,
                                onIncrement: () =>
                                    appState.incrementCartQuantity(index),
                                onDecrement: () =>
                                    appState.decrementCartQuantity(index),
                                onRemove: () {
                                  final removed =
                                      appState.removeCartItemAt(index);
                                  if (removed != null) {
                                    FlowinToast.show(
                                      context,
                                      title: 'Removed ${removed.name}',
                                      message: 'Tap Undo to put it back.',
                                      type: FlowinToastType.info,
                                      actionLabel: 'Undo',
                                      onAction: () => appState.restoreCartItem(
                                        index,
                                        removed,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 6),

                        // Live Order Summary Card
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: FlowinColors.surface,
                            borderRadius: FlowinRadii.card,
                            boxShadow: FlowinShadows.cardSoft,
                            border: Border.all(
                              color: FlowinColors.border.withValues(alpha: 0.7),
                            ),
                          ),
                          child: Column(
                            children: [
                              _SummaryRow(
                                label:
                                    'Subtotal (${appState.cartItemCount} items)',
                                amount: appState.subtotal,
                              ),
                              const SizedBox(height: 8),
                              _SummaryRow(
                                label: 'Express Delivery Fee',
                                amount: appState.deliveryFee,
                              ),
                              const SizedBox(height: 8),
                              _SummaryRow(
                                label: 'Service Tax (5%)',
                                amount: appState.tax,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Divider(),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total',
                                    style: FlowinTypography.titleLarge,
                                  ),
                                  AnimatedPriceText(
                                    amount: appState.total,
                                    style: FlowinTypography.priceLarge,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              FlowinButton(
                                label: 'Proceed to Checkout',
                                trailingIcon: Icons.arrow_forward_rounded,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    FlowinPageRoute.sharedAxis(
                                      const CheckoutScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.amount});

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
          style: FlowinTypography.titleMedium.copyWith(fontSize: 14),
        ),
      ],
    );
  }
}
