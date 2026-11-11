import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../design_system/flowin_motion.dart';

/// Multi-layer harmonic wave backdrop inspired by Flutter Vignettes `drink_rewards_list`
/// `LiquidPainter`, tuned for aqua hydration backgrounds and banners.
class LiquidWaveBackdrop extends StatefulWidget {
  const LiquidWaveBackdrop({
    super.key,
    this.frontColor = const Color(0x3338D9F5),
    this.backColor = const Color(0x220A3270),
    this.fillLevel = 0.42,
    this.waveAmplitude = 14,
    this.animate = true,
    this.child,
  });

  final Color frontColor;
  final Color backColor;
  final double fillLevel;
  final double waveAmplitude;
  final bool animate;
  final Widget? child;

  @override
  State<LiquidWaveBackdrop> createState() => _LiquidWaveBackdropState();
}

class _LiquidWaveBackdropState extends State<LiquidWaveBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: FlowinDurations.waveCycle,
    );
    if (widget.animate) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant LiquidWaveBackdrop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
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
    final reduced = FlowinMotion.isReduced(context) || !widget.animate;
    return RepaintBoundary(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final phase = reduced ? 0.25 : _controller.value;
                return CustomPaint(
                  painter: _DualWavePainter(
                    phase: phase,
                    fillLevel: widget.fillLevel,
                    waveAmplitude: widget.waveAmplitude,
                    frontColor: widget.frontColor,
                    backColor: widget.backColor,
                  ),
                );
              },
            ),
          ),
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }
}

class _DualWavePainter extends CustomPainter {
  _DualWavePainter({
    required this.phase,
    required this.fillLevel,
    required this.waveAmplitude,
    required this.frontColor,
    required this.backColor,
  });

  final double phase;
  final double fillLevel;
  final double waveAmplitude;
  final Color frontColor;
  final Color backColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    _drawLayer(
      canvas,
      size,
      color: backColor,
      phaseShift: phase * 2 * math.pi + 1.4,
      amplitude: waveAmplitude * 1.1,
      baseY: size.height * (1 - fillLevel) - 4,
      frequency: 1.5,
    );
    _drawLayer(
      canvas,
      size,
      color: frontColor,
      phaseShift: -phase * 2 * math.pi,
      amplitude: waveAmplitude,
      baseY: size.height * (1 - fillLevel) + 4,
      frequency: 2.0,
    );
  }

  void _drawLayer(
    Canvas canvas,
    Size size, {
    required Color color,
    required double phaseShift,
    required double amplitude,
    required double baseY,
    required double frequency,
  }) {
    final paint = Paint()..color = color;
    final path = Path()..moveTo(0, size.height);
    const segments = 24;
    for (int i = 0; i <= segments; i++) {
      final t = i / segments;
      final x = size.width * t;
      final y = baseY +
          math.sin(t * frequency * 2 * math.pi + phaseShift) * amplitude +
          math.cos(t * math.pi + phaseShift * 0.5) * (amplitude * 0.25);
      path.lineTo(x, y);
    }
    path
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DualWavePainter oldDelegate) =>
      oldDelegate.phase != phase ||
      oldDelegate.fillLevel != fillLevel ||
      oldDelegate.frontColor != frontColor ||
      oldDelegate.backColor != backColor;
}

