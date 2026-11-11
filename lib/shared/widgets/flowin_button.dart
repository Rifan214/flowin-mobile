import 'package:flutter/material.dart';

import '../../core/animations/app_haptics.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_motion.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';

enum FlowinButtonVariant { primary, amber, tinted, outlined, danger, ghost }

/// Tactile CTA button inspired by Wonderous `AppBtn` with press-scale feedback,
/// gradient depth, optional loading state, and reduced-motion awareness.
class FlowinButton extends StatefulWidget {
  const FlowinButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = FlowinButtonVariant.primary,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.expand = true,
    this.height = 54,
    this.borderRadius,
  });

  final String label;
  final VoidCallback? onPressed;
  final FlowinButtonVariant variant;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool expand;
  final double height;
  final BorderRadius? borderRadius;

  @override
  State<FlowinButton> createState() => _FlowinButtonState();
}

class _FlowinButtonState extends State<FlowinButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? FlowinRadii.button;
    final scale = _pressed && _enabled ? 0.968 : 1.0;

    Color fgColor;
    Gradient? gradient;
    Color? solidBg;
    Border? border;
    List<BoxShadow>? shadows;

    switch (widget.variant) {
      case FlowinButtonVariant.primary:
        fgColor = Colors.white;
        gradient = _enabled ? FlowinColors.oceanGradient : null;
        solidBg = _enabled ? null : FlowinColors.inkMuted.withValues(alpha: 0.35);
        shadows = _enabled ? FlowinShadows.primaryGlow : null;
      case FlowinButtonVariant.amber:
        fgColor = Colors.white;
        gradient = _enabled ? FlowinColors.amberGradient : null;
        solidBg = _enabled ? null : FlowinColors.inkMuted.withValues(alpha: 0.35);
        shadows = _enabled
            ? [
                BoxShadow(
                  color: FlowinColors.amber.withValues(alpha: 0.28),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : null;
      case FlowinButtonVariant.tinted:
        fgColor = FlowinColors.primary;
        solidBg = FlowinColors.cyanMist;
      case FlowinButtonVariant.outlined:
        fgColor = FlowinColors.primary;
        solidBg = FlowinColors.surface;
        border = Border.all(color: FlowinColors.border, width: 1.4);
      case FlowinButtonVariant.danger:
        fgColor = FlowinColors.danger;
        solidBg = FlowinColors.dangerSoft;
        border = Border.all(
          color: FlowinColors.danger.withValues(alpha: 0.28),
          width: 1.2,
        );
      case FlowinButtonVariant.ghost:
        fgColor = FlowinColors.inkSecondary;
        solidBg = Colors.transparent;
    }

    final content = AnimatedContainer(
      duration: FlowinMotion.resolve(context, FlowinDurations.fast),
      height: widget.height,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: solidBg,
        gradient: gradient,
        borderRadius: radius,
        border: border,
        boxShadow: shadows,
      ),
      child: Center(
        widthFactor: widget.expand ? null : 1.0,
        child: widget.isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: fgColor,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, size: 19, color: fgColor),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      widget.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FlowinTypography.button.copyWith(color: fgColor),
                    ),
                  ),
                  if (widget.trailingIcon != null) ...[
                    const SizedBox(width: 8),
                    Icon(widget.trailingIcon, size: 18, color: fgColor),
                  ],
                ],
              ),
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: _enabled ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: _enabled ? () => setState(() => _pressed = false) : null,
      onTap: _enabled
          ? () {
              AppHaptics.light();
              widget.onPressed?.call();
            }
          : null,
      child: AnimatedScale(
        scale: FlowinMotion.isReduced(context) ? 1.0 : scale,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: Semantics(
          button: true,
          enabled: _enabled,
          label: widget.label,
          child: widget.expand
              ? SizedBox(width: double.infinity, child: content)
              : content,
        ),
      ),
    );
  }
}

