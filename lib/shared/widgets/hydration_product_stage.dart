import 'package:flutter/material.dart';

import '../../core/design_system/flowin_colors.dart';

/// Layered studio pedestal with `Hero` support and `BoxFit.contain` so white-backed
/// water gallon product images blend smoothly into Flowin's mineral surface without clipping.
class HydrationProductStage extends StatelessWidget {
  const HydrationProductStage({
    super.key,
    required this.imagePath,
    this.heroTag,
    this.borderRadius = 18,
    this.padding = const EdgeInsets.all(10),
    this.showShadowPedestal = true,
  });

  final String imagePath;
  final String? heroTag;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final bool showShadowPedestal;

  @override
  Widget build(BuildContext context) {
    final image = Container(
      decoration: BoxDecoration(
        gradient: FlowinColors.productStageGradient,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (showShadowPedestal)
            Positioned(
              bottom: 10,
              child: Container(
                width: 68,
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  boxShadow: [
                    BoxShadow(
                      color: FlowinColors.primary.withValues(alpha: 0.14),
                      blurRadius: 14,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: padding,
            child: ClipRRect(
              borderRadius: BorderRadius.circular((borderRadius - 6).clamp(6, 24)),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.water_drop_rounded,
                  size: 42,
                  color: FlowinColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (heroTag == null) return image;
    return Hero(
      tag: heroTag!,
      child: Material(
        color: Colors.transparent,
        child: image,
      ),
    );
  }
}

