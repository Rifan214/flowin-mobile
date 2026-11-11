import 'package:flutter/material.dart';

import '../../core/animations/app_haptics.dart';
import '../../core/animations/flowin_page_routes.dart';
import '../../core/animations/motion_state_scenes.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_motion.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../shared/widgets/flowin_button.dart';
import '../../state/flowin_app_state.dart';
import '../../widgets/flowin_header.dart';
import 'order_cancelled_screen.dart';

class CancelOrderScreen extends StatefulWidget {
  const CancelOrderScreen({super.key});

  @override
  State<CancelOrderScreen> createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  static const List<String> _reasons = [
    'Need to adjust gallon quantity',
    'Selected wrong delivery address',
    'Estimated arrival took too long',
    'Ordered by mistake',
  ];

  int _selectedReason = 0;

  @override
  Widget build(BuildContext context) {
    final appState = FlowinScope.of(context);

    return Scaffold(
      backgroundColor: FlowinColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const FlowinHeader(
              title: 'Cancel Delivery',
              rightIcon: SizedBox(width: 42),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
                child: Column(
                  children: [
                    const FlowinSuccessOrb(
                      state: MotionSceneState.idle,
                      accentColor: FlowinColors.amber,
                      icon: Icons.priority_high_rounded,
                      size: 112,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Cancel Your Delivery?',
                      textAlign: TextAlign.center,
                      style: FlowinTypography.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Let us know why you need to cancel order ${appState.lastOrderNumber}. Refunds process instantly to ${appState.selectedPaymentMethod.label}.',
                      textAlign: TextAlign.center,
                      style: FlowinTypography.bodyMedium,
                    ),
                    const SizedBox(height: 22),

                    ...List.generate(_reasons.length, (i) {
                      final active = _selectedReason == i;
                      return GestureDetector(
                        onTap: () {
                          AppHaptics.selection();
                          setState(() => _selectedReason = i);
                        },
                        child: AnimatedContainer(
                          duration: FlowinMotion.resolve(
                            context,
                            FlowinDurations.fast,
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: active
                                ? FlowinColors.cyanTint
                                : FlowinColors.surface,
                            borderRadius: FlowinRadii.innerCard,
                            border: Border.all(
                              color: active
                                  ? FlowinColors.primary
                                  : FlowinColors.border,
                              width: active ? 1.5 : 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _reasons[i],
                                  style: FlowinTypography.titleMedium.copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Icon(
                                active
                                    ? Icons.radio_button_checked_rounded
                                    : Icons.radio_button_off_rounded,
                                color: active
                                    ? FlowinColors.primary
                                    : FlowinColors.inkMuted,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 20),
              child: Column(
                children: [
                  FlowinButton(
                    label: 'Keep My Order',
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 10),
                  FlowinButton(
                    label: 'Confirm Cancellation',
                    variant: FlowinButtonVariant.danger,
                    onPressed: () {
                      appState.cancelLatestActiveOrder();
                      Navigator.pushReplacement(
                        context,
                        FlowinPageRoute.fadeScale(const OrderCancelledScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
