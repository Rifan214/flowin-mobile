import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/animations/app_haptics.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_motion.dart';

/// Expressive yet lightweight Favorite toggle button with:
/// - brief tactile press-scale feedback,
/// - spring overshoot pop on save + subtle aqua/coral particle burst & ripple,
/// - calm reverse transition back to outline on un-save (no over-celebration),
/// - full reduced-motion awareness and single AnimationController lifecycle.
class FlowinFavoriteButton extends StatefulWidget {
  const FlowinFavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
    this.size = 32,
    this.iconSize = 17,
    this.backgroundColor,
    this.borderColor,
    this.boxShadow,
    this.activeColor = FlowinColors.danger,
    this.inactiveColor = FlowinColors.inkSecondary,
  });

  final bool isFavorite;
  final VoidCallback onPressed;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final Color activeColor;
  final Color inactiveColor;

  @override
  State<FlowinFavoriteButton> createState() => _FlowinFavoriteButtonState();
}

class _FlowinFavoriteButtonState extends State<FlowinFavoriteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _pressed = false;
  bool _celebrateBurst = false;

  static final Animatable<double> _addScaleSequence = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween<double>(begin: 0.92, end: 0.78)
          .chain(CurveTween(curve: Curves.easeOut)),
      weight: 14,
    ),
    TweenSequenceItem(
      tween: Tween<double>(begin: 0.78, end: 1.32)
          .chain(CurveTween(curve: FlowinCurves.spring)),
      weight: 42,
    ),
    TweenSequenceItem(
      tween: Tween<double>(begin: 1.32, end: 0.95)
          .chain(CurveTween(curve: Curves.easeInOut)),
      weight: 22,
    ),
    TweenSequenceItem(
      tween: Tween<double>(begin: 0.95, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOut)),
      weight: 22,
    ),
  ]);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 220),
      value: widget.isFavorite ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(covariant FlowinFavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite == widget.isFavorite) return;

    final reduced = FlowinMotion.isReduced(context);
    if (reduced) {
      _celebrateBurst = false;
      _controller.value = widget.isFavorite ? 1.0 : 0.0;
      return;
    }

    if (widget.isFavorite) {
      _celebrateBurst = true;
      _controller.forward(from: 0.0);
    } else {
      _celebrateBurst = false;
      _controller.reverse(from: 1.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    AppHaptics.selection();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = FlowinMotion.isReduced(context);
    final bgColor =
        widget.backgroundColor ?? Colors.white.withValues(alpha: 0.92);

    return Semantics(
      button: true,
      toggled: widget.isFavorite,
      label: widget.isFavorite ? 'Remove from favorites' : 'Save to favorites',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: _handleTap,
        child: AnimatedScale(
          scale: reduced ? 1.0 : (_pressed ? 0.84 : 1.0),
          duration: reduced
              ? Duration.zero
              : const Duration(milliseconds: 95),
          curve: Curves.easeOut,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                      border: widget.borderColor != null
                          ? Border.all(color: widget.borderColor!)
                          : null,
                      boxShadow: widget.boxShadow,
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final t = _controller.value;
                    final showBurst =
                        !reduced && _celebrateBurst && t > 0.0 && t < 1.0;

                    final double iconScale;
                    if (reduced) {
                      iconScale = 1.0;
                    } else if (_celebrateBurst) {
                      iconScale = _addScaleSequence.transform(t);
                    } else if (t > 0.0 && t < 1.0) {
                      // Calm reverse contraction + settle when removing favorite.
                      iconScale = 0.84 + 0.16 * (1.0 - math.sin(t * math.pi) * 0.65);
                    } else {
                      iconScale = 1.0;
                    }

                    final blendedColor = Color.lerp(
                      widget.inactiveColor,
                      widget.activeColor,
                      t,
                    )!;

                    // Keep only the active target icon mounted at rest (t=0 or t=1)
                    // while crossfading smoothly mid-transition.
                    final showFilled = t >= 0.35 || (widget.isFavorite && t == 1.0);

                    return Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        if (showBurst)
                          Positioned.fill(
                            child: IgnorePointer(
                              child: RepaintBoundary(
                                child: CustomPaint(
                                  painter: _FavoriteBurstPainter(
                                    progress: t,
                                    accentColor: widget.activeColor,
                                    dropletColor: FlowinColors.aqua,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Transform.scale(
                          scale: iconScale,
                          child: Icon(
                            showFilled
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: widget.iconSize,
                            color: blendedColor,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FavoriteBurstPainter extends CustomPainter {
  const _FavoriteBurstPainter({
    required this.progress,
    required this.accentColor,
    required this.dropletColor,
  });

  final double progress;
  final Color accentColor;
  final Color dropletColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = math.min(size.width, size.height) * 0.45;

    // 1. Subtle radial ripple wave expanding smoothly outward.
    final rippleT = Curves.easeOutCubic.transform(progress);
    final rippleOpacity = (1.0 - rippleT).clamp(0.0, 1.0) * 0.45;
    if (rippleOpacity > 0.01) {
      final ripplePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = (2.2 * (1.0 - rippleT)).clamp(0.6, 2.2)
        ..color = dropletColor.withValues(alpha: rippleOpacity);
      canvas.drawCircle(
        center,
        baseRadius * (0.55 + 1.05 * rippleT),
        ripplePaint,
      );
    }

    // 2. 8 micro hydration/heart particles radiating outward and tapering down.
    final burstProgress =
        ((progress - 0.12) / 0.78).clamp(0.0, 1.0);
    if (burstProgress <= 0.0 || burstProgress >= 1.0) return;

    final easedBurst = Curves.easeOutQuad.transform(burstProgress);
    final fade = (1.0 - burstProgress).clamp(0.0, 1.0);
    const particleCount = 8;

    for (var i = 0; i < particleCount; i++) {
      final angle = (i * 2 * math.pi / particleCount) - math.pi / 8;
      final isEven = i.isEven;
      final maxTravel = baseRadius * (isEven ? 1.48 : 1.18);
      final distance = baseRadius * 0.55 + maxTravel * easedBurst;
      final pos = Offset(
        center.dx + math.cos(angle) * distance,
        center.dy + math.sin(angle) * distance,
      );
      final dotRadius = (isEven ? 2.4 : 1.8) * (1.0 - burstProgress * 0.75);
      final dotPaint = Paint()
        ..color = (isEven ? accentColor : dropletColor).withValues(
          alpha: fade * 0.9,
        );
      canvas.drawCircle(pos, dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FavoriteBurstPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.accentColor != accentColor ||
      oldDelegate.dropletColor != dropletColor;
}

