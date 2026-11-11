import 'package:flutter/material.dart';

import '../../core/animations/flowin_page_routes.dart';
import '../../core/animations/liquid_wave_painter.dart';
import '../../core/animations/motion_state_scenes.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../models/subscription_plan.dart';
import '../../shared/widgets/flowin_button.dart';
import '../main_navigation_screen.dart';

class SubscriptionSuccessScreen extends StatelessWidget {
  const SubscriptionSuccessScreen({super.key, this.plan});

  final SubscriptionPlan? plan;

  @override
  Widget build(BuildContext context) {
    final title = plan?.title ?? 'Flowin Hydration Plan';

    return Scaffold(
      backgroundColor: FlowinColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: LiquidWaveBackdrop(
              fillLevel: 0.22,
              waveAmplitude: 13,
              frontColor: FlowinColors.aqua.withValues(alpha: 0.16),
              backColor: FlowinColors.primary.withValues(alpha: 0.08),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const FlowinSuccessOrb(
                    state: MotionSceneState.success,
                    accentColor: FlowinColors.success,
                    icon: Icons.autorenew_rounded,
                    size: 130,
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Subscription Activated!',
                    textAlign: TextAlign.center,
                    style: FlowinTypography.headlineLarge.copyWith(fontSize: 26),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your $title schedule is live. Enjoy hassle-free water gallon refills delivered right on time.',
                    textAlign: TextAlign.center,
                    style: FlowinTypography.bodyMedium.copyWith(fontSize: 14.5),
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
                            Icons.event_available_rounded,
                            color: FlowinColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Manage pause, brand swaps, or delivery frequency anytime in your Profile tab.',
                            style: FlowinTypography.caption.copyWith(
                              color: FlowinColors.ink,
                              height: 1.4,
                            ),
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
    );
  }
}
