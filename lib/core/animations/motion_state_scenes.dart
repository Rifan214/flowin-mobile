import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../design_system/flowin_colors.dart';
import '../design_system/flowin_motion.dart';

/// Discrete Rive-style state-machine states for Flowin interactive graphics.
enum MotionSceneState { idle, loading, success, cancelled }

/// Celebration droplet burst & ripple orb (used in Payment Confirmation,
/// Register Success, Review Success, Subscription Success, and Order Cancelled).
class FlowinSuccessOrb extends StatefulWidget {
  const FlowinSuccessOrb({
    super.key,
    this.state = MotionSceneState.success,
    this.size = 128,
    this.accentColor = FlowinColors.success,
    this.icon = Icons.check_rounded,
  });

  final MotionSceneState state;
  final double size;
  final Color accentColor;
  final IconData icon;

  @override
  State<FlowinSuccessOrb> createState() => _FlowinSuccessOrbState();
}

class _FlowinSuccessOrbState extends State<FlowinSuccessOrb>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _enterController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..forward();
  }

  @override
  void didUpdateWidget(covariant FlowinSuccessOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      _enterController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _enterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = FlowinMotion.isReduced(context);
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseController, _enterController]),
        builder: (context, _) {
          final enter = reduced
              ? 1.0
              : Curves.easeOutBack.transform(_enterController.value.clamp(0.0, 1.0));
          final pulse = reduced ? 0.35 : _pulseController.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size.square(widget.size),
                painter: _OrbSplashPainter(
                  pulse: pulse,
                  enter: enter,
                  color: widget.accentColor,
                  isLoading: widget.state == MotionSceneState.loading,
                ),
              ),
              Transform.scale(
                scale: enter.clamp(0.4, 1.15),
                child: Container(
                  width: widget.size * 0.56,
                  height: widget.size * 0.56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.accentColor,
                        Color.lerp(widget.accentColor, Colors.black, 0.18)!,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.accentColor.withValues(alpha: 0.34),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: widget.state == MotionSceneState.loading
                      ? const Padding(
                          padding: EdgeInsets.all(18),
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          widget.icon,
                          color: Colors.white,
                          size: widget.size * 0.28,
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OrbSplashPainter extends CustomPainter {
  _OrbSplashPainter({
    required this.pulse,
    required this.enter,
    required this.color,
    required this.isLoading,
  });

  final double pulse;
  final double enter;
  final Color color;
  final bool isLoading;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxR = size.width * 0.48;

    // Two soft expanding concentric ripples
    for (int i = 0; i < 2; i++) {
      final p = (pulse + i * 0.5) % 1.0;
      final r = maxR * (0.58 + 0.42 * p);
      final paint = Paint()
        ..color = color.withValues(alpha: (1 - p) * 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(center, r, paint);
    }

    // Orbiting / radiating water droplet sparkles
    if (!isLoading) {
      for (int i = 0; i < 6; i++) {
        final angle = (i * math.pi / 3) + pulse * 0.35;
        final orbit = maxR * (0.72 + 0.14 * enter);
        final pos = center + Offset(math.cos(angle), math.sin(angle)) * orbit;
        final dotRadius = (i.isEven ? 4.2 : 2.6) * enter.clamp(0.0, 1.0);
        final dotPaint = Paint()
          ..color = color.withValues(alpha: i.isEven ? 0.55 : 0.35);
        canvas.drawCircle(pos, dotRadius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _OrbSplashPainter oldDelegate) =>
      oldDelegate.pulse != pulse ||
      oldDelegate.enter != enter ||
      oldDelegate.color != color;
}

/// Interactive Rive-inspired water-droplet companion whose expression and glow
/// smoothly morph with user star rating (`1..5`).
class HydrationRatingCompanion extends StatelessWidget {
  const HydrationRatingCompanion({
    super.key,
    required this.rating,
    this.size = 104,
  });

  final int rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    final clamped = rating.clamp(0, 5);
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: clamped.toDouble(), end: clamped.toDouble()),
      duration: FlowinMotion.resolve(context, FlowinDurations.medium),
      curve: FlowinCurves.spring,
      builder: (context, mood, _) {
        final color = mood >= 4
            ? FlowinColors.primary
            : (mood >= 2.5 ? FlowinColors.aqua : FlowinColors.amber);
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _DropletMoodPainter(mood: mood, color: color),
          ),
        );
      },
    );
  }
}

class _DropletMoodPainter extends CustomPainter {
  _DropletMoodPainter({required this.mood, required this.color});

  final double mood;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w * 0.5, h * 0.56);

    // Halo
    canvas.drawCircle(
      center,
      w * 0.44,
      Paint()..color = color.withValues(alpha: 0.11),
    );

    // Teardrop silhouette
    final dropPath = Path()
      ..moveTo(w * 0.5, h * 0.08)
      ..cubicTo(w * 0.80, h * 0.40, w * 0.86, h * 0.62, w * 0.78, h * 0.78)
      ..cubicTo(w * 0.69, h * 0.92, w * 0.31, h * 0.92, w * 0.22, h * 0.78)
      ..cubicTo(w * 0.14, h * 0.62, w * 0.20, h * 0.40, w * 0.5, h * 0.08)
      ..close();

    final rect = Rect.fromLTWH(0, 0, w, h);
    final gradPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.lerp(color, Colors.white, 0.3)!,
          color,
          FlowinColors.deepOcean,
        ],
      ).createShader(rect);
    canvas.drawPath(dropPath, gradPaint);

    // Specular highlight
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.38, h * 0.44),
        width: w * 0.10,
        height: h * 0.18,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.34),
    );

    // Eyes
    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(w * 0.41, h * 0.57), w * 0.036, eyePaint);
    canvas.drawCircle(Offset(w * 0.59, h * 0.57), w * 0.036, eyePaint);

    // Morphing smile curve (-1 sad .. 0 neutral .. +1 big grin)
    final normalizedSmile = mood == 0 ? 0.2 : ((mood - 3.0) / 2.0).clamp(-1.0, 1.0);
    final mouthPath = Path()
      ..moveTo(w * 0.40, h * 0.68)
      ..quadraticBezierTo(
        w * 0.50,
        h * (0.68 + normalizedSmile * 0.09),
        w * 0.60,
        h * 0.68,
      );
    canvas.drawPath(
      mouthPath,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.2
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _DropletMoodPainter oldDelegate) =>
      oldDelegate.mood != mood || oldDelegate.color != color;
}

/// Gently swaying gallon vessel illustration for Empty Cart & Empty Orders states.
class HydrationVesselGraphic extends StatefulWidget {
  const HydrationVesselGraphic({super.key, this.size = 112});

  final double size;

  @override
  State<HydrationVesselGraphic> createState() => _HydrationVesselGraphicState();
}

class _HydrationVesselGraphicState extends State<HydrationVesselGraphic>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = FlowinMotion.isReduced(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final tilt = reduced ? 0.0 : (_controller.value - 0.5) * 0.06;
        return Transform.rotate(
          angle: tilt,
          child: CustomPaint(
            size: Size.square(widget.size),
            painter: _VesselPainter(wavePhase: _controller.value),
          ),
        );
      },
    );
  }
}

class _VesselPainter extends CustomPainter {
  _VesselPainter({required this.wavePhase});

  final double wavePhase;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Soft halo circle
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.54),
      w * 0.44,
      Paint()..color = FlowinColors.cyanMist,
    );

    // Gallon bottle neck
    final neckRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.22), width: w * 0.22, height: h * 0.12),
      const Radius.circular(6),
    );
    canvas.drawRRect(neckRect, Paint()..color = FlowinColors.primaryBright);

    // Gallon body silhouette
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.27, h * 0.27, w * 0.46, h * 0.58),
      const Radius.circular(18),
    );
    canvas.save();
    canvas.clipRRect(bodyRect);
    canvas.drawRect(
      bodyRect.outerRect,
      Paint()..color = Colors.white,
    );

    // Animated shallow water wave at bottom third of vessel
    final waveY = h * 0.64;
    final wavePath = Path()..moveTo(w * 0.24, h * 0.88);
    for (int i = 0; i <= 12; i++) {
      final t = i / 12;
      final x = w * (0.24 + 0.52 * t);
      final y = waveY + math.sin(t * 2 * math.pi + wavePhase * 2 * math.pi) * 4.5;
      wavePath.lineTo(x, y);
    }
    wavePath
      ..lineTo(w * 0.76, h * 0.88)
      ..close();
    canvas.drawPath(
      wavePath,
      Paint()..color = FlowinColors.aqua.withValues(alpha: 0.45),
    );
    canvas.restore();

    canvas.drawRRect(
      bodyRect,
      Paint()
        ..color = FlowinColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.6,
    );
  }

  @override
  bool shouldRepaint(covariant _VesselPainter oldDelegate) =>
      oldDelegate.wavePhase != wavePhase;
}

