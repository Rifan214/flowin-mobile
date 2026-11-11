import 'package:flutter/material.dart';

import '../../core/animations/flowin_page_routes.dart';
import '../../core/animations/liquid_wave_painter.dart';
import '../../core/animations/motion_state_scenes.dart';
import '../../core/animations/staggered_reveal.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../shared/widgets/flowin_button.dart';
import 'login_screen.dart';

class RegisterSuccessScreen extends StatelessWidget {
  const RegisterSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlowinColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: LiquidWaveBackdrop(
              fillLevel: 0.22,
              waveAmplitude: 14,
              frontColor: FlowinColors.aqua.withValues(alpha: 0.14),
              backColor: FlowinColors.primary.withValues(alpha: 0.10),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const FlowinSuccessOrb(
                    state: MotionSceneState.success,
                    accentColor: FlowinColors.success,
                    icon: Icons.check_rounded,
                    size: 136,
                  ),
                  const SizedBox(height: 24),
                  StaggeredReveal(
                    index: 0,
                    child: Text(
                      'Account Created!',
                      textAlign: TextAlign.center,
                      style: FlowinTypography.headlineLarge.copyWith(
                        fontSize: 28,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  StaggeredReveal(
                    index: 1,
                    child: Text(
                      'Your Flowin hydration profile is ready. Sign in now to schedule fresh gallon deliveries.',
                      textAlign: TextAlign.center,
                      style: FlowinTypography.bodyMedium.copyWith(fontSize: 14.5),
                    ),
                  ),
                  const SizedBox(height: 26),
                  StaggeredReveal(
                    index: 2,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: FlowinColors.surface,
                        borderRadius: FlowinRadii.card,
                        boxShadow: FlowinShadows.cardSoft,
                        border: Border.all(color: FlowinColors.border),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            child: _BenefitItem(
                              icon: Icons.bolt_rounded,
                              label: '45m Express',
                            ),
                          ),
                          Expanded(
                            child: _BenefitItem(
                              icon: Icons.verified_rounded,
                              label: 'Lab Certified',
                            ),
                          ),
                          Expanded(
                            child: _BenefitItem(
                              icon: Icons.autorenew_rounded,
                              label: 'Easy Refill',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  FlowinButton(
                    label: 'Sign In to Flowin',
                    trailingIcon: Icons.arrow_forward_rounded,
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        FlowinPageRoute.fadeScale(const LoginScreen()),
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

class _BenefitItem extends StatelessWidget {
  const _BenefitItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: FlowinColors.cyanMist,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: FlowinColors.primary),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: FlowinTypography.caption.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
