import 'package:flutter/material.dart';

import '../main_navigation_screen.dart';
import '../../core/constants/app_colors.dart';
import '../../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                  ),

                  const Spacer(),

                  const Text(
                    'Flowin',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_none,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: 320,
                          width: double.infinity,
                          child: Image.asset(
                            product.image,
                            fit: BoxFit.cover,
                          ),
                        ),

                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primary,
                              borderRadius:
                                  BorderRadius.circular(
                                20,
                              ),
                            ),
                            child: const Text(
                              'ECO-CERTIFIED',
                              style: TextStyle(
                                color:
                                    Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding:
                          const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  '${product.name} ${product.liters}L',
                                  style:
                                      const TextStyle(
                                    fontSize: 20,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),

                              Text(
                                'Rp ${formatPrice(product.price)}',
                                style:
                                    const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                  color:
                                      AppColors.primary,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            'MOUNTAIN SOURCED • PURIFIED',
                            style: TextStyle(
                              color:
                                  AppColors.primary,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 24),

                          Container(
                            padding:
                                const EdgeInsets.all(
                              16,
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),
                              border: Border.all(
                                color:
                                    AppColors.border,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'Quantity',
                                  style:
                                      TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),

                                const Spacer(),

                                CircleAvatar(
                                  backgroundColor:
                                      Colors.grey
                                          .shade100,
                                  child: const Icon(
                                    Icons.remove,
                                  ),
                                ),

                                const SizedBox(
                                  width: 20,
                                ),

                                const Text(
                                  '1',
                                  style:
                                      TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(
                                  width: 20,
                                ),

                                CircleAvatar(
                                  backgroundColor:
                                      Colors.grey
                                          .shade100,
                                  child: const Icon(
                                    Icons.add,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child:
                                    _featureCard(
                                  Icons.water_drop,
                                  'Mineral Rich',
                                  'Natural pH balance for optimal hydration.',
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child:
                                    _featureCard(
                                  Icons.verified,
                                  'Source Tracked',
                                  'Sourced from trusted natural springs.',
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            product.description,
                            style:
                                const TextStyle(
                              height: 1.6,
                            ),
                          ),

                          const SizedBox(height: 18),

                          const Column(
                            children: [
                              _Bullet(
                                text:
                                    'Ozone-treated for maximum purity',
                              ),
                              _Bullet(
                                text:
                                    'UV-C Sterilization technology',
                              ),
                              _Bullet(
                                text:
                                    'Same-day delivery available',
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          const Text(
                            'You might also need',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child:
                                    _suggestionCard(
                                  'Electric Pump',
                                  'Rp 125.000',
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child:
                                    _suggestionCard(
                                  'Glass Set',
                                  'Rp 89.000',
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

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color:
                        Colors.grey.shade300,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                            'Produk berhasil ditambahkan ke keranjang',
                            ),
                            duration: Duration(seconds: 1),
                        ),
                        );

                        await Future.delayed(
                        const Duration(seconds: 1),
                        );

                        if (!context.mounted) return;

                        Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MainNavigationScreen(
                            initialIndex: 2,
                            ),
                        ),
                        (route) => false,
                        );
                    },
                      icon: const Icon(
                        Icons.shopping_cart,
                      ),
                      label: const Text(
                        'Add to Cart',
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  IconButton.filledTonal(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite_border,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _featureCard(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          Text(subtitle),
        ],
      ),
    );
  }

  static Widget _suggestionCard(
    String name,
    String price,
  ) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color:
                  Colors.grey.shade200,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;

  const _Bullet({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColors.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}