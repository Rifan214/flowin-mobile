import 'package:flutter/material.dart';

import '../../core/animations/flowin_page_routes.dart';
import '../../core/animations/liquid_wave_painter.dart';
import '../../core/animations/motion_state_scenes.dart';
import '../../core/animations/staggered_reveal.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../shared/widgets/flowin_button.dart';
import '../../state/flowin_app_state.dart';
import '../main_navigation_screen.dart';
import '../orders/cancel_order_screen.dart';
import '../tracking/live_delivery_tracking_screen.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  const PaymentConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = FlowinScope.of(context);
    final total = appState.lastOrderTotal > 0 ? appState.lastOrderTotal : 65900;

    return Scaffold(
      backgroundColor: FlowinColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: LiquidWaveBackdrop(
              fillLevel: 0.2,
              waveAmplitude: 12,
              frontColor: FlowinColors.aqua.withValues(alpha: 0.14),
              backColor: FlowinColors.primary.withValues(alpha: 0.08),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 28),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const FlowinSuccessOrb(
                    state: MotionSceneState.success,
                    accentColor: FlowinColors.success,
                    size: 132,
                  ),
                  const SizedBox(height: 18),

                  StaggeredReveal(
                    index: 0,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: FlowinColors.successSoft,
                            borderRadius: FlowinRadii.fullPill,
                          ),
                          child: Text(
                            'PAYMENT VERIFIED',
                            style: FlowinTypography.overline.copyWith(
                              color: FlowinColors.success,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Hydration on the Way!',
                          textAlign: TextAlign.center,
                          style: FlowinTypography.headlineLarge.copyWith(
                            fontSize: 26,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Order ${appState.lastOrderNumber} has been assigned to our nearest express depot.',
                          textAlign: TextAlign.center,
                          style: FlowinTypography.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  StaggeredReveal(
                    index: 1,
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: FlowinColors.surface,
                        borderRadius: FlowinRadii.card,
                        boxShadow: FlowinShadows.cardSoft,
                        border: Border.all(color: FlowinColors.border),
                      ),
                      child: Column(
                        children: [
                          _DetailRow(
                            label: 'Total Paid',
                            value: FlowinFormat.currency(total),
                            highlight: true,
                          ),
                          const Divider(height: 22),
                          _DetailRow(
                            label: 'Payment Method',
                            value: appState.selectedPaymentMethod.label,
                          ),
                          const SizedBox(height: 10),
                          _DetailRow(
                            label: 'Estimated Arrival',
                            value: '35 - 45 mins',
                          ),
                          const SizedBox(height: 10),
                          _DetailRow(
                            label: 'Destination',
                            value: appState.deliveryTitle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  StaggeredReveal(
                    index: 2,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: FlowinColors.mistSurfaceGradient,
                        borderRadius: FlowinRadii.card,
                        border: Border.all(color: FlowinColors.cyanMist),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: const BoxDecoration(
                              color: FlowinColors.surface,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.eco_rounded,
                              color: FlowinColors.success,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Eco Impact: You avoided up to 38 single-use plastic bottles with sanitized gallon refill.',
                              style: FlowinTypography.caption.copyWith(
                                color: FlowinColors.ink,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),

                  FlowinButton(
                    label: 'Track My Delivery',
                    icon: Icons.near_me_rounded,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        FlowinPageRoute.modalSlide(
                          const LiveDeliveryTrackingScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  FlowinButton(
                    label: 'Back to Home',
                    variant: FlowinButtonVariant.tinted,
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
                  const SizedBox(height: 10),
                  FlowinButton(
                    label: 'Cancel Order',
                    variant: FlowinButtonVariant.ghost,
                    height: 44,
                    onPressed: () {
                      Navigator.push(
                        context,
                        FlowinPageRoute.sharedAxis(const CancelOrderScreen()),
                      );
                    },
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: highlight
                ? FlowinTypography.priceMedium.copyWith(fontSize: 17)
                : FlowinTypography.titleMedium.copyWith(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
