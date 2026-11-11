import 'package:flutter/material.dart';

import '../design_system/flowin_colors.dart';
import '../design_system/flowin_motion.dart';

/// Concentric pulsing radar halo inspired by Flutter Vignettes `product_detail_zoom`
/// `PulsingButton`, used for live delivery courier location beacons & active badges.
class RadarPulseBeacon extends StatefulWidget {
  const RadarPulseBeacon({
    super.key,
    this.color = FlowinColors.primary,
    this.size = 64,
    this.active = true,
    required this.child,
  });

  final Color color;
  final double size;
  final bool active;
  final Widget child;

  @override
  State<RadarPulseBeacon> createState() => _RadarPulseBeaconState();
}

class _RadarPulseBeaconState extends State<RadarPulseBeacon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    if (widget.active) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant RadarPulseBeacon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active != oldWidget.active) {
      if (widget.active) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = FlowinMotion.isReduced(context) || !widget.active;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!reduced)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => CustomPaint(
                size: Size.square(widget.size),
                painter: _RadarRingPainter(
                  progress: _controller.value,
                  color: widget.color,
                ),
              ),
            ),
          widget.child,
        ],
      ),
    );
  }
}

class _RadarRingPainter extends CustomPainter {
  _RadarRingPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.width * 0.5;
    for (int i = 0; i < 2; i++) {
      final p = (progress + i * 0.5) % 1.0;
      final radius = maxRadius * (0.35 + 0.65 * p);
      final opacity = (1.0 - p) * 0.36;
      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarRingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

