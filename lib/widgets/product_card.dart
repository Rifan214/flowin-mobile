import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  String formatPrice(int price) {
    return price
        .toString()
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE SECTION
            Stack(
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    product.image,
                    fit: BoxFit.contain,
                  ),
                ),

                if (product.tag.isNotEmpty)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: product.tag == 'BEST SELLER'
                            ? Colors.orange
                            : AppColors.primary,
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                      child: Text(
                        product.tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  12,
                  0,
                  12,
                  12,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          AppTextStyles.productTitle,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${product.liters} Liters • ${product.type}',
                      style: AppTextStyles
                          .productSubtitle,
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'PRICE',
                      style:
                          AppTextStyles.priceLabel,
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'RP. ${formatPrice(product.price)}',
                            style: AppTextStyles
                                .productPrice,
                          ),
                        ),

                        Container(
                          width: 42,
                          height: 42,
                          decoration:
                              const BoxDecoration(
                            color:
                                AppColors.primary,
                            shape:
                                BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: 20,
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
    );
  }
}