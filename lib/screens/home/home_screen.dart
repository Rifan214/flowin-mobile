import 'package:flutter/material.dart';

import '../detail/product_detail_screen.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/dummy_products.dart';
import '../../widgets/filter_chip.dart';
import '../../widgets/product_card.dart';
import '../../widgets/search_box.dart';
import '../../widgets/subscription_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            16,
            20,
            100,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.menu),
                  ),
                  const Spacer(),
                  Text(
                    'Flowin',
                    style:
                        AppTextStyles.appBarTitle,
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

              const SizedBox(height: 20),

              Text(
                'Refreshing Morning!',
                style: AppTextStyles.greetingTitle,
              ),

              const SizedBox(height: 6),

              Text(
                'Ready for your daily hydration?',
                style:
                    AppTextStyles.greetingSubtitle,
              ),

              const SizedBox(height: 24),

              const SearchBox(),

              const SizedBox(height: 16),

              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChipWidget(
                      title: 'Price',
                      selected: true,
                    ),
                    SizedBox(width: 10),
                    FilterChipWidget(
                      title: 'Location',
                    ),
                    SizedBox(width: 10),
                    FilterChipWidget(
                      title: 'Rating',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: dummyProducts.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  mainAxisExtent: 320,
                ),
                itemBuilder: (context, index) {
                  return ProductCard(
                    product:
                        dummyProducts[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(
                            product: dummyProducts[index],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 24),

              const SubscriptionBanner(),
            ],
          ),
        ),
      ),
    );
  }
}