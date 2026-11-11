import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/animations/app_haptics.dart';
import '../../core/animations/flowin_page_routes.dart';
import '../../core/animations/liquid_wave_painter.dart';
import '../../core/animations/staggered_reveal.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_motion.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../shared/widgets/flowin_button.dart';
import '../auth/login_screen.dart';

class _OnboardingSlideData {
  final String badge;
  final String title;
  final String subtitle;
  final String highlightStat;
  final String highlightLabel;
  final String image;
  final IconData badgeIcon;

  const _OnboardingSlideData({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.highlightStat,
    required this.highlightLabel,
    required this.image,
    required this.badgeIcon,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const List<_OnboardingSlideData> _slides = [
    _OnboardingSlideData(
      badge: 'ECO-FRIENDLY LOGISTICS',
      title: 'Pure Hydration,\nDelivered Effortlessly',
      subtitle:
          'Freshly sealed mountain & alkaline water gallons brought straight from depot to kitchen in under 45 minutes.',
      highlightStat: 'pH 7.8+',
      highlightLabel: 'Lab-Certified Purity',
      image: 'assets/images/onboarding_bottle.jpg',
      badgeIcon: Icons.verified_rounded,
    ),
    _OnboardingSlideData(
      badge: 'SMART AUTO-REFILL',
      title: 'Never Run Dry\non Busy Weeks',
      subtitle:
          'Pick weekly or bi-weekly plans, swap brands anytime, and save up to 20% with zero heavy lifting.',
      highlightStat: '45 min',
      highlightLabel: 'Avg. Doorstep ETA',
      image: 'assets/images/gallon_aqua.jpg',
      badgeIcon: Icons.bolt_rounded,
    ),
    _OnboardingSlideData(
      badge: 'CLOSED-LOOP BOTTLES',
      title: 'Track Every Drop\nin Real Time',
      subtitle:
          'Follow your driver live on the map and return sanitized BPA-free gallons to eliminate single-use plastic.',
      highlightStat: '100%',
      highlightLabel: 'Sanitized Refill Loop',
      image: 'assets/images/login_water.png',
      badgeIcon: Icons.eco_rounded,
    ),
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      FlowinPageRoute.fadeScale(const LoginScreen()),
    );
  }

  void _handleNextOrGetStarted() {
    if (_currentPage < _slides.length - 1) {
      AppHaptics.selection();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: FlowinCurves.emphasized,
      );
    } else {
      _goToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final slide = _slides[_currentPage];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: FlowinColors.deepOcean,
      body: Stack(
        children: [
          // Deep ocean backdrop + live harmonic liquid wave at mid-height
          Container(
            decoration: const BoxDecoration(
              gradient: FlowinColors.deepSplashGradient,
            ),
          ),
          Positioned.fill(
            child: LiquidWaveBackdrop(
              fillLevel: 0.42 + (_currentPage * 0.05),
              waveAmplitude: 16,
              frontColor: FlowinColors.aqua.withValues(alpha: 0.22),
              backColor: FlowinColors.primaryBright.withValues(alpha: 0.25),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top brand & skip action bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 16, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(11),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                              ),
                            ),
                            child: const Icon(
                              Icons.water_drop_rounded,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'flowin',
                            style: FlowinTypography.headlineMedium.copyWith(
                              color: Colors.white,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _goToLogin,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white.withValues(alpha: 0.88),
                        ),
                        child: Text(
                          'Skip',
                          style: FlowinTypography.titleMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Interactive visual stage PageView
                Expanded(
                  flex: screenHeight < 700 ? 4 : 5,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _slides.length,
                    onPageChanged: (index) {
                      AppHaptics.selection();
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      final item = _slides[index];
                      return _OnboardingVisualStage(
                        slide: item,
                        isActive: index == _currentPage,
                      );
                    },
                  ),
                ),

                // Elevated bottom storytelling card
                Container(
                  margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
                  decoration: BoxDecoration(
                    color: FlowinColors.surface,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: FlowinShadows.floatingNav,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Overline pill + animated page indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: FlowinColors.cyanMist,
                                borderRadius: FlowinRadii.fullPill,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    slide.badgeIcon,
                                    size: 13,
                                    color: FlowinColors.primary,
                                  ),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      slide.badge,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: FlowinTypography.overline.copyWith(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _ExpandingPageIndicator(
                            count: _slides.length,
                            currentIndex: _currentPage,
                            onTapIndex: (i) {
                              _pageController.animateToPage(
                                i,
                                duration: FlowinDurations.medium,
                                curve: FlowinCurves.emphasized,
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      AnimatedSwitcher(
                        duration: FlowinMotion.resolve(
                          context,
                          FlowinDurations.medium,
                        ),
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.08),
                              end: Offset.zero,
                            ).animate(anim),
                            child: child,
                          ),
                        ),
                        child: Column(
                          key: ValueKey(_currentPage),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              slide.title,
                              style: FlowinTypography.headlineLarge.copyWith(
                                height: 1.18,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              slide.subtitle,
                              style: FlowinTypography.bodyMedium.copyWith(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          if (_currentPage < _slides.length - 1) ...[
                            Expanded(
                              child: FlowinButton(
                                label: 'Get Started',
                                variant: FlowinButtonVariant.tinted,
                                horizontalPadding: 14,
                                onPressed: _goToLogin,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FlowinButton(
                                label: 'Continue',
                                horizontalPadding: 14,
                                trailingIcon: Icons.arrow_forward_rounded,
                                onPressed: _handleNextOrGetStarted,
                              ),
                            ),
                          ] else
                            Expanded(
                              child: FlowinButton(
                                label: 'Get Started',
                                trailingIcon: Icons.arrow_forward_rounded,
                                onPressed: _goToLogin,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
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

class _OnboardingVisualStage extends StatelessWidget {
  const _OnboardingVisualStage({
    required this.slide,
    required this.isActive,
  });

  final _OnboardingSlideData slide;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Center(
        child: StaggeredReveal(
          animate: isActive,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Soft glowing aura ring
              Container(
                width: 246,
                height: 246,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      FlowinColors.aquaBright.withValues(alpha: 0.32),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // Arch-framed photography matching Wonderous layered gallery composition
              Container(
                width: 214,
                height: 246,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(110),
                    bottom: Radius.circular(28),
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(100),
                    bottom: Radius.circular(20),
                  ),
                  child: Container(
                    color: Colors.white,
                    child: Image.asset(
                      slide.image,
                      fit: slide.image.contains('gallon')
                          ? BoxFit.contain
                          : BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.water_drop_rounded,
                        size: 72,
                        color: FlowinColors.primary,
                      ),
                    ),
                  ),
                ),
              ),

              // Floating mineral stat pill
              Positioned(
                bottom: 8,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: FlowinColors.surface,
                    borderRadius: FlowinRadii.innerCard,
                    boxShadow: FlowinShadows.floatingNav,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: FlowinColors.cyanMist,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.water_drop_rounded,
                          size: 17,
                          color: FlowinColors.primary,
                        ),
                      ),
                      const SizedBox(width: 9),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            slide.highlightStat,
                            style: FlowinTypography.titleMedium.copyWith(
                              color: FlowinColors.primary,
                              fontWeight: FontWeight.w800,
                              height: 1.05,
                            ),
                          ),
                          Text(
                            slide.highlightLabel,
                            style: FlowinTypography.caption.copyWith(
                              fontSize: 10.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpandingPageIndicator extends StatelessWidget {
  const _ExpandingPageIndicator({
    required this.count,
    required this.currentIndex,
    required this.onTapIndex,
  });

  final int count;
  final int currentIndex;
  final ValueChanged<int> onTapIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final active = i == currentIndex;
        return GestureDetector(
          onTap: () => onTapIndex(i),
          child: AnimatedContainer(
            duration: FlowinMotion.resolve(context, FlowinDurations.medium),
            curve: FlowinCurves.emphasized,
            margin: const EdgeInsets.only(left: 5),
            width: active ? 22 : 7,
            height: 7,
            decoration: BoxDecoration(
              color: active ? FlowinColors.primary : FlowinColors.border,
              borderRadius: FlowinRadii.fullPill,
            ),
          ),
        );
      }),
    );
  }
}
