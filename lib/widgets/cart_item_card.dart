import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/cart_item.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;

  const CartItemCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(12),
            child: Image.asset(
              item.image,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.delete_outline,
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  item.description,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color:
                            AppColors.primary,
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    Container(
                      decoration:
                          BoxDecoration(
                        color:
                            const Color(
                          0xFFF3F5F9,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon:
                                const Icon(
                              Icons.remove,
                              color:
                                  AppColors
                                      .primary,
                            ),
                          ),

                          Text(
                            '${item.quantity}',
                            style:
                                const TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          IconButton(
                            onPressed: () {},
                            icon:
                                const Icon(
                              Icons.add,
                              color:
                                  AppColors
                                      .primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}