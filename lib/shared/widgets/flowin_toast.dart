import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_motion.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';

enum FlowinToastType { success, info, warning, error }

/// Custom animated floating micro-notification overlay replacing raw SnackBars.
class FlowinToast {
  FlowinToast._();

  static OverlayEntry? _activeEntry;

  static void dismiss() {
    _activeEntry?.remove();
    _activeEntry = null;
  }

  static void show(
    BuildContext context, {
    required String title,
    String? message,
    FlowinToastType type = FlowinToastType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = FlowinDurations.toastVisible,
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    dismiss();

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => _FloatingToastBanner(
        title: title,
        message: message,
        type: type,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration,
        onDismissed: () {
          if (_activeEntry == entry) {
            entry.remove();
            _activeEntry = null;
          }
        },
      ),
    );
    _activeEntry = entry;
    overlay.insert(entry);
  }
}

class _FloatingToastBanner extends StatefulWidget {
  const _FloatingToastBanner({
    required this.title,
    this.message,
    required this.type,
    this.actionLabel,
    this.onAction,
    required this.duration,
    required this.onDismissed,
  });

  final String title;
  final String? message;
  final FlowinToastType type;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Duration duration;
  final VoidCallback onDismissed;

  @override
  State<_FloatingToastBanner> createState() => _FloatingToastBannerState();
}

class _FloatingToastBannerState extends State<_FloatingToastBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  Timer? _autoDismissTimer;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: FlowinCurves.spring));

    _controller.forward();
    _autoDismissTimer = Timer(widget.duration, _close);
  }

  Future<void> _close() async {
    if (_closing || !mounted) return;
    _closing = true;
    _autoDismissTimer?.cancel();
    await _controller.reverse();
    if (mounted) {
      widget.onDismissed();
    }
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (Color accent, IconData icon) = switch (widget.type) {
      FlowinToastType.success => (FlowinColors.success, Icons.check_circle_rounded),
      FlowinToastType.info => (FlowinColors.primary, Icons.water_drop_rounded),
      FlowinToastType.warning => (FlowinColors.warning, Icons.info_rounded),
      FlowinToastType.error => (FlowinColors.danger, Icons.error_rounded),
    };

    final topPadding = MediaQuery.paddingOf(context).top + 10;

    return Positioned(
      top: topPadding,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: _slide,
          child: FadeTransition(
            opacity: _controller,
            child: Dismissible(
              key: ValueKey('${widget.title}_${widget.message}'),
              direction: DismissDirection.up,
              onDismissed: (_) => widget.onDismissed(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: FlowinColors.ink.withValues(alpha: 0.94),
                  borderRadius: FlowinRadii.card,
                  boxShadow: FlowinShadows.floatingNav,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: accent, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: FlowinTypography.titleMedium.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          if (widget.message != null && widget.message!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                widget.message!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: FlowinTypography.caption.copyWith(
                                  color: Colors.white.withValues(alpha: 0.78),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (widget.actionLabel != null && widget.onAction != null)
                      TextButton(
                        onPressed: () {
                          widget.onAction?.call();
                          _close();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: FlowinColors.aquaBright,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        child: Text(
                          widget.actionLabel!,
                          style: FlowinTypography.titleMedium.copyWith(
                            color: FlowinColors.aquaBright,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

