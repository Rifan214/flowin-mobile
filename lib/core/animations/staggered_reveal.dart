import 'package:flutter/material.dart';

import '../design_system/flowin_motion.dart';

/// Smooth entrance slide + fade choreography modeled on Wonderous &
/// Vignettes `Interval`-based reveals without dangling timers.
class StaggeredReveal extends StatefulWidget {
  const StaggeredReveal({
    super.key,
    required this.child,
    this.index = 0,
    this.offsetY = 18,
    this.duration = const Duration(milliseconds: 420),
    this.animate = true,
  });

  final Widget child;
  final int index;
  final double offsetY;
  final Duration duration;
  final bool animate;

  @override
  State<StaggeredReveal> createState() => _StaggeredRevealState();
}

class _StaggeredRevealState extends State<StaggeredReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _curved;

  @override
  void initState() {
    super.initState();
    final delayMs = (widget.index.clamp(0, 8)) * 45;
    final totalDuration =
        Duration(milliseconds: widget.duration.inMilliseconds + delayMs);
    final startFraction = delayMs / totalDuration.inMilliseconds;

    _controller = AnimationController(vsync: this, duration: totalDuration);
    _curved = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        startFraction.clamp(0.0, 0.8),
        1.0,
        curve: FlowinCurves.decelerate,
      ),
    );

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (FlowinMotion.isReduced(context) || !widget.animate) {
      return widget.child;
    }
    return AnimatedBuilder(
      animation: _curved,
      child: widget.child,
      builder: (context, child) {
        final t = _curved.value;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - t) * widget.offsetY),
            child: child,
          ),
        );
      },
    );
  }
}

