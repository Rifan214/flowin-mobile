import 'package:flutter/material.dart';

import '../core/animations/liquid_wave_painter.dart';
import '../core/design_system/flowin_colors.dart';
import '../core/design_system/flowin_spacing.dart';
import '../core/design_system/flowin_typography.dart';
import '../shared/widgets/flowin_user_avatar.dart';
import '../state/flowin_app_state.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key, this.onEditPressed});

  final VoidCallback? onEditPressed;

  @override
  Widget build(BuildContext context) {
    final appState =
        context.dependOnInheritedWidgetOfExactType<FlowinScope>()?.notifier;
    final name = appState?.userName ?? 'Alex Morgan';
    final email = appState?.userEmail ?? 'alex.morgan@flowin.id';
    final activePlan = appState?.activeSubscription;

    return Container(
      decoration: BoxDecoration(
        gradient: FlowinColors.oceanGradient,
        borderRadius: FlowinRadii.card,
        boxShadow: FlowinShadows.primaryGlow,
      ),
      clipBehavior: Clip.antiAlias,
      child: LiquidWaveBackdrop(
        fillLevel: 0.36,
        waveAmplitude: 8,
        frontColor: FlowinColors.aquaBright.withValues(alpha: 0.18),
        backColor: FlowinColors.deepOcean.withValues(alpha: 0.25),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.65),
                    width: 2,
                  ),
                ),
                child: FlowinUserAvatar(
                  photoBytes: appState?.profilePhotoBytes,
                  size: 56,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FlowinTypography.titleLarge.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FlowinTypography.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: FlowinRadii.fullPill,
                      ),
                      child: Text(
                        activePlan != null
                            ? '${activePlan.title} Member'
                            : 'Flowin Member • Gold Tier',
                        style: FlowinTypography.overline.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (onEditPressed != null)
                Material(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onEditPressed,
                    child: const SizedBox(
                      width: 38,
                      height: 38,
                      child: Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
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
