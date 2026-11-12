import 'package:flutter/material.dart';

import '../../core/animations/flowin_page_routes.dart';
import '../../core/animations/liquid_wave_painter.dart';
import '../../core/animations/motion_state_scenes.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../shared/widgets/flowin_button.dart';
import '../main_navigation_screen.dart';

class ReviewSuccessScreen extends StatelessWidget {
  const ReviewSuccessScreen({super.key});

  void _backToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      FlowinPageRoute.fadeScale(const MainNavigationScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _backToHome(context);
        }
      },
      child: Scaffold(
        backgroundColor: FlowinColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: LiquidWaveBackdrop(
              fillLevel: 0.22,
              waveAmplitude: 13,
              frontColor: FlowinColors.aqua.withValues(alpha: 0.14),
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
                    accentColor: FlowinColors.primary,
                    icon: Icons.favorite_rounded,
                    size: 130,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Thank You!',
                    style: FlowinTypography.headlineLarge.copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your feedback helps Flowin keep every gallon delivery punctual, sanitary, and crystal clear.',
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
                            color: FlowinColors.amberSoft,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.stars_rounded,
                            color: FlowinColors.amber,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '+25 Flowin Hydration Points added for reviewing!',
                            style: FlowinTypography.titleMedium.copyWith(
                              fontSize: 13.5,
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
                    onPressed: () => _backToHome(context),
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
