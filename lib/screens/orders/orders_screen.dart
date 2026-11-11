import 'package:flutter/material.dart';

import '../../core/animations/app_haptics.dart';
import '../../core/animations/flowin_page_routes.dart';
import '../../core/animations/motion_state_scenes.dart';
import '../../core/animations/staggered_reveal.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_motion.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../shared/widgets/flowin_button.dart';
import '../../shared/widgets/flowin_toast.dart';
import '../../state/flowin_app_state.dart';
import '../../widgets/flowin_header.dart';
import '../../widgets/order_card.dart';
import '../main_navigation_screen.dart';
import '../tracking/live_delivery_tracking_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  static const List<String> _tabs = ['All', 'In Progress', 'Completed'];

  @override
  Widget build(BuildContext context) {
    final appState = FlowinScope.of(context);
    final orders = appState.filteredOrders;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FlowinHeader(title: 'Orders'),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Track active drops or repeat past deliveries.',
                  style: FlowinTypography.bodyMedium,
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: FlowinColors.surface,
                    borderRadius: FlowinRadii.fullPill,
                    border: Border.all(color: FlowinColors.border),
                  ),
                  child: Row(
                    children: _tabs.map((tab) {
                      final selected = appState.orderFilter == tab;
                      final count = tab == 'All'
                          ? appState.orders.length
                          : appState.orders
                              .where((o) => o.status == tab)
                              .length;
                      return Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            AppHaptics.selection();
                            appState.setOrderFilter(tab);
                          },
                          child: AnimatedContainer(
                            duration: FlowinMotion.resolve(
                              context,
                              FlowinDurations.fast,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            decoration: BoxDecoration(
                              gradient:
                                  selected ? FlowinColors.oceanGradient : null,
                              borderRadius: FlowinRadii.fullPill,
                              boxShadow:
                                  selected ? FlowinShadows.primaryGlow : null,
                            ),
                            child: Text(
                              '$tab ($count)',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: FlowinTypography.caption.copyWith(
                                fontWeight: FontWeight.w700,
                                color: selected
                                    ? Colors.white
                                    : FlowinColors.inkSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: orders.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        24,
                        0,
                        24,
                        FlowinSpacing.navBarClearance,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const HydrationVesselGraphic(size: 112),
                          const SizedBox(height: 14),
                          Text(
                            'No Orders Found',
                            style: FlowinTypography.headlineMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Nothing matches "${appState.orderFilter}" right now.',
                            textAlign: TextAlign.center,
                            style: FlowinTypography.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          FlowinButton(
                            label: 'Show All Orders',
                            variant: FlowinButtonVariant.tinted,
                            expand: false,
                            height: 44,
                            onPressed: () => appState.setOrderFilter('All'),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      0,
                      20,
                      FlowinSpacing.navBarClearance,
                    ),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return StaggeredReveal(
                        index: index,
                        child: OrderCard(
                          order: order,
                          onButtonPressed: () {
                            if (order.status == 'In Progress') {
                              Navigator.push(
                                context,
                                FlowinPageRoute.modalSlide(
                                  const LiveDeliveryTrackingScreen(),
                                ),
                              );
                            } else {
                              appState.reorderToCart(order);
                              FlowinToast.show(
                                context,
                                title: 'Added to Cart',
                                message:
                                    '${order.quantity}x ${order.item} ready in your cart.',
                                type: FlowinToastType.success,
                              );
                              MainNavigationScreen.goToTab(context, 2);
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
