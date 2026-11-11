import 'package:flutter/material.dart';

import '../../core/animations/flowin_page_routes.dart';
import '../../core/animations/motion_state_scenes.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../shared/widgets/flowin_button.dart';
import '../../state/flowin_app_state.dart';
import '../../widgets/flowin_header.dart';
import '../main_navigation_screen.dart';

class OrderCancelledScreen extends StatelessWidget {
  const OrderCancelledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = FlowinScope.of(context);

    return Scaffold(
      backgroundColor: FlowinColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const FlowinHeader(
              title: 'Order Cancelled',
              leftIcon: SizedBox(width: 42),
              rightIcon: SizedBox(width: 42),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const FlowinSuccessOrb(
                      state: MotionSceneState.cancelled,
                      accentColor: FlowinColors.danger,
                      icon: Icons.close_rounded,
                      size: 126,
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Delivery Cancelled',
                      style: FlowinTypography.headlineLarge.copyWith(
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Order ${appState.lastOrderNumber} has been cancelled cleanly. No courier will be dispatched.',
                      textAlign: TextAlign.center,
                      style: FlowinTypography.bodyMedium.copyWith(
                        fontSize: 14.5,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: FlowinColors.surface,
                        borderRadius: FlowinRadii.card,
                        boxShadow: FlowinShadows.cardSoft,
                        border: Border.all(color: FlowinColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: FlowinColors.cyanMist,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.account_balance_wallet_outlined,
                              color: FlowinColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Automatic Refund Scheduled',
                                  style: FlowinTypography.titleMedium.copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Returned to ${appState.selectedPaymentMethod.label}',
                                  style: FlowinTypography.caption,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    FlowinButton(
                      label: 'Back to Home',
                      icon: Icons.home_rounded,
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          FlowinPageRoute.fadeScale(
                            const MainNavigationScreen(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
