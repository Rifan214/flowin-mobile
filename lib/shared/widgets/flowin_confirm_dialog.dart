import 'package:flutter/material.dart';

import '../../core/animations/app_haptics.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_motion.dart';
import '../../core/design_system/flowin_typography.dart';
import 'flowin_button.dart';

/// Displays an Ocean Mist & Deep Current styled confirmation dialog with
/// smooth spring-scale & fade transitions honoring reduced-motion settings.
Future<bool?> showFlowinConfirmDialog(
  BuildContext context, {
  required String title,
  required String description,
  String cancelLabel = 'Cancel',
  String confirmLabel = 'Confirm',
  bool isDestructive = true,
  IconData? icon,
}) {
  final reduced = FlowinMotion.isReduced(context);
  return showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: FlowinColors.ink.withValues(alpha: 0.42),
    transitionDuration:
        reduced ? Duration.zero : const Duration(milliseconds: 240),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Material(
              color: FlowinColors.surface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: FlowinColors.border.withValues(alpha: 0.9),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: isDestructive
                            ? FlowinColors.dangerSoft
                            : FlowinColors.cyanMist,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon ??
                            (isDestructive
                                ? Icons.delete_sweep_rounded
                                : Icons.help_outline_rounded),
                        color: isDestructive
                            ? FlowinColors.danger
                            : FlowinColors.primary,
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: FlowinTypography.headlineMedium.copyWith(
                        fontSize: 19,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: FlowinTypography.bodyMedium.copyWith(
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: FlowinButton(
                            label: cancelLabel,
                            height: 46,
                            variant: FlowinButtonVariant.outlined,
                            onPressed: () {
                              AppHaptics.light();
                              Navigator.of(dialogContext).pop(false);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FlowinButton(
                            label: confirmLabel,
                            height: 46,
                            variant: isDestructive
                                ? FlowinButtonVariant.danger
                                : FlowinButtonVariant.primary,
                            onPressed: () {
                              AppHaptics.medium();
                              Navigator.of(dialogContext).pop(true);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      if (reduced) return child;
      final curved = CurvedAnimation(
        parent: animation,
        curve: FlowinCurves.emphasized,
        reverseCurve: Curves.easeIn,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

