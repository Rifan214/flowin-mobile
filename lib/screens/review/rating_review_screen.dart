import 'package:flutter/material.dart';

import '../../core/animations/app_haptics.dart';
import '../../core/animations/flowin_page_routes.dart';
import '../../core/animations/motion_state_scenes.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_motion.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../shared/widgets/flowin_button.dart';
import '../../shared/widgets/flowin_text_field.dart';
import '../../shared/widgets/flowin_toast.dart';
import '../../widgets/flowin_header.dart';
import 'review_success_screen.dart';

class RatingReviewScreen extends StatefulWidget {
  const RatingReviewScreen({super.key});

  @override
  State<RatingReviewScreen> createState() => _RatingReviewScreenState();
}

class _RatingReviewScreenState extends State<RatingReviewScreen> {
  static const List<String> _tags = [
    'On-Time Arrival',
    'Friendly Courier',
    'Clean Sealed Gallon',
    'Zero Spills',
    'Smooth Bottle Swap',
  ];

  int _rating = 5;
  final Set<String> _selectedTags = {'On-Time Arrival', 'Clean Sealed Gallon'};
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String get _moodCaption => switch (_rating) {
        5 => 'Crystal Clear Experience!',
        4 => 'Great Refreshing Delivery',
        3 => 'Good, Can Be Faster',
        2 => 'Needs Attention',
        _ => 'Tell Us How to Improve',
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlowinColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const FlowinHeader(
              title: 'Rate Delivery',
              rightIcon: SizedBox(width: 42),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                child: Column(
                  children: [
                    // Interactive Rive-style Mood-Morphing Droplet Companion
                    HydrationRatingCompanion(rating: _rating, size: 110),
                    const SizedBox(height: 10),
                    AnimatedSwitcher(
                      duration: FlowinMotion.resolve(
                        context,
                        FlowinDurations.fast,
                      ),
                      child: Text(
                        _moodCaption,
                        key: ValueKey(_rating),
                        style: FlowinTypography.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Delivered by Alex Rivera from Flowin Central Depot',
                      style: FlowinTypography.caption,
                    ),
                    const SizedBox(height: 18),

                    // Elastic Animated 5-Star Selector
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: FlowinColors.surface,
                        borderRadius: FlowinRadii.card,
                        boxShadow: FlowinShadows.cardSoft,
                        border: Border.all(color: FlowinColors.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(5, (i) {
                          final starValue = i + 1;
                          final active = starValue <= _rating;
                          return GestureDetector(
                            onTap: () {
                              AppHaptics.selection();
                              setState(() => _rating = starValue);
                            },
                            child: AnimatedScale(
                              scale: active ? 1.15 : 0.92,
                              duration: const Duration(milliseconds: 180),
                              curve: FlowinCurves.spring,
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  active
                                      ? Icons.star_rounded
                                      : Icons.star_outline_rounded,
                                  size: 38,
                                  color: active
                                      ? FlowinColors.amber
                                      : FlowinColors.inkMuted,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Interactive Toggleable Highlights
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'What went well?',
                        style: FlowinTypography.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _tags.map((tag) {
                        final selected = _selectedTags.contains(tag);
                        return FilterChip(
                          label: Text(tag),
                          selected: selected,
                          selectedColor: FlowinColors.cyanMist,
                          checkmarkColor: FlowinColors.primary,
                          side: BorderSide(
                            color: selected
                                ? FlowinColors.primary
                                : FlowinColors.border,
                          ),
                          labelStyle: FlowinTypography.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? FlowinColors.primary
                                : FlowinColors.ink,
                          ),
                          onSelected: (value) {
                            AppHaptics.selection();
                            setState(() {
                              if (value) {
                                _selectedTags.add(tag);
                              } else {
                                _selectedTags.remove(tag);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    FlowinTextField(
                      label: 'Additional Notes (Optional)',
                      hint: 'Share how Alex handled your gallon drop...',
                      controller: _commentController,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
              child: FlowinButton(
                label: 'Submit Review',
                trailingIcon: Icons.send_rounded,
                onPressed: () {
                  if (_rating < 1) {
                    FlowinToast.show(
                      context,
                      title: 'Select a Rating',
                      message: 'Tap a star rating above before submitting.',
                      type: FlowinToastType.warning,
                    );
                    return;
                  }
                  Navigator.pushReplacement(
                    context,
                    FlowinPageRoute.fadeScale(const ReviewSuccessScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
