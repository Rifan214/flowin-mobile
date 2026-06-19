import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() =>
      _FilterBottomSheetState();
}

class _FilterBottomSheetState
    extends State<FilterBottomSheet> {
  double price = 6;

  int selectedSort = 0;

  int selectedType = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        24,
        12,
        24,
        24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius:
                    BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              const Text(
                'Filter Search',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              TextButton(
                onPressed: () {
                  setState(() {
                    price = 6;
                    selectedSort = 0;
                    selectedType = 0;
                  });
                },
                child: const Text('Reset'),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            'SORT BY',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _sortChip('Nearest', 0),
              _sortChip('Lowest Price', 1),
              _sortChip('Highest Rating', 2),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              const Text(
                'PRICE RANGE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              Text(
                '\$0.50 - \$${price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          Slider(
            value: price,
            min: 0.5,
            max: 12,
            activeColor: AppColors.primary,
            onChanged: (value) {
              setState(() {
                price = value;
              });
            },
          ),

          const SizedBox(height: 12),

          const Text(
            'WATER TYPE',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _typeCard(
                  icon: Icons.water_drop,
                  title: 'Mineral',
                  index: 0,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _typeCard(
                  icon: Icons.science,
                  title: 'Distilled',
                  index: 1,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _typeCard(
                  icon: Icons.eco,
                  title: 'Alkaline',
                  index: 2,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Divider(
            color: Colors.grey.shade300,
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.tune),
              label: const Text(
                'Apply Filters',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sortChip(
    String title,
    int index,
  ) {
    final selected =
        selectedSort == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSort = index;
        });
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : const Color(0xFFE9EEF6),
          borderRadius:
              BorderRadius.circular(14),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected
                ? Colors.white
                : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _typeCard({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final selected =
        selectedType == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = index;
        });
      },
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected
                  ? AppColors.primary
                  : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
}