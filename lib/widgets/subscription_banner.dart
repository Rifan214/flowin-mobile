import 'package:flutter/material.dart';

import '../core/animations/app_haptics.dart';
import '../core/animations/flowin_page_routes.dart';
import '../core/animations/liquid_wave_painter.dart';
import '../core/design_system/flowin_colors.dart';
import '../core/design_system/flowin_spacing.dart';
import '../core/design_system/flowin_typography.dart';
import '../screens/subscription/subscription_screen.dart';
import '../state/flowin_app_state.dart';

/// Highlight banner with live dual-layer liquid waves routing into the canonical
/// Flowin Subscription experience.
class SubscriptionBanner extends StatelessWidget {
  const SubscriptionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final appState =
        context.dependOnInheritedWidgetOfExactType<FlowinScope>()?.notifier;
    final activePlan = appState?.activeSubscription;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: FlowinRadii.card,
        onTap: () {
          AppHaptics.light();
          Navigator.push(
            context,
            FlowinPageRoute.sharedAxis(const SubscriptionScreen()),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: FlowinColors.oceanGradient,
            borderRadius: FlowinRadii.card,
            boxShadow: FlowinShadows.primaryGlow,
          ),
          clipBehavior: Clip.antiAlias,
          child: LiquidWaveBackdrop(
            fillLevel: 0.45,
            waveAmplitude: 10,
            frontColor: FlowinColors.aquaBright.withValues(alpha: 0.22),
            backColor: FlowinColors.deepOcean.withValues(alpha: 0.28),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: FlowinRadii.fullPill,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.autorenew_rounded,
                                size: 13,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                activePlan != null
                                    ? 'ACTIVE: ${activePlan.title.toUpperCase()}'
                                    : 'SMART REFILL PASS',
                                style: FlowinTypography.overline.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          activePlan != null
                              ? 'Manage Your Hydration Schedule'
                              : 'Save 20% with Auto-Refill',
                          style: FlowinTypography.titleLarge.copyWith(
                            color: Colors.white,
                            fontSize: 17.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          activePlan != null
                              ? '${activePlan.description} • Priority morning slot'
                              : 'Weekly & monthly gallon plans with free priority courier.',
                          style: FlowinTypography.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.86),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: FlowinColors.primary,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
