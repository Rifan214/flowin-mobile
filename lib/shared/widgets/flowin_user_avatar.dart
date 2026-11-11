import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_spacing.dart';

/// Reactive circular user avatar rendering in-memory photo bytes with graceful
/// fallback to Flowin's Ocean Mist person crest when unset or unreadable.
class FlowinUserAvatar extends StatelessWidget {
  const FlowinUserAvatar({
    super.key,
    required this.photoBytes,
    this.size = 56,
    this.onTap,
    this.showCameraBadge = false,
    this.isLoading = false,
    this.borderColor,
    this.borderWidth = 0,
  });

  final Uint8List? photoBytes;
  final double size;
  final VoidCallback? onTap;
  final bool showCameraBadge;
  final bool isLoading;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final bytes = photoBytes;
    final hasBytes = bytes != null && bytes.isNotEmpty;
    final badgeSize = (size * 0.34).clamp(20.0, 32.0);

    Widget avatarCore = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: FlowinColors.cyanMist,
        border: borderWidth > 0
            ? Border.all(
                color: borderColor ?? Colors.white,
                width: borderWidth,
              )
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasBytes)
            Image.memory(
              bytes,
              width: size,
              height: size,
              fit: BoxFit.cover,
              gaplessPlayback: true,
              errorBuilder: (_, _, _) => _DefaultAvatarCrest(size: size),
            )
          else
            _DefaultAvatarCrest(size: size),
          if (isLoading)
            ColoredBox(
              color: FlowinColors.ink.withValues(alpha: 0.42),
              child: const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (showCameraBadge) {
      avatarCore = SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            avatarCore,
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: badgeSize,
                height: badgeSize,
                decoration: BoxDecoration(
                  color: FlowinColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.2),
                  boxShadow: FlowinShadows.cardSoft,
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: badgeSize * 0.52,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (onTap == null) {
      return Semantics(
        label: 'Profile avatar',
        child: avatarCore,
      );
    }

    return Semantics(
      label: 'Change profile photo',
      button: true,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: avatarCore,
      ),
    );
  }
}

class _DefaultAvatarCrest extends StatelessWidget {
  const _DefaultAvatarCrest({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: FlowinColors.mistSurfaceGradient,
      ),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          color: FlowinColors.primary,
          size: size * 0.52,
        ),
      ),
    );
  }
}
