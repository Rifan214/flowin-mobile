import 'package:flutter/material.dart';

import 'review_success_screen.dart';
import '../main_navigation_screen.dart';

class RatingReviewScreen extends StatefulWidget {
  const RatingReviewScreen({
    super.key,
  });

  @override
  State<RatingReviewScreen> createState() =>
      _RatingReviewScreenState();
}

class _RatingReviewScreenState
    extends State<RatingReviewScreen> {
  int driverRating = 4;
  int shopRating = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                        Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const MainNavigationScreen(),
                        ),
                        (route) => false,
                        );
                    },
                    icon: const Icon(Icons.close),
                    ),

                  const Spacer(),

                  const Text(
                    'Rate Delivery',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.help_outline,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage(
                  'assets/images/driver.jpg',
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'How was your order?',
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight:
                      FontWeight.bold,
                  color: Color(
                    0xFF1565C0,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Order #AQ-8829 delivered at 2:14 PM',
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 24),

              _ratingCard(
                title: 'Rate Driver',
                badge: 'Marcus',
                rating: driverRating,
                onRate: (value) {
                  setState(() {
                    driverRating = value;
                  });
                },
                tags: const [
                  'Fast Delivery',
                  'Polite Driver',
                  'Good Handling',
                ],
              ),

              const SizedBox(height: 18),

              _ratingCard(
                title: 'Rate Shop',
                badge:
                    'FLowin Central',
                rating: shopRating,
                onRate: (value) {
                  setState(() {
                    shopRating = value;
                  });
                },
                tags: const [
                  'Clean Bottle',
                  'Proper Seal',
                  'Correct Item',
                ],
              ),

              const SizedBox(height: 24),

              const Align(
                alignment:
                    Alignment.centerLeft,
                child: Text(
                  'Write a comment',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                maxLines: 5,
                decoration:
                    InputDecoration(
                  hintText:
                      'Share your experience here...',
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width:
                    double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const ReviewSuccessScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Submit Review',
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Your feedback helps us improve the Flowin experience for everyone.',
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ratingCard({
    required String title,
    required String badge,
    required int rating,
    required Function(int)
        onRate,
    required List<String> tags,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color: const Color(
            0xFFE0E5EF,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style:
                    const TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const Spacer(),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration:
                    BoxDecoration(
                  color: const Color(
                    0xFFF4E0D8,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    8,
                  ),
                ),
                child: Text(
                  badge,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children:
                List.generate(
              5,
              (index) =>
                  IconButton(
                onPressed: () =>
                    onRate(
                  index + 1,
                ),
                icon: Icon(
                  index < rating
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.orange,
                  size: 36,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: tags
                .map(
                  (tag) =>
                      OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      tag,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}