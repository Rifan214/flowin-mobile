import 'package:flutter/material.dart';

import '../core/animations/app_haptics.dart';
import '../core/design_system/flowin_colors.dart';
import '../core/design_system/flowin_spacing.dart';
import '../core/design_system/flowin_typography.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    required this.title,
    required this.address,
    this.onEditPressed,
  });

  final String title;
  final String address;
  final VoidCallback? onEditPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: FlowinColors.surface,
        borderRadius: FlowinRadii.card,
        boxShadow: FlowinShadows.cardSoft,
        border: Border.all(color: FlowinColors.border.withValues(alpha: 0.8)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: FlowinColors.mistSurfaceGradient,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: FlowinColors.cyanMist),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(painter: _MiniMapGridPainter()),
                Center(
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: FlowinColors.oceanGradient,
                      shape: BoxShape.circle,
                      boxShadow: FlowinShadows.primaryGlow,
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: FlowinTypography.titleMedium.copyWith(fontSize: 14.5),
                ),
                const SizedBox(height: 3),
                Text(
                  address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: FlowinTypography.caption,
                ),
              ],
            ),
          ),
          if (onEditPressed != null)
            TextButton(
              onPressed: () {
                AppHaptics.light();
                onEditPressed!();
              },
              child: Text(
                'Edit',
                style: FlowinTypography.titleMedium.copyWith(
                  color: FlowinColors.primary,
                  fontSize: 13.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MiniMapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final street = Paint()
      ..color = Colors.white.withValues(alpha: 0.78)
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height * 0.34),
      Offset(size.width, size.height * 0.24),
      street,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.74),
      Offset(size.width, size.height * 0.66),
      street,
    );
    canvas.drawLine(
      Offset(size.width * 0.30, 0),
      Offset(size.width * 0.42, size.height),
      street,
    );
    canvas.drawLine(
      Offset(size.width * 0.76, 0),
      Offset(size.width * 0.68, size.height),
      street,
    );
  }

  @override
  bool shouldRepaint(covariant _MiniMapGridPainter oldDelegate) => false;
}
