import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../design_system/flowin_colors.dart';
import '../design_system/flowin_motion.dart';
import '../design_system/flowin_spacing.dart';
import 'app_haptics.dart';

/// Expandable order/receipt card combining Flutter Vignettes `ticket_fold`
/// 3D perspective folding with Wonderous `OpeningCard` fluidity.
class TicketFoldCard extends StatefulWidget {
  const TicketFoldCard({
    super.key,
    required this.header,
    required this.foldedSummary,
    required this.expandedDetails,
    this.initiallyExpanded = true,
  });

  final Widget header;
  final Widget foldedSummary;
  final Widget expandedDetails;
  final bool initiallyExpanded;

  @override
  State<TicketFoldCard> createState() => _TicketFoldCardState();
}

class _TicketFoldCardState extends State<TicketFoldCard>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  late final AnimationController _controller;
  late final Animation<double> _flipAnim;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    _controller = AnimationController(
      vsync: this,
      duration: FlowinDurations.medium,
      value: _expanded ? 1.0 : 0.0,
    );
    _flipAnim = CurvedAnimation(
      parent: _controller,
      curve: FlowinCurves.emphasized,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    AppHaptics.selection();
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final reduced = FlowinMotion.isReduced(context);
    return Container(
      decoration: BoxDecoration(
        color: FlowinColors.surface,
        borderRadius: FlowinRadii.card,
        boxShadow: FlowinShadows.cardSoft,
        border: Border.all(color: FlowinColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 16, 14),
              child: Row(
                children: [
                  Expanded(child: widget.header),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0.0,
                    duration: FlowinMotion.resolve(context, FlowinDurations.medium),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: FlowinColors.cyanTint,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: FlowinColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const _PerforatedDivider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
            child: widget.foldedSummary,
          ),
          AnimatedBuilder(
            animation: _flipAnim,
            builder: (context, child) {
              final value = reduced ? (_expanded ? 1.0 : 0.0) : _flipAnim.value;
              if (value == 0.0) return const SizedBox.shrink();
              final angle = (1 - value) * (math.pi * 0.25);
              return ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: value.clamp(0.0, 1.0),
                  child: Transform(
                    alignment: Alignment.topCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(-angle),
                    child: Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: child,
                    ),
                  ),
                ),
              );
            },
            child: Container(
              color: FlowinColors.surfaceSubtle,
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
              child: widget.expandedDetails,
            ),
          ),
        ],
      ),
    );
  }
}

class _PerforatedDivider extends StatelessWidget {
  const _PerforatedDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: CustomPaint(
              size: const Size(double.infinity, 1),
              painter: _DashPainter(),
            ),
          ),
          Positioned(
            left: -8,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: FlowinColors.background,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: -8,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: FlowinColors.background,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = FlowinColors.border
      ..strokeWidth = 1.2;
    const dash = 5.0;
    const gap = 4.0;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(math.min(x + dash, size.width), 0), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

