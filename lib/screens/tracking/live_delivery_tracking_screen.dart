import 'package:flutter/material.dart';

import '../../core/animations/app_haptics.dart';
import '../../core/animations/flowin_page_routes.dart';
import '../../core/animations/radar_pulse_painter.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_motion.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../shared/widgets/flowin_button.dart';
import '../../shared/widgets/flowin_toast.dart';
import '../../state/flowin_app_state.dart';
import '../../widgets/flowin_header.dart';
import '../main_navigation_screen.dart';
import '../review/rating_review_screen.dart';

class LiveDeliveryTrackingScreen extends StatefulWidget {
  const LiveDeliveryTrackingScreen({super.key});

  @override
  State<LiveDeliveryTrackingScreen> createState() =>
      _LiveDeliveryTrackingScreenState();
}

class _LiveDeliveryTrackingScreenState extends State<LiveDeliveryTrackingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _routeController;
  int _activeStep = 2; // 0: Confirmed, 1: Dispatched, 2: En Route, 3: Arrived

  static const List<({String title, String subtitle, String time})> _steps = [
    (
      title: 'Order Verified',
      subtitle: 'Sanitized 19L gallons loaded at Flowin Central Depot',
      time: '12:12 PM',
    ),
    (
      title: 'Courier Dispatched',
      subtitle: 'Alex Rivera departed depot via South Jakarta corridor',
      time: '12:20 PM',
    ),
    (
      title: 'Out for Delivery',
      subtitle: 'About 600m from Evergreen Residence gate',
      time: '12:38 PM',
    ),
    (
      title: 'Delivered at Door',
      subtitle: 'Confirm gallon handover & empty bottle swap',
      time: '12:45 PM',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _routeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
      value: 0.68,
    )..forward();
  }

  @override
  void dispose() {
    _routeController.dispose();
    super.dispose();
  }

  void _advanceDeliveryOrRate(FlowinAppState appState) {
    AppHaptics.confirm();
    if (_activeStep < 3) {
      setState(() {
        _activeStep = 3;
        _routeController.animateTo(1.0, duration: FlowinDurations.slow);
      });
      FlowinToast.show(
        context,
        title: 'Courier Arrived!',
        message: 'Alex Rivera is at your doorstep with your gallons.',
        type: FlowinToastType.success,
      );
      return;
    }
    appState.completeLatestActiveOrder();
    Navigator.pushReplacement(
      context,
      FlowinPageRoute.fadeScale(const RatingReviewScreen()),
    );
  }

  void _backToOrders(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      FlowinPageRoute.fadeScale(
        const MainNavigationScreen(initialIndex: 1),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = FlowinScope.of(context);
    final reduced = FlowinMotion.isReduced(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _backToOrders(context);
        }
      },
      child: Scaffold(
        backgroundColor: FlowinColors.background,
      body: Column(
        children: [
          // Top Map & Live Route Canvas
          Expanded(
            flex: 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Base styled map raster + mineral ocean atmosphere tint
                Image.asset(
                  'assets/images/tracking_map.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    decoration: const BoxDecoration(
                      gradient: FlowinColors.mistSurfaceGradient,
                    ),
                  ),
                ),
                // Soft mist gradient masking map edge labels cleanly
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        FlowinColors.background.withValues(alpha: 0.88),
                        FlowinColors.background.withValues(alpha: 0.14),
                        FlowinColors.background,
                      ],
                      stops: const [0.0, 0.42, 1.0],
                    ),
                  ),
                ),

                // Vector Route Polyline & Animated Courier Beacon
                AnimatedBuilder(
                  animation: _routeController,
                  builder: (context, _) {
                    final progress = reduced ? 1.0 : _routeController.value;
                    return CustomPaint(
                      painter: _DeliveryRoutePainter(progress: progress),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final p = _DeliveryRoutePainter.pointAt(
                            Size(constraints.maxWidth, constraints.maxHeight),
                            progress,
                          );
                          final dest = _DeliveryRoutePainter.pointAt(
                            Size(constraints.maxWidth, constraints.maxHeight),
                            1.0,
                          );
                          return Stack(
                            children: [
                              // Home Destination Pin
                              Positioned(
                                left: dest.dx - 18,
                                top: dest.dy - 18,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: FlowinColors.surface,
                                    shape: BoxShape.circle,
                                    boxShadow: FlowinShadows.floatingNav,
                                    border: Border.all(
                                      color: FlowinColors.success,
                                      width: 2.5,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.home_rounded,
                                    size: 18,
                                    color: FlowinColors.success,
                                  ),
                                ),
                              ),

                              // Live Courier Radar Pulse Beacon
                              Positioned(
                                left: p.dx - 32,
                                top: p.dy - 32,
                                child: RadarPulseBeacon(
                                  size: 64,
                                  color: FlowinColors.primary,
                                  child: Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      gradient: FlowinColors.oceanGradient,
                                      shape: BoxShape.circle,
                                      boxShadow: FlowinShadows.primaryGlow,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2.5,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.local_shipping_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),

                // Top Header + Live ETA Pill
                SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      FlowinHeader(
                        title: 'Live Tracking',
                        showBackButton: true,
                        showNotification: false,
                        onLeftIconPressed: () => _backToOrders(context),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: FlowinColors.surface,
                          borderRadius: FlowinRadii.fullPill,
                          boxShadow: FlowinShadows.floatingNav,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _activeStep >= 3
                                    ? FlowinColors.success
                                    : FlowinColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                _activeStep >= 3
                                    ? 'Arrived at ${appState.deliveryTitle}'
                                    : 'ETA 12:45 PM • 6 mins away',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: FlowinTypography.caption.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: FlowinColors.ink,
                                ),
                              ),
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

          // Elevated Delivery Drawer
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: FlowinColors.surface,
                borderRadius: FlowinRadii.sheet,
                boxShadow: FlowinShadows.floatingNav,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: FlowinColors.border,
                      borderRadius: FlowinRadii.fullPill,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Courier Card
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: FlowinColors.surfaceSubtle,
                              borderRadius: FlowinRadii.card,
                              border: Border.all(color: FlowinColors.border),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: FlowinColors.oceanGradient,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'AR',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Alex Rivera',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: FlowinTypography.titleMedium,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star_rounded,
                                            size: 15,
                                            color: FlowinColors.amber,
                                          ),
                                          const SizedBox(width: 3),
                                          Expanded(
                                            child: Text(
                                              '4.9 • Flowin Electric Van',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: FlowinTypography.caption,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                _CourierIconBtn(
                                  icon: Icons.chat_bubble_outline_rounded,
                                  onTap: () {
                                    FlowinToast.show(
                                      context,
                                      title: 'Message Sent to Alex',
                                      message:
                                          '"Please ring the front bell when arriving!"',
                                      type: FlowinToastType.info,
                                    );
                                  },
                                ),
                                const SizedBox(width: 8),
                                _CourierIconBtn(
                                  icon: Icons.phone_outlined,
                                  isPrimary: true,
                                  onTap: () {
                                    FlowinToast.show(
                                      context,
                                      title: 'Connecting Masked Call...',
                                      message:
                                          'Calling Alex Rivera (+62 812-****-9910)',
                                      type: FlowinToastType.success,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),

                          Text(
                            'Delivery Milestones',
                            style: FlowinTypography.titleLarge,
                          ),
                          const SizedBox(height: 12),

                          ...List.generate(_steps.length, (i) {
                            final step = _steps[i];
                            final completed = i <= _activeStep;
                            final isCurrent = i == _activeStep;
                            return _MilestoneRow(
                              title: step.title,
                              subtitle: step.subtitle,
                              time: step.time,
                              completed: completed,
                              isCurrent: isCurrent,
                              isLast: i == _steps.length - 1,
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      8,
                      20,
                      MediaQuery.paddingOf(context).bottom > 0
                          ? MediaQuery.paddingOf(context).bottom + 8
                          : 16,
                    ),
                    child: FlowinButton(
                      label: _activeStep < 3
                          ? 'Mark Gallon Received'
                          : 'Complete & Rate Delivery',
                      trailingIcon: _activeStep < 3
                          ? Icons.check_rounded
                          : Icons.star_rounded,
                      onPressed: () => _advanceDeliveryOrRate(appState),
                    ),
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

class _DeliveryRoutePainter extends CustomPainter {
  _DeliveryRoutePainter({required this.progress});

  final double progress;

  static Offset pointAt(Size size, double t) {
    final p0 = Offset(size.width * 0.16, size.height * 0.42);
    final p1 = Offset(size.width * 0.48, size.height * 0.28);
    final p2 = Offset(size.width * 0.56, size.height * 0.72);
    final p3 = Offset(size.width * 0.84, size.height * 0.62);
    final u = 1 - t;
    return Offset(
      u * u * u * p0.dx +
          3 * u * u * t * p1.dx +
          3 * u * t * t * p2.dx +
          t * t * t * p3.dx,
      u * u * u * p0.dy +
          3 * u * u * t * p1.dy +
          3 * u * t * t * p2.dy +
          t * t * t * p3.dy,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final fullPath = Path();
    const steps = 40;
    for (int i = 0; i <= steps; i++) {
      final pt = pointAt(size, i / steps);
      if (i == 0) {
        fullPath.moveTo(pt.dx, pt.dy);
      } else {
        fullPath.lineTo(pt.dx, pt.dy);
      }
    }
    canvas.drawPath(
      fullPath,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );

    final activePath = Path();
    final activeSteps = (steps * progress).round().clamp(1, steps);
    for (int i = 0; i <= activeSteps; i++) {
      final pt = pointAt(size, i / steps);
      if (i == 0) {
        activePath.moveTo(pt.dx, pt.dy);
      } else {
        activePath.lineTo(pt.dx, pt.dy);
      }
    }
    canvas.drawPath(
      activePath,
      Paint()
        ..color = FlowinColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _DeliveryRoutePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _CourierIconBtn extends StatelessWidget {
  const _CourierIconBtn({
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPrimary ? FlowinColors.primary : FlowinColors.cyanMist,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          AppHaptics.light();
          onTap();
        },
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            icon,
            size: 19,
            color: isPrimary ? Colors.white : FlowinColors.primary,
          ),
        ),
      ),
    );
  }
}

class _MilestoneRow extends StatelessWidget {
  const _MilestoneRow({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.completed,
    required this.isCurrent,
    required this.isLast,
  });

  final String title;
  final String subtitle;
  final String time;
  final bool completed;
  final bool isCurrent;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              AnimatedContainer(
                duration: FlowinMotion.resolve(context, FlowinDurations.medium),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: completed
                      ? (isCurrent ? FlowinColors.primary : FlowinColors.success)
                      : FlowinColors.surfaceSubtle,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: completed
                        ? Colors.transparent
                        : FlowinColors.border,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  completed ? Icons.check_rounded : Icons.circle,
                  size: completed ? 13 : 6,
                  color: completed ? Colors.white : FlowinColors.inkMuted,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: completed
                        ? FlowinColors.primary.withValues(alpha: 0.35)
                        : FlowinColors.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: FlowinTypography.titleMedium.copyWith(
                            fontSize: 14,
                            color: completed
                                ? FlowinColors.ink
                                : FlowinColors.inkSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(subtitle, style: FlowinTypography.caption),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    time,
                    style: FlowinTypography.caption.copyWith(
                      fontSize: 11.5,
                      color: isCurrent
                          ? FlowinColors.primary
                          : FlowinColors.inkMuted,
                      fontWeight:
                          isCurrent ? FontWeight.w700 : FontWeight.w500,
                    ),
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
