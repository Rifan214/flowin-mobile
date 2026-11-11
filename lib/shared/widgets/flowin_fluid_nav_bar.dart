import 'package:flutter/material.dart';

import '../../core/animations/app_haptics.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_motion.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';

class FluidNavTab {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final int badgeCount;

  const FluidNavTab({
    required this.label,
    required this.icon,
    required this.activeIcon,
    this.badgeCount = 0,
  });
}

/// Custom curved fluid bottom navigation bar inspired by Flutter Vignettes `fluid_nav_bar`,
/// featuring a smoothly traveling concave trough, lifted circular tab indicator, and spring cart badge.
class FlowinFluidNavBar extends StatefulWidget {
  const FlowinFluidNavBar({
    super.key,
    required this.selectedIndex,
    required this.tabs,
    required this.onSelected,
  });

  final int selectedIndex;
  final List<FluidNavTab> tabs;
  final ValueChanged<int> onSelected;

  @override
  State<FlowinFluidNavBar> createState() => _FlowinFluidNavBarState();
}

class _FlowinFluidNavBarState extends State<FlowinFluidNavBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late double _fromIndex;
  late double _toIndex;

  @override
  void initState() {
    super.initState();
    _fromIndex = widget.selectedIndex.toDouble();
    _toIndex = _fromIndex;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
      value: 1.0,
    );
  }

  @override
  void didUpdateWidget(covariant FlowinFluidNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _fromIndex = _currentProgress;
      _toIndex = widget.selectedIndex.toDouble();
      _controller.forward(from: 0.0);
    }
  }

  double get _currentProgress {
    final t = FlowinCurves.emphasized.transform(_controller.value);
    return _fromIndex + (_toIndex - _fromIndex) * t;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final reduced = FlowinMotion.isReduced(context);

    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, bottomInset > 0 ? bottomInset : 12),
      height: 72,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final activePos = reduced
              ? widget.selectedIndex.toDouble()
              : _currentProgress;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Painted fluid hull with dipped curve under active index
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: FlowinShadows.floatingNav,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: CustomPaint(
                      painter: _FluidNavHullPainter(
                        tabCount: widget.tabs.length,
                        activeIndex: activePos,
                      ),
                    ),
                  ),
                ),
              ),

              // Interactive tab buttons
              Positioned.fill(
                child: Row(
                  children: List.generate(widget.tabs.length, (i) {
                    final tab = widget.tabs[i];
                    final selected = i == widget.selectedIndex;
                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          AppHaptics.selection();
                          widget.onSelected(i);
                        },
                        child: Semantics(
                          button: true,
                          selected: selected,
                          label: tab.label,
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              AnimatedPositioned(
                                duration: FlowinMotion.resolve(
                                  context,
                                  const Duration(milliseconds: 280),
                                ),
                                curve: FlowinCurves.spring,
                                top: selected ? -14 : 14,
                                child: AnimatedContainer(
                                  duration: FlowinMotion.resolve(
                                    context,
                                    const Duration(milliseconds: 240),
                                  ),
                                  width: selected ? 48 : 34,
                                  height: selected ? 48 : 30,
                                  decoration: BoxDecoration(
                                    gradient: selected ? FlowinColors.oceanGradient : null,
                                    shape: BoxShape.circle,
                                    boxShadow: selected ? FlowinShadows.primaryGlow : null,
                                  ),
                                  child: Icon(
                                    selected ? tab.activeIcon : tab.icon,
                                    size: selected ? 23 : 22,
                                    color: selected
                                        ? Colors.white
                                        : FlowinColors.inkSecondary,
                                  ),
                                ),
                              ),
                              if (tab.badgeCount > 0)
                                Positioned(
                                  top: selected ? -16 : 9,
                                  right: 16,
                                  child: _AnimatedCartBadge(count: tab.badgeCount),
                                ),
                              Positioned(
                                bottom: 10,
                                child: AnimatedDefaultTextStyle(
                                  duration: FlowinMotion.resolve(
                                    context,
                                    FlowinDurations.fast,
                                  ),
                                  style: FlowinTypography.caption.copyWith(
                                    fontSize: 11,
                                    fontWeight:
                                        selected ? FontWeight.w700 : FontWeight.w500,
                                    color: selected
                                        ? FlowinColors.primary
                                        : FlowinColors.inkSecondary,
                                  ),
                                  child: Text(tab.label),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AnimatedCartBadge extends StatelessWidget {
  const _AnimatedCartBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(count),
      tween: Tween(begin: 1.25, end: 1.0),
      duration: FlowinMotion.resolve(context, const Duration(milliseconds: 280)),
      curve: Curves.elasticOut,
      builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.5, vertical: 1.5),
        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
        decoration: BoxDecoration(
          color: FlowinColors.amber,
          borderRadius: FlowinRadii.fullPill,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Center(
          child: Text(
            count > 99 ? '99+' : '$count',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}

class _FluidNavHullPainter extends CustomPainter {
  _FluidNavHullPainter({required this.tabCount, required this.activeIndex});

  final int tabCount;
  final double activeIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final slotWidth = size.width / tabCount;
    final cx = slotWidth * (activeIndex + 0.5);
    const notchWidth = 68.0;
    const notchDepth = 18.0;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo((cx - notchWidth * 0.65).clamp(0.0, size.width), 0)
      ..cubicTo(
        cx - notchWidth * 0.34,
        0,
        cx - notchWidth * 0.28,
        notchDepth,
        cx,
        notchDepth,
      )
      ..cubicTo(
        cx + notchWidth * 0.28,
        notchDepth,
        cx + notchWidth * 0.34,
        0,
        (cx + notchWidth * 0.65).clamp(0.0, size.width),
        0,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      path,
      Paint()..color = FlowinColors.surface,
    );
  }

  @override
  bool shouldRepaint(covariant _FluidNavHullPainter oldDelegate) =>
      oldDelegate.activeIndex != activeIndex || oldDelegate.tabCount != tabCount;
}

