import 'package:flutter/material.dart';

import '../../core/animations/app_haptics.dart';
import '../../core/animations/flowin_page_routes.dart';
import '../../core/animations/staggered_reveal.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../models/product.dart';
import '../../shared/widgets/flowin_button.dart';
import '../../shared/widgets/flowin_favorite_button.dart';
import '../../shared/widgets/flowin_toast.dart';
import '../../shared/widgets/hydration_product_stage.dart';
import '../../shared/widgets/organic_wave_clipper.dart';
import '../../state/flowin_app_state.dart';
import '../../widgets/flowin_header.dart';
import '../main_navigation_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final appState = FlowinScope.of(context);
    final isFav = appState.isFavorite(widget.product.name);
    final recommendations = appState.catalog
        .where((p) => p.name != widget.product.name)
        .take(3)
        .toList();
    final lineTotal = widget.product.price * _quantity;

    return Scaffold(
      backgroundColor: FlowinColors.background,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Wonderous layered coastal arch backdrop + Hero gallery stage
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipPath(
                        clipper: const OrganicWaveClipper(waveDepth: 28),
                        child: Container(
                          height: 350,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: FlowinColors.mistSurfaceGradient,
                          ),
                        ),
                      ),
                      SafeArea(
                        bottom: false,
                        child: Column(
                          children: [
                            FlowinHeader(
                              title: 'Product Details',
                              actions: [
                                FlowinFavoriteButton(
                                  isFavorite: isFav,
                                  size: 42,
                                  iconSize: 20,
                                  backgroundColor: FlowinColors.surface,
                                  borderColor: FlowinColors.border,
                                  boxShadow: FlowinShadows.cardSoft,
                                  inactiveColor: FlowinColors.ink,
                                  onPressed: () {
                                    final added = appState.toggleFavorite(
                                      widget.product.name,
                                    );
                                    FlowinToast.show(
                                      context,
                                      title: added
                                          ? 'Saved to Favorites'
                                          : 'Removed from Favorites',
                                      message: widget.product.name,
                                      type: FlowinToastType.info,
                                    );
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(32, 6, 32, 22),
                              child: SizedBox(
                                height: 228,
                                width: double.infinity,
                                child: HydrationProductStage(
                                  imagePath: widget.product.image,
                                  heroTag: 'product_${widget.product.name}',
                                  borderRadius: 26,
                                  padding: const EdgeInsets.all(16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge + Rating Row
                        StaggeredReveal(
                          index: 0,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: FlowinColors.cyanMist,
                                  borderRadius: FlowinRadii.fullPill,
                                ),
                                child: Text(
                                  widget.product.tag.toUpperCase(),
                                  style: FlowinTypography.overline.copyWith(
                                    fontSize: 10.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: FlowinColors.amberSoft,
                                  borderRadius: FlowinRadii.fullPill,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      size: 14,
                                      color: FlowinColors.amber,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '4.9 (240+)',
                                      style: FlowinTypography.caption.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: FlowinColors.ink,
                                        fontSize: 11.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Product Title & Unit Price
                        StaggeredReveal(
                          index: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.product.name,
                                      style: FlowinTypography.headlineLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${widget.product.type} • ${widget.product.liters}L Sanitized Gallon',
                                      style: FlowinTypography.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    FlowinFormat.currency(widget.product.price),
                                    style: FlowinTypography.priceLarge,
                                  ),
                                  Text(
                                    'per gallon',
                                    style: FlowinTypography.caption,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Staggered Mineral Spec Callouts
                        StaggeredReveal(
                          index: 2,
                          child: Row(
                            children: [
                              Expanded(
                                child: _SpecCard(
                                  icon: Icons.water_drop_rounded,
                                  label: 'Volume',
                                  value: '${widget.product.liters} Liters',
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: _SpecCard(
                                  icon: Icons.science_outlined,
                                  label: 'Purity',
                                  value: 'pH 7.8+',
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: _SpecCard(
                                  icon: Icons.bolt_rounded,
                                  label: 'Delivery',
                                  value: '< 45 min',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),

                        // Description & Highlights
                        StaggeredReveal(
                          index: 3,
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: FlowinColors.surface,
                              borderRadius: FlowinRadii.card,
                              boxShadow: FlowinShadows.cardSoft,
                              border: Border.all(
                                color: FlowinColors.border.withValues(alpha: 0.7),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'About This Source',
                                  style: FlowinTypography.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.product.description,
                                  style: FlowinTypography.bodyMedium.copyWith(
                                    height: 1.55,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                const _CheckHighlight(
                                  text: 'Multi-stage UV + Ozone sterilized bottle loop',
                                ),
                                const _CheckHighlight(
                                  text: 'BPA-free food-grade sealed polycarbonate gallon',
                                ),
                                const _CheckHighlight(
                                  text: 'Balanced natural electrolytes for daily hydration',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),

                        // Interactive Complementary Refill Pairings
                        if (recommendations.isNotEmpty) ...[
                          Text(
                            'You Might Also Need',
                            style: FlowinTypography.titleLarge,
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 132,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: recommendations.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, idx) {
                                final alt = recommendations[idx];
                                return _RecommendationTile(
                                  product: alt,
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      FlowinPageRoute.fadeScale(
                                        ProductDetailScreen(product: alt),
                                      ),
                                    );
                                  },
                                  onQuickAdd: () {
                                    AppHaptics.medium();
                                    appState.addProductToCart(alt);
                                    FlowinToast.show(
                                      context,
                                      title: 'Added ${alt.name}',
                                      message: 'Included in your basket.',
                                      type: FlowinToastType.success,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sticky Bottom Quantity & Add-to-Cart Dock
          Container(
            padding: EdgeInsets.fromLTRB(
              20,
              14,
              20,
              MediaQuery.paddingOf(context).bottom > 0
                  ? MediaQuery.paddingOf(context).bottom + 10
                  : 16,
            ),
            decoration: BoxDecoration(
              color: FlowinColors.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: FlowinShadows.floatingNav,
              border: Border(top: BorderSide(color: FlowinColors.border)),
            ),
            child: Row(
              children: [
                // Interactive Quantity Stepper
                Container(
                  height: 54,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: FlowinColors.surfaceSubtle,
                    borderRadius: FlowinRadii.button,
                    border: Border.all(color: FlowinColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: _quantity > 1
                            ? () {
                                AppHaptics.selection();
                                setState(() => _quantity--);
                              }
                            : null,
                        icon: const Icon(Icons.remove_rounded, size: 19),
                        color: FlowinColors.ink,
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 160),
                        transitionBuilder: (c, a) =>
                            ScaleTransition(scale: a, child: c),
                        child: Text(
                          '$_quantity',
                          key: ValueKey(_quantity),
                          style: FlowinTypography.titleLarge,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          AppHaptics.selection();
                          setState(() => _quantity++);
                        },
                        icon: const Icon(Icons.add_rounded, size: 19),
                        color: FlowinColors.primary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FlowinButton(
                    label: 'Add to Cart',
                    icon: Icons.shopping_bag_outlined,
                    onPressed: () {
                      AppHaptics.confirm();
                      appState.addProductToCart(
                        widget.product,
                        quantity: _quantity,
                      );
                      FlowinToast.show(
                        context,
                        title: 'Added to Cart',
                        message:
                            '${_quantity}x ${widget.product.name} (${FlowinFormat.currency(lineTotal)})',
                        type: FlowinToastType.success,
                      );
                      MainNavigationScreen.goToTab(context, 2);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecCard extends StatelessWidget {
  const _SpecCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: FlowinColors.surface,
        borderRadius: FlowinRadii.innerCard,
        boxShadow: FlowinShadows.cardSoft,
        border: Border.all(color: FlowinColors.border.withValues(alpha: 0.7)),
      ),
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: FlowinColors.cyanMist,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: FlowinColors.primary),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FlowinTypography.titleMedium.copyWith(fontSize: 13.5),
          ),
          Text(
            label,
            style: FlowinTypography.caption.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _CheckHighlight extends StatelessWidget {
  const _CheckHighlight({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.check_circle_rounded,
              size: 16,
              color: FlowinColors.success,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: FlowinTypography.bodyMedium.copyWith(
                color: FlowinColors.ink,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationTile extends StatelessWidget {
  const _RecommendationTile({
    required this.product,
    required this.onTap,
    required this.onQuickAdd,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onQuickAdd;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FlowinColors.surface,
      borderRadius: FlowinRadii.card,
      child: InkWell(
        borderRadius: FlowinRadii.card,
        onTap: onTap,
        child: Container(
          width: 224,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: FlowinRadii.card,
            boxShadow: FlowinShadows.cardSoft,
            border: Border.all(
              color: FlowinColors.border.withValues(alpha: 0.7),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 72,
                height: 100,
                child: HydrationProductStage(
                  imagePath: product.image,
                  borderRadius: 12,
                  padding: const EdgeInsets.all(6),
                  showShadowPedestal: false,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FlowinTypography.titleMedium.copyWith(
                        fontSize: 13.5,
                      ),
                    ),
                    Text(
                      '${product.liters}L • ${product.type}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FlowinTypography.caption.copyWith(fontSize: 11),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            FlowinFormat.currency(product.price),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: FlowinTypography.priceMedium.copyWith(
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: onQuickAdd,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: FlowinColors.cyanMist,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              size: 16,
                              color: FlowinColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
