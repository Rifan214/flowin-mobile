import 'package:flutter/material.dart';
import 'dart:async';
import '../review/rating_review_screen.dart';
import '../../core/constants/app_colors.dart';

class LiveDeliveryTrackingScreen
    extends StatefulWidget {
  const LiveDeliveryTrackingScreen({
    super.key,
  });

  @override
  State<
      LiveDeliveryTrackingScreen>
      createState() =>
          _LiveDeliveryTrackingScreenState();
}

class _LiveDeliveryTrackingScreenState
    extends State<
        LiveDeliveryTrackingScreen> {
          @override
          void initState() {
            super.initState();

            Future.delayed(
              const Duration(seconds: 3),
              () {
                if (!mounted) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const RatingReviewScreen(),
                  ),
                );
              },
            );
          }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // MAP
          Positioned.fill(
            child: Image.asset(
              'assets/images/tracking_map.png',
              fit: BoxFit.cover,
            ),
          ),

          // HEADER
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Row(
                children: [
                  IconButton.filled(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                  ),

                  const Spacer(),

                  const Text(
                    'Live Tracking',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const Spacer(),

                  IconButton.filled(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.my_location,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // MAP CONTROLS
          Positioned(
            right: 20,
            top: 150,
            child: Column(
              children: [
                _mapButton(Icons.gps_fixed),
                const SizedBox(height: 12),
                _mapButton(Icons.add),
                const SizedBox(height: 12),
                _mapButton(Icons.remove),
              ],
            ),
          ),

          // STORE LABEL
          Positioned(
            left: 90,
            top: 220,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),
              child: const Text(
                'AQUAHUB #04',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ),

          // DRIVER MARKER
          Positioned(
            left: 180,
            top: 420,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color:
                    AppColors.primary.withOpacity(
                  0.15,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 46,
                  height: 46,
                  decoration:
                      const BoxDecoration(
                    color:
                        AppColors.primary,
                    shape:
                        BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_shipping,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // BOTTOM SHEET
          Align(
            alignment:
                Alignment.bottomCenter,
            child: Container(
              height: 430,
              padding:
                  const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(
                  top: Radius.circular(
                    30,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage:
                            const AssetImage(
                          'assets/images/driver.jpg',
                        ),
                      ),

                      const SizedBox(
                        width: 14,
                      ),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              'Alex Rivera',
                              style:
                                  TextStyle(
                                fontSize:
                                    20,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            SizedBox(
                              height: 4,
                            ),

                            Text(
                              '★ 4.9 (1.2k orders)',
                              style:
                                  TextStyle(
                                color:
                                    Colors
                                        .grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      CircleAvatar(
                        backgroundColor:
                            Colors.blue
                                .shade50,
                        child: const Icon(
                          Icons.message,
                          color:
                              AppColors.primary,
                        ),
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      CircleAvatar(
                        backgroundColor:
                            AppColors.primary,
                        child: const Icon(
                          Icons.call,
                          color:
                              Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Container(
                    padding:
                        const EdgeInsets.all(
                      18,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xFFF3F5F9,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'ESTIMATED ARRIVAL',
                                style:
                                    TextStyle(
                                  fontSize:
                                      12,
                                  color:
                                      Colors
                                          .grey,
                                ),
                              ),
                              SizedBox(
                                  height:
                                      8),
                              Text(
                                '12:45 PM',
                                style:
                                    TextStyle(
                                  fontSize:
                                      32,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                  color:
                                      AppColors
                                          .primary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'TIME REMAINING',
                                style:
                                    TextStyle(
                                  fontSize:
                                      12,
                                  color:
                                      Colors
                                          .grey,
                                ),
                              ),
                              SizedBox(
                                  height:
                                      8),
                              Text(
                                '~ 12 mins',
                                style:
                                    TextStyle(
                                  fontSize:
                                      24,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  Expanded(
                    child: ListView(
                      physics:
                          const NeverScrollableScrollPhysics(),
                      children: const [
                        _TrackingStep(
                          title:
                              'Order received',
                          time:
                              '11:50 AM',
                          active: true,
                        ),
                        _TrackingStep(
                          title:
                              'Driver picking up',
                          time:
                              '12:15 PM',
                          active: true,
                        ),
                        _TrackingStep(
                          title:
                              'Out for delivery',
                          time:
                              '12:30 PM',
                          active: true,
                        ),
                        _TrackingStep(
                          title:
                              'Arrived',
                          time:
                              'Estimated',
                          active: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _mapButton(
    IconData icon,
  ) {
    return Material(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(14),
      elevation: 4,
      child: InkWell(
        borderRadius:
            BorderRadius.circular(14),
        onTap: () {},
        child: SizedBox(
          width: 52,
          height: 52,
          child: Icon(icon),
        ),
      ),
    );
  }
}

class _TrackingStep extends StatelessWidget {
  final String title;
  final String time;
  final bool active;

  const _TrackingStep({
    required this.title,
    required this.time,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              active
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              color: active
                  ? AppColors.primary
                  : Colors.grey,
            ),
            Container(
              width: 2,
              height: 42,
              color: active
                  ? AppColors.primary
                  : Colors.grey.shade300,
            ),
          ],
        ),

        const SizedBox(width: 12),

        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight:
                    FontWeight.w600,
                fontSize: 18,
              ),
            ),
            Text(
              time,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}