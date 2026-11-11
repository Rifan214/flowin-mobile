import 'package:flutter/material.dart';

import '../../core/animations/flowin_page_routes.dart';
import '../../core/animations/liquid_wave_painter.dart';
import '../../core/animations/staggered_reveal.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../shared/widgets/flowin_button.dart';
import '../../state/flowin_app_state.dart';
import '../../widgets/flowin_header.dart';
import '../../widgets/subscription_card.dart';
import 'subscription_checkout_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedIndex = 1; // Default highlight Popular plan

  @override
  Widget build(BuildContext context) {
    final appState = FlowinScope.of(context);
    final plans = appState.subscriptionPlans;
    final selectedPlan = plans[_selectedIndex.clamp(0, plans.length - 1)];

    return Scaffold(
      backgroundColor: FlowinColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const FlowinHeader(
              title: 'Hydration Plans',
              rightIcon: SizedBox(width: 42),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Liquid Auto-Refill Spotlight
                    Container(
                      decoration: BoxDecoration(
                        gradient: FlowinColors.oceanGradient,
                        borderRadius: FlowinRadii.card,
                        boxShadow: FlowinShadows.primaryGlow,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: LiquidWaveBackdrop(
                        fillLevel: 0.4,
                        waveAmplitude: 11,
                        frontColor: FlowinColors.aquaBright.withValues(alpha: 0.22),
                        backColor: FlowinColors.deepOcean.withValues(alpha: 0.25),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AUTO-REFILL MEMBERSHIP',
                                style: FlowinTypography.overline.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Effortless Hydration Every Week',
                                style: FlowinTypography.headlineMedium.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Pause, reschedule, or switch gallon brands anytime with zero fees.',
                                style: FlowinTypography.caption.copyWith(
                                  color: Colors.white.withValues(alpha: 0.88),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Choose Your Schedule',
                      style: FlowinTypography.titleLarge,
                    ),
                    const SizedBox(height: 12),

                    ...List.generate(plans.length, (i) {
                      return StaggeredReveal(
                        index: i,
                        child: SubscriptionCard(
                          plan: plans[i],
                          isSelected: _selectedIndex == i,
                          onTap: () => setState(() => _selectedIndex = i),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
              child: FlowinButton(
                label:
                    'Continue with ${selectedPlan.title} • ${FlowinFormat.currency(selectedPlan.price)}',
                trailingIcon: Icons.arrow_forward_rounded,
                onPressed: () {
                  Navigator.push(
                    context,
                    FlowinPageRoute.sharedAxis(
                      SubscriptionCheckoutScreen(plan: selectedPlan),
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
