import 'package:flutter/material.dart';

import '../core/animations/app_haptics.dart';
import '../core/animations/flowin_page_routes.dart';
import '../core/design_system/flowin_colors.dart';
import '../core/design_system/flowin_spacing.dart';
import '../core/design_system/flowin_typography.dart';
import '../screens/notification/notification_screen.dart';
import '../state/flowin_app_state.dart';

/// Unified modern header shared across Flowin's primary tabs and sub-screens.
/// Supports declarative [showNotification], [showBackButton], [leading],
/// [actions], and [notificationCount] configuration without leaving empty
/// spacer boxes when trailing actions are disabled.
class FlowinHeader extends StatelessWidget {
  const FlowinHeader({
    super.key,
    this.title = 'Flowin',
    this.leading,
    this.leftIcon,
    this.rightIcon,
    this.onLeftIconPressed,
    this.onRightIconPressed,
    this.textColor,
    this.actions,
    this.showBrandLogo = false,
    this.showBackButton,
    this.showNotification = true,
    this.notificationCount,
  });

  final String title;
  final Widget? leading;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final VoidCallback? onLeftIconPressed;
  final VoidCallback? onRightIconPressed;
  final Color? textColor;
  final List<Widget>? actions;
  final bool showBrandLogo;
  final bool? showBackButton;
  final bool showNotification;
  final int? notificationCount;

  @override
  Widget build(BuildContext context) {
    final appState =
        context.dependOnInheritedWidgetOfExactType<FlowinScope>()?.notifier;
    final unreadCount =
        notificationCount ?? (appState?.unreadNotificationsCount ?? 0);
    final canPop = Navigator.of(context).canPop();
    final shouldShowBack = showBackButton ?? (canPop && title != 'Flowin');
    final isBrandedHome =
        showBrandLogo || (title == 'Flowin' && leftIcon == null && !canPop);
    final foreground = textColor ?? FlowinColors.ink;

    Widget? leadingWidget;
    if (leading != null) {
      leadingWidget = leading;
    } else if (leftIcon != null && leftIcon is! SizedBox) {
      leadingWidget = _HeaderCircleWidgetAction(
        iconWidget: leftIcon!,
        foreground: foreground,
        onTap: onLeftIconPressed ?? () => Navigator.of(context).maybePop(),
      );
    } else if (leftIcon == null && shouldShowBack) {
      leadingWidget = _HeaderCircleAction(
        icon: Icons.arrow_back_ios_new_rounded,
        foreground: foreground,
        onTap: onLeftIconPressed ?? () => Navigator.of(context).maybePop(),
      );
    }

    Widget? trailingWidget;
    if (actions != null) {
      if (actions!.length == 1) {
        trailingWidget = actions!.first;
      } else if (actions!.length > 1) {
        trailingWidget = Row(mainAxisSize: MainAxisSize.min, children: actions!);
      }
    } else if (!showNotification || rightIcon is SizedBox) {
      trailingWidget = null;
    } else if (rightIcon != null) {
      trailingWidget = _HeaderCircleWidgetAction(
        iconWidget: rightIcon!,
        foreground: foreground,
        onTap: onRightIconPressed ??
            () {
              Navigator.push(
                context,
                FlowinPageRoute.sharedAxis(const NotificationScreen()),
              );
            },
      );
    } else {
      trailingWidget = _HeaderCircleAction(
        icon: Icons.notifications_none_rounded,
        foreground: foreground,
        badgeCount: unreadCount,
        onTap: onRightIconPressed ??
            () {
              Navigator.push(
                context,
                FlowinPageRoute.sharedAxis(const NotificationScreen()),
              );
            },
      );
    }

    final useBrandHeader = isBrandedHome && leadingWidget == null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 44,
        child: useBrandHeader
            ? Row(
                children: [
                  _BrandWordmark(foreground: foreground),
                  const Spacer(),
                  ?trailingWidget,
                ],
              )
            : NavigationToolbar(
                centerMiddle: true,
                middleSpacing: 12,
                leading: leadingWidget,
                middle: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FlowinTypography.titleLarge.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                trailing: trailingWidget,
              ),
      ),
    );
  }
}

class _BrandWordmark extends StatelessWidget {
  const _BrandWordmark({required this.foreground});

  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: FlowinColors.oceanGradient,
            borderRadius: BorderRadius.circular(11),
            boxShadow: FlowinShadows.primaryGlow,
          ),
          child: const Icon(
            Icons.water_drop_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'flowin',
              style: FlowinTypography.headlineMedium.copyWith(
                color: foreground,
                height: 1.0,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'PURE HYDRATION',
              style: FlowinTypography.overline.copyWith(
                fontSize: 9,
                letterSpacing: 1.1,
                color: FlowinColors.aqua,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeaderCircleAction extends StatelessWidget {
  const _HeaderCircleAction({
    required this.icon,
    required this.foreground,
    required this.onTap,
    this.badgeCount = 0,
  });

  final IconData icon;
  final Color foreground;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return _HeaderCircleWidgetAction(
      iconWidget: Icon(icon, size: 20, color: foreground),
      foreground: foreground,
      onTap: onTap,
      badgeCount: badgeCount,
    );
  }
}

class _HeaderCircleWidgetAction extends StatelessWidget {
  const _HeaderCircleWidgetAction({
    required this.iconWidget,
    required this.foreground,
    required this.onTap,
    this.badgeCount = 0,
  });

  final Widget iconWidget;
  final Color foreground;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final isDarkOverlay = foreground == Colors.white;
    return Material(
      color: isDarkOverlay
          ? Colors.white.withValues(alpha: 0.16)
          : FlowinColors.surface,
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          AppHaptics.light();
          onTap();
        },
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDarkOverlay
                  ? Colors.white.withValues(alpha: 0.25)
                  : FlowinColors.border,
            ),
            boxShadow: isDarkOverlay ? null : FlowinShadows.cardSoft,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconTheme(
                data: IconThemeData(size: 20, color: foreground),
                child: iconWidget,
              ),
              if (badgeCount > 0)
                Positioned(
                  top: 8,
                  right: 9,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: FlowinColors.amber,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.2),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
