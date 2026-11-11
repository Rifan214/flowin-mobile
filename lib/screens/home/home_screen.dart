import 'package:flutter/material.dart';

import '../../core/animations/flowin_page_routes.dart';
import '../../core/animations/staggered_reveal.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../shared/widgets/flowin_button.dart';
import '../../state/flowin_app_state.dart';
import '../../widgets/filter_bottom_sheet.dart';
import '../../widgets/filter_chip.dart';
import '../../widgets/flowin_header.dart';
import '../../widgets/product_card.dart';
import '../../widgets/search_box.dart';
import '../../widgets/subscription_banner.dart';
import '../detail/product_detail_screen.dart';
import '../main_navigation_screen.dart';
import '../tracking/live_delivery_tracking_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = FlowinScope.of(context);
    final firstName = appState.userName.split(' ').first;
    final products = appState.filteredProducts;
    final hasInProgress =
        appState.orders.any((o) => o.status == 'In Progress');

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: FlowinHeader(showBrandLogo: true),
          ),

          // Hero Greeting & Active Delivery Strip
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            sliver: SliverToBoxAdapter(
              child: StaggeredReveal(
                index: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good Morning, $firstName',
                                style: FlowinTypography.headlineLarge.copyWith(
                                  fontSize: 23,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                    size: 14,
                                    color: FlowinColors.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      appState.deliveryTitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: FlowinTypography.caption.copyWith(
                                        color: FlowinColors.inkSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (hasInProgress)
                          Material(
                            color: FlowinColors.cyanMist,
                            borderRadius: FlowinRadii.fullPill,
                            child: InkWell(
                              borderRadius: FlowinRadii.fullPill,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  FlowinPageRoute.modalSlide(
                                    const LiveDeliveryTrackingScreen(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 7,
                                      height: 7,
                                      decoration: const BoxDecoration(
                                        color: FlowinColors.success,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Live Order',
                                      style: FlowinTypography.caption.copyWith(
                                        color: FlowinColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SearchBox(
                      query: appState.searchQuery,
                      hasActiveFilters: appState.hasActiveFilters,
                      onChanged: appState.setSearchQuery,
                      onFilterTap: () => _openFilterSheet(context),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Quick interactive filter strip
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
              child: Row(
                children: [
                  FilterChipWidget(
                    title: 'All',
                    icon: Icons.water_drop_outlined,
                    selected: !appState.hasActiveFilters,
                    onTap: appState.resetFilters,
                  ),
                  const SizedBox(width: 8),
                  for (final brand in ['Aqua', 'Vit', 'Pristine', 'Le Minerale']) ...[
                    FilterChipWidget(
                      title: brand,
                      selected: appState.selectedBrands.contains(brand),
                      onTap: () => appState.toggleQuickFilterBrand(brand),
                    ),
                    const SizedBox(width: 8),
                  ],
                  FilterChipWidget(
                    title: 'Low Price',
                    icon: Icons.arrow_downward_rounded,
                    selected:
                        appState.sortOption == ProductSortOption.priceLowToHigh,
                    onTap: () {
                      final next = appState.sortOption ==
                              ProductSortOption.priceLowToHigh
                          ? ProductSortOption.recommended
                          : ProductSortOption.priceLowToHigh;
                      appState.applyFilters(sortOption: next);
                    },
                  ),
                ],
              ),
            ),
          ),

          // Catalog heading
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Fresh Gallon Catalog',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FlowinTypography.titleLarge,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${products.length} items',
                    style: FlowinTypography.caption.copyWith(
                      color: FlowinColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Responsive Grid or Empty State
          if (products.isEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: FlowinColors.surface,
                    borderRadius: FlowinRadii.card,
                    border: Border.all(color: FlowinColors.border),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.search_off_rounded,
                        size: 40,
                        color: FlowinColors.inkMuted,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'No water gallons match your filters',
                        style: FlowinTypography.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Try clearing active brand or price filters.',
                        style: FlowinTypography.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      FlowinButton(
                        label: 'Reset Filters',
                        variant: FlowinButtonVariant.tinted,
                        expand: false,
                        height: 44,
                        onPressed: appState.resetFilters,
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.crossAxisExtent;
                  final crossAxisCount =
                      width >= 960 ? 4 : (width >= 600 ? 3 : 2);
                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      mainAxisExtent: 288,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = products[index];
                        return StaggeredReveal(
                          index: index,
                          child: ProductCard(
                            product: product,
                            onGoToCart: () =>
                                MainNavigationScreen.goToTab(context, 2),
                            onTap: () {
                              Navigator.push(
                                context,
                                FlowinPageRoute.fadeScale(
                                  ProductDetailScreen(product: product),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      childCount: products.length,
                    ),
                  );
                },
              ),
            ),

          // Subscription Spotlight Banner
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(
              20,
              22,
              20,
              FlowinSpacing.navBarClearance,
            ),
            sliver: SliverToBoxAdapter(
              child: SubscriptionBanner(),
            ),
          ),
        ],
      ),
    );
  }
}
