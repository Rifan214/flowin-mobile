import 'package:flutter/material.dart';

import '../core/design_system/flowin_colors.dart';
import '../core/design_system/flowin_spacing.dart';
import '../core/design_system/flowin_typography.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title.toUpperCase(),
            style: FlowinTypography.overline.copyWith(
              color: FlowinColors.inkSecondary,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: FlowinColors.surface,
            borderRadius: FlowinRadii.card,
            boxShadow: FlowinShadows.cardSoft,
            border: Border.all(color: FlowinColors.border.withValues(alpha: 0.7)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: List.generate(children.length, (index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  children[index],
                  if (index < children.length - 1)
                    const Divider(height: 1, indent: 62, endIndent: 16),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
