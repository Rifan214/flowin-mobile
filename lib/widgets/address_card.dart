import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(
              top: Radius.circular(18),
            ),
            child: Image.asset(
              'assets/images/map_preview.png',
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: const [
                Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  '4521 Waterbury Ave, Apartment 4B',
                ),

                SizedBox(height: 4),

                Text(
                  'San Francisco, CA 94107',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}