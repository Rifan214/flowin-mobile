import 'package:flutter/material.dart';

import '../core/animations/app_haptics.dart';
import '../core/design_system/flowin_colors.dart';
import '../core/design_system/flowin_motion.dart';
import '../core/design_system/flowin_spacing.dart';
import '../core/design_system/flowin_typography.dart';
import '../models/product.dart';
import '../shared/widgets/flowin_toast.dart';
import '../shared/widgets/hydration_product_stage.dart';
import '../state/flowin_app_state.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onGoToCart,
  });

  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onGoToCart;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final appState =
        context.dependOnInheritedWidgetOfExactType<FlowinScope>()?.notifier;
    final isFav = appState?.isFavorite(widget.product.name) ?? false;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        AppHaptics.light();
        widget.onTap?.call();
      },
      child: AnimatedScale(
        scale: FlowinMotion.isReduced(context)
            ? 1.0
            : (_pressed ? 0.97 : 1.0),
        duration: const Duration(milliseconds: 110),
        child: Container(
          decoration: BoxDecoration(
            color: FlowinColors.surface,
            borderRadius: FlowinRadii.card,
            boxShadow: FlowinShadows.cardSoft,
            border: Border.all(
              color: FlowinColors.border.withValues(alpha: 0.7),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upper Product Studio Stage + floating badges
              Expanded(
                flex: 6,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
                      child: HydrationProductStage(
                        imagePath: widget.product.image,
                        heroTag: 'product_${widget.product.name}',
                        borderRadius: 16,
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: FlowinColors.ink.withValues(alpha: 0.78),
                          borderRadius: FlowinRadii.fullPill,
                        ),
                        child: Text(
                          '${widget.product.liters}L',
                          style: FlowinTypography.overline.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 14,
                      right: 14,
                      child: Material(
                        color: Colors.white.withValues(alpha: 0.92),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            if (appState == null) return;
                            AppHaptics.selection();
                            final added =
                                appState.toggleFavorite(widget.product.name);
                            FlowinToast.show(
                              context,
                              title: added
                                  ? 'Saved to Favorites'
                                  : 'Removed from Favorites',
                              message: widget.product.name,
                              type: FlowinToastType.info,
                              duration: const Duration(milliseconds: 1600),
                            );
                          },
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, anim) =>
                                  ScaleTransition(scale: anim, child: child),
                              child: Icon(
                                isFav
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                key: ValueKey(isFav),
                                size: 16,
                                color: isFav
                                    ? FlowinColors.danger
                                    : FlowinColors.inkSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Details & Inline Add Action
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.product.tag.trim().isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: FlowinColors.cyanMist,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.product.tag,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: FlowinTypography.overline.copyWith(
                              fontSize: 9.5,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],
                      Text(
                        widget.product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FlowinTypography.titleMedium.copyWith(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.product.type,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FlowinTypography.caption.copyWith(fontSize: 11.5),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              FlowinFormat.currency(widget.product.price),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: FlowinTypography.priceMedium.copyWith(
                                fontSize: 15.5,
                              ),
                            ),
                          ),
                          Material(
                            color: FlowinColors.primary,
                            borderRadius: BorderRadius.circular(11),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(11),
                              onTap: () {
                                if (appState == null) return;
                                AppHaptics.medium();
                                appState.addProductToCart(widget.product);
                                FlowinToast.show(
                                  context,
                                  title: 'Added to Cart',
                                  message: '${widget.product.name} (+1)',
                                  type: FlowinToastType.success,
                                  actionLabel: widget.onGoToCart != null
                                      ? 'Cart'
                                      : null,
                                  onAction: widget.onGoToCart,
                                );
                              },
                              child: const SizedBox(
                                width: 34,
                                height: 34,
                                child: Icon(
                                  Icons.add_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
