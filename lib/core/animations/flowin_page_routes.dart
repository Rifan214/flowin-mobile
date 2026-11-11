import 'package:flutter/material.dart';

import '../design_system/flowin_motion.dart';

/// Custom PageRoute transitions adapted from Wonderous `PageRoutes`.
class FlowinPageRoute {
  FlowinPageRoute._();

  /// Smooth fade + gentle depth scale transition for major flow switches
  /// (Onboarding -> Login, Auth -> Home, Payment -> Confirmation).
  static Route<T> fadeScale<T>(
    Widget page, {
    Duration? duration,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration ?? const Duration(milliseconds: 340),
      reverseTransitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (FlowinMotion.isReduced(context)) return child;
        final curved = CurvedAnimation(
          parent: animation,
          curve: FlowinCurves.emphasized,
          reverseCurve: Curves.easeIn,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.965, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  /// Continuous shared-axis horizontal transition for multi-step purchase
  /// & settings flows (Cart -> Checkout -> Payment, Profile -> Subpages).
  static Route<T> sharedAxis<T>(
    Widget page, {
    Duration? duration,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration ?? const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (FlowinMotion.isReduced(context)) return child;
        final forward = CurvedAnimation(
          parent: animation,
          curve: FlowinCurves.emphasized,
        );
        final outgoing = CurvedAnimation(
          parent: secondaryAnimation,
          curve: Curves.easeInOutCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.08, 0),
            end: Offset.zero,
          ).animate(forward),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(forward),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(-0.04, 0),
              ).animate(outgoing),
              child: child,
            ),
          ),
        );
      },
    );
  }

  /// Vertical sheet-style route for modal tracking/cancel/detail views.
  static Route<T> modalSlide<T>(
    Widget page, {
    Duration? duration,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration ?? const Duration(milliseconds: 360),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (FlowinMotion.isReduced(context)) return child;
        final curved = CurvedAnimation(
          parent: animation,
          curve: FlowinCurves.decelerate,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.10),
            end: Offset.zero,
          ).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );
      },
    );
  }
}

