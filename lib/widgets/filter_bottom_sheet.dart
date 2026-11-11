import 'package:flutter/material.dart';

import '../core/design_system/flowin_colors.dart';
import '../core/design_system/flowin_spacing.dart';
import '../core/design_system/flowin_typography.dart';
import '../shared/widgets/flowin_button.dart';
import '../shared/widgets/flowin_toast.dart';
import '../state/flowin_app_state.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  static const List<String> _brands = ['Aqua', 'Vit', 'Pristine', 'Le Minerale'];
  static const List<int?> _volumes = [null, 19, 15];

  late Set<String> _brandsSelected;
  int? _litersSelected;
  late double _maxPrice;
  late ProductSortOption _sortOption;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final appState = FlowinScope.read(context);
      _brandsSelected = Set<String>.from(appState.selectedBrands);
      _litersSelected = appState.selectedLiters;
      _maxPrice = appState.maxPrice;
      _sortOption = appState.sortOption;
      _initialized = true;
    }
  }

  void _resetLocal() {
    setState(() {
      _brandsSelected.clear();
      _litersSelected = null;
      _maxPrice = 100000;
      _sortOption = ProductSortOption.recommended;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = FlowinScope.read(context);

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: FlowinColors.border,
                  borderRadius: FlowinRadii.fullPill,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Refine Catalog', style: FlowinTypography.headlineMedium),
                TextButton(
                  onPressed: _resetLocal,
                  child: Text(
                    'Reset All',
                    style: FlowinTypography.titleMedium.copyWith(
                      color: FlowinColors.primary,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text('Water Brand', style: FlowinTypography.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _brands.map((brand) {
                final active = _brandsSelected.contains(brand);
                return FilterChip(
                  label: Text(brand),
                  selected: active,
                  selectedColor: FlowinColors.cyanMist,
                  checkmarkColor: FlowinColors.primary,
                  side: BorderSide(
                    color: active ? FlowinColors.primary : FlowinColors.border,
                  ),
                  labelStyle: FlowinTypography.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: active ? FlowinColors.primary : FlowinColors.ink,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _brandsSelected.add(brand);
                      } else {
                        _brandsSelected.remove(brand);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            Text('Bottle Volume', style: FlowinTypography.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: _volumes.map((liters) {
                final active = _litersSelected == liters;
                final label = liters == null ? 'All Sizes' : '$liters Liters';
                return ChoiceChip(
                  label: Text(label),
                  selected: active,
                  selectedColor: FlowinColors.cyanMist,
                  side: BorderSide(
                    color: active ? FlowinColors.primary : FlowinColors.border,
                  ),
                  labelStyle: FlowinTypography.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: active ? FlowinColors.primary : FlowinColors.ink,
                  ),
                  onSelected: (_) => setState(() => _litersSelected = liters),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Max Price', style: FlowinTypography.titleMedium),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: FlowinColors.cyanMist,
                    borderRadius: FlowinRadii.fullPill,
                  ),
                  child: Text(
                    FlowinFormat.currency(_maxPrice),
                    style: FlowinTypography.priceMedium.copyWith(fontSize: 13),
                  ),
                ),
              ],
            ),
            Slider(
              value: _maxPrice.clamp(50000, 100000),
              min: 50000,
              max: 100000,
              divisions: 10,
              activeColor: FlowinColors.primary,
              onChanged: (v) => setState(() => _maxPrice = v),
            ),
            const SizedBox(height: 14),

            Text('Sort By', style: FlowinTypography.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                (ProductSortOption.recommended, 'Recommended'),
                (ProductSortOption.priceLowToHigh, 'Lowest Price'),
                (ProductSortOption.priceHighToLow, 'Highest Price'),
                (ProductSortOption.volume, 'Largest Volume'),
              ].map((entry) {
                final active = _sortOption == entry.$1;
                return ChoiceChip(
                  label: Text(entry.$2),
                  selected: active,
                  selectedColor: FlowinColors.cyanMist,
                  side: BorderSide(
                    color: active ? FlowinColors.primary : FlowinColors.border,
                  ),
                  labelStyle: FlowinTypography.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: active ? FlowinColors.primary : FlowinColors.ink,
                  ),
                  onSelected: (_) => setState(() => _sortOption = entry.$1),
                );
              }).toList(),
            ),
            const SizedBox(height: 22),

            FlowinButton(
              label: 'Apply Filters',
              icon: Icons.check_rounded,
              onPressed: () {
                appState.applyFilters(
                  brands: _brandsSelected,
                  liters: _litersSelected,
                  clearLiters: _litersSelected == null,
                  maxPrice: _maxPrice,
                  sortOption: _sortOption,
                );
                Navigator.pop(context);
                FlowinToast.show(
                  context,
                  title: 'Filters Updated',
                  message:
                      'Showing ${appState.filteredProducts.length} matching products',
                  type: FlowinToastType.info,
                  duration: const Duration(milliseconds: 1800),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
