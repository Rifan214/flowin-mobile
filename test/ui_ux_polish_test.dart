import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flowin/screens/auth/register_screen.dart';
import 'package:flowin/screens/cart/cart_screen.dart';
import 'package:flowin/screens/checkout/checkout_screen.dart';
import 'package:flowin/screens/detail/product_detail_screen.dart';
import 'package:flowin/screens/home/home_screen.dart';
import 'package:flowin/screens/main_navigation_screen.dart';
import 'package:flowin/screens/notification/notification_screen.dart';
import 'package:flowin/screens/orders/orders_screen.dart';
import 'package:flowin/screens/payment/payment_confirmation_screen.dart';
import 'package:flowin/screens/profile/profile_screen.dart';
import 'package:flowin/screens/review/rating_review_screen.dart';
import 'package:flowin/screens/review/review_success_screen.dart';
import 'package:flowin/screens/tracking/live_delivery_tracking_screen.dart';
import 'package:flowin/shared/widgets/flowin_favorite_button.dart';
import 'package:flowin/shared/widgets/flowin_fluid_nav_bar.dart';
import 'package:flowin/shared/widgets/flowin_toast.dart';
import 'package:flowin/state/flowin_app_state.dart';
import 'package:flowin/widgets/flowin_header.dart';
import 'package:flowin/widgets/product_card.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  tearDown(() {
    FlowinToast.dismiss();
  });

  Widget wrapApp(
    FlowinAppState state,
    Widget home, {
    bool disableAnimations = false,
    Key? appKey,
  }) {
    final app = FlowinScope(
      state: state,
      child: MaterialApp(
        key: appKey ?? ValueKey('${home.runtimeType}_${home.hashCode}'),
        home: home,
      ),
    );
    if (!disableAnimations) return app;
    return MediaQuery(
      data: const MediaQueryData(disableAnimations: true),
      child: app,
    );
  }

  Future<void> setViewport(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> pumpTransition(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
  }

  group('Shared Header & Scroll Consistency', () {
    for (final size in const [Size(360, 800), Size(390, 844), Size(1280, 800)]) {
      testWidgets(
        'Home header stays pinned on scroll without overflow at ${size.width.toInt()}dp',
        (tester) async {
          await setViewport(tester, size);
          final state = FlowinAppState();
          await tester.pumpWidget(
            wrapApp(state, const MainNavigationScreen()),
          );
          await pumpTransition(tester);

          final headerFinder = find.descendant(
            of: find.byType(HomeScreen),
            matching: find.byType(FlowinHeader),
          );
          final notifFinder = find.descendant(
            of: headerFinder,
            matching: find.byIcon(Icons.notifications_none_rounded),
          );
          expect(headerFinder, findsOneWidget);
          expect(notifFinder, findsOneWidget);

          final beforeHeaderTop = tester.getTopLeft(headerFinder).dy;
          final beforeNotifTop = tester.getTopLeft(notifFinder).dy;
          final beforeGreetingTop =
              tester.getTopLeft(find.textContaining('Good Morning')).dy;

          await tester.drag(
            find.descendant(
              of: find.byType(HomeScreen),
              matching: find.byType(CustomScrollView),
            ),
            const Offset(0, -100),
          );
          await tester.pump(const Duration(milliseconds: 250));

          expect(tester.getTopLeft(headerFinder).dy, beforeHeaderTop);
          expect(tester.getTopLeft(notifFinder).dy, beforeNotifTop);
          expect(
            tester.getTopLeft(find.textContaining('Good Morning')).dy,
            lessThan(beforeGreetingTop),
          );
          expect(tester.takeException(), isNull);

          // Tapping pinned Notification opens NotificationScreen
          await tester.tap(notifFinder);
          await pumpTransition(tester);
          expect(find.byType(NotificationScreen), findsOneWidget);
        },
      );
    }

    testWidgets(
      'Primary tabs share FlowinHeader with Notification; Cart Clear sits in content area',
      (tester) async {
        await setViewport(tester, const Size(390, 844));
        final state = FlowinAppState();
        await tester.pumpWidget(wrapApp(state, const MainNavigationScreen()));
        await pumpTransition(tester);

        // Orders tab
        await tester.tap(find.text('Orders').last);
        await pumpTransition(tester);
        final ordersHeader = find.descendant(
          of: find.byType(OrdersScreen),
          matching: find.byType(FlowinHeader),
        );
        expect(
          find.descendant(
            of: ordersHeader,
            matching: find.byIcon(Icons.notifications_none_rounded),
          ),
          findsOneWidget,
        );

        // Cart tab
        await tester.tap(find.text('Cart').last);
        await pumpTransition(tester);
        final cartHeader = find.descendant(
          of: find.byType(CartScreen),
          matching: find.byType(FlowinHeader),
        );
        final cartNotif = find.descendant(
          of: cartHeader,
          matching: find.byIcon(Icons.notifications_none_rounded),
        );
        expect(cartNotif, findsOneWidget);
        expect(
          find.descendant(of: cartHeader, matching: find.text('Clear')),
          findsNothing,
        );
        expect(
          find.descendant(
            of: find.descendant(
              of: find.byType(CartScreen),
              matching: find.byType(SingleChildScrollView),
            ),
            matching: find.text('Clear'),
          ),
          findsOneWidget,
        );

        // Tap Cart Notification -> NotificationScreen -> Back
        await tester.tap(cartNotif);
        await pumpTransition(tester);
        expect(find.byType(NotificationScreen), findsOneWidget);
        await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
        await pumpTransition(tester);

        // Profile tab
        await tester.tap(find.text('Profile').last);
        await pumpTransition(tester);
        final profileHeader = find.descendant(
          of: find.byType(ProfileScreen),
          matching: find.byType(FlowinHeader),
        );
        expect(
          find.descendant(
            of: profileHeader,
            matching: find.byIcon(Icons.notifications_none_rounded),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Checkout & Register remove unnecessary header buttons without leaving empty trailing spacers',
      (tester) async {
        await setViewport(tester, const Size(390, 844));
        final state = FlowinAppState();

        // Checkout screen pushed on top of a root so back button displays
        await tester.pumpWidget(
          wrapApp(
            state,
            Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CheckoutScreen(),
                      ),
                    ),
                    child: const Text('Open Checkout'),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Open Checkout'));
        await pumpTransition(tester);

        expect(find.byType(CheckoutScreen), findsOneWidget);
        expect(find.byIcon(Icons.lock_outline_rounded), findsNothing);
        expect(find.byIcon(Icons.notifications_none_rounded), findsNothing);
        expect(
          find.descendant(
            of: find.byType(FlowinHeader),
            matching: find.byIcon(Icons.arrow_back_ios_new_rounded),
          ),
          findsOneWidget,
        );
        final checkoutToolbar = tester.widget<NavigationToolbar>(
          find.descendant(
            of: find.byType(FlowinHeader),
            matching: find.byType(NavigationToolbar),
          ),
        );
        expect(checkoutToolbar.trailing, isNull);
        expect(tester.takeException(), isNull);

        // Register / Create Account screen
        await tester.pumpWidget(
          wrapApp(
            state,
            Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterScreen(),
                      ),
                    ),
                    child: const Text('Open Register'),
                  ),
                ),
              ),
            ),
            appKey: const ValueKey('register_harness'),
          ),
        );
        await tester.tap(find.text('Open Register'));
        await pumpTransition(tester);

        expect(find.byType(RegisterScreen), findsOneWidget);
        expect(find.byIcon(Icons.help_outline_rounded), findsNothing);
        expect(find.byIcon(Icons.notifications_none_rounded), findsNothing);
        expect(
          find.descendant(
            of: find.byType(FlowinHeader),
            matching: find.byIcon(Icons.arrow_back_ios_new_rounded),
          ),
          findsOneWidget,
        );
        final registerToolbar = tester.widget<NavigationToolbar>(
          find.descendant(
            of: find.byType(FlowinHeader),
            matching: find.byType(NavigationToolbar),
          ),
        );
        expect(registerToolbar.trailing, isNull);
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('Navigation Hardening (Live Tracking & Rating/Review Back)', () {
    testWidgets(
      'PaymentConfirmation -> LiveTracking -> header Back goes to Orders (not PaymentConfirmation)',
      (tester) async {
        await setViewport(tester, const Size(390, 844));
        final state = FlowinAppState();
        final activeOrderCountBefore = state.orders.length;

        await tester.pumpWidget(
          wrapApp(state, const PaymentConfirmationScreen()),
        );
        await pumpTransition(tester);

        await tester.ensureVisible(find.text('Track My Delivery'));
        await tester.tap(find.text('Track My Delivery'));
        await pumpTransition(tester);
        expect(find.byType(LiveDeliveryTrackingScreen), findsOneWidget);
        expect(find.byType(PaymentConfirmationScreen), findsNothing);

        await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
        await pumpTransition(tester);

        expect(find.byType(OrdersScreen), findsOneWidget);
        expect(find.byType(PaymentConfirmationScreen), findsNothing);
        expect(state.orders.length, activeOrderCountBefore);
      },
    );

    testWidgets(
      'Orders -> LiveTracking -> system Back returns to Orders cleanly',
      (tester) async {
        await setViewport(tester, const Size(390, 844));
        final state = FlowinAppState();
        await tester.pumpWidget(
          wrapApp(state, const MainNavigationScreen(initialIndex: 1)),
        );
        await pumpTransition(tester);

        await tester.tap(find.text('Track').first);
        await pumpTransition(tester);
        expect(find.byType(LiveDeliveryTrackingScreen), findsOneWidget);

        await tester.binding.handlePopRoute();
        await pumpTransition(tester);
        expect(find.byType(OrdersScreen), findsOneWidget);
      },
    );

    testWidgets(
      'PaymentConfirmation -> LiveTracking -> RatingReview -> header/system Back goes to Home',
      (tester) async {
        await setViewport(tester, const Size(390, 844));
        final state = FlowinAppState();

        await tester.pumpWidget(
          wrapApp(state, const PaymentConfirmationScreen()),
        );
        await pumpTransition(tester);

        await tester.ensureVisible(find.text('Track My Delivery'));
        await tester.tap(find.text('Track My Delivery'));
        await pumpTransition(tester);

        await tester.tap(find.text('Mark Gallon Received'));
        await tester.pump(const Duration(milliseconds: 400));
        FlowinToast.dismiss();
        await tester.pump();

        await tester.tap(find.text('Complete & Rate Delivery'));
        await pumpTransition(tester);
        expect(find.byType(RatingReviewScreen), findsOneWidget);

        // Header back from Rating & Review lands on Home (never Payment Confirmation)
        await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
        await pumpTransition(tester);
        expect(find.byType(HomeScreen), findsOneWidget);
        expect(find.byType(PaymentConfirmationScreen), findsNothing);

        // System back from RatingReview also lands on Home; Submit -> ReviewSuccess -> Back to Home
        await tester.pumpWidget(
          wrapApp(
            state,
            const RatingReviewScreen(),
            appKey: const ValueKey('rating_pop_harness'),
          ),
        );
        await pumpTransition(tester);
        await tester.binding.handlePopRoute();
        await pumpTransition(tester);
        expect(find.byType(HomeScreen), findsOneWidget);

        await tester.pumpWidget(
          wrapApp(
            state,
            const RatingReviewScreen(),
            appKey: const ValueKey('rating_submit_harness'),
          ),
        );
        await pumpTransition(tester);
        await tester.tap(find.text('Submit Review'));
        await pumpTransition(tester);
        expect(find.byType(ReviewSuccessScreen), findsOneWidget);
        await tester.tap(find.text('Back to Home'));
        await pumpTransition(tester);
        expect(find.byType(HomeScreen), findsOneWidget);
      },
    );
  });

  group('Saved to Favorite Microinteraction', () {
    testWidgets(
      'Favorite from Home & ProductDetail animates spring pop, reverse outline, and stays synced',
      (tester) async {
        await setViewport(tester, const Size(390, 844));
        final state = FlowinAppState();
        final targetProduct =
            state.catalog.firstWhere((p) => !state.isFavorite(p.name));
        final targetProductName = targetProduct.name;
        expect(state.isFavorite(targetProductName), isFalse);

        await tester.pumpWidget(wrapApp(state, const MainNavigationScreen()));
        await pumpTransition(tester);

        final targetCard = find.ancestor(
          of: find.text(targetProductName),
          matching: find.byType(ProductCard),
        );
        final targetFavButton = find.descendant(
          of: targetCard,
          matching: find.byType(FlowinFavoriteButton),
        );
        await tester.ensureVisible(targetFavButton);
        await tester.pump();

        expect(
          find.descendant(
            of: targetFavButton,
            matching: find.byIcon(Icons.favorite_border_rounded),
          ),
          findsOneWidget,
        );

        await tester.tap(targetFavButton);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 180));
        expect(state.isFavorite(targetProductName), isTrue);
        expect(find.text('Saved to Favorites'), findsOneWidget);

        // Mid-flight celebration burst uses CustomPaint
        expect(
          find.descendant(
            of: targetFavButton,
            matching: find.byType(CustomPaint),
          ),
          findsWidgets,
        );

        await tester.pump(const Duration(milliseconds: 420));
        expect(
          find.descendant(
            of: targetFavButton,
            matching: find.byIcon(Icons.favorite_rounded),
          ),
          findsOneWidget,
        );
        FlowinToast.dismiss();
        await tester.pump();

        // Navigate into ProductDetail -> icon is filled & synced
        await tester.tap(find.text(targetProductName));
        await pumpTransition(tester);
        expect(find.byType(ProductDetailScreen), findsOneWidget);

        final detailFavButton = find.descendant(
          of: find.byType(ProductDetailScreen),
          matching: find.byType(FlowinFavoriteButton),
        );
        expect(
          find.descendant(
            of: detailFavButton,
            matching: find.byIcon(Icons.favorite_rounded),
          ),
          findsOneWidget,
        );

        // Toggle off -> reverse transition without celebration burst
        await tester.tap(detailFavButton);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(
          find.descendant(
            of: detailFavButton,
            matching: find.byType(CustomPaint),
          ),
          findsNothing,
        );
        await tester.pump(const Duration(milliseconds: 180));
        expect(state.isFavorite(targetProductName), isFalse);
        expect(find.text('Removed from Favorites'), findsOneWidget);
        expect(
          find.descendant(
            of: detailFavButton,
            matching: find.byIcon(Icons.favorite_border_rounded),
          ),
          findsOneWidget,
        );
        FlowinToast.dismiss();
        await tester.pump();

        // Return to Home -> ProductCard still reflects outline state
        await tester.tap(
          find.descendant(
            of: find.byType(FlowinHeader),
            matching: find.byIcon(Icons.arrow_back_ios_new_rounded),
          ),
        );
        await pumpTransition(tester);
        expect(
          find.descendant(
            of: targetFavButton,
            matching: find.byIcon(Icons.favorite_border_rounded),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'FlowinFavoriteButton respects disableAnimations accessibility mode',
      (tester) async {
        await setViewport(tester, const Size(390, 844));
        final state = FlowinAppState();
        final targetProduct =
            state.catalog.firstWhere((p) => !state.isFavorite(p.name));
        await tester.pumpWidget(
          wrapApp(state, const MainNavigationScreen(), disableAnimations: true),
        );
        await tester.pump();

        final targetFavButton = find.descendant(
          of: find.ancestor(
            of: find.text(targetProduct.name),
            matching: find.byType(ProductCard),
          ),
          matching: find.byType(FlowinFavoriteButton),
        );
        await tester.ensureVisible(targetFavButton);
        await tester.pump();

        await tester.tap(targetFavButton);
        await tester.pump();

        expect(
          find.descendant(
            of: targetFavButton,
            matching: find.byIcon(Icons.favorite_rounded),
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('Cart Clear Confirmation Dialog', () {
    testWidgets(
      'Clear -> Cancel preserves cart; Clear -> Clear Cart empties basket, updates totals & badge',
      (tester) async {
        await setViewport(tester, const Size(390, 844));
        final state = FlowinAppState();
        final initialCount = state.cartItemCount;
        final initialTotal = state.total;
        expect(initialCount, greaterThan(0));

        await tester.pumpWidget(
          wrapApp(state, const MainNavigationScreen(initialIndex: 2)),
        );
        await pumpTransition(tester);

        // Tap Clear -> confirmation dialog appears
        await tester.tap(find.text('Clear'));
        await pumpTransition(tester);
        expect(find.text('Clear Shopping Cart?'), findsOneWidget);
        expect(
          find.text(
            'Are you sure you want to remove all items from your cart? This action cannot be undone.',
          ),
          findsOneWidget,
        );
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Clear Cart'), findsOneWidget);

        // Tap Cancel -> zero state mutation
        await tester.tap(find.text('Cancel'));
        await pumpTransition(tester);
        expect(find.text('Clear Shopping Cart?'), findsNothing);
        expect(state.cartItemCount, initialCount);
        expect(state.total, initialTotal);

        // Tap Clear again -> Tap Clear Cart
        await tester.tap(find.text('Clear'));
        await pumpTransition(tester);
        await tester.tap(find.text('Clear Cart'));
        await pumpTransition(tester);

        expect(state.cartItems, isEmpty);
        expect(state.cartItemCount, 0);
        expect(state.subtotal, 0);
        expect(state.deliveryFee, 0);
        expect(state.tax, 0);
        expect(state.total, 0);
        expect(find.text('Your Basket is Empty'), findsOneWidget);
        expect(find.text('Clear'), findsNothing);
        expect(find.text('Cart Cleared'), findsOneWidget);

        // Cart nav bar badge is 0
        final navBar = tester.widget<FlowinFluidNavBar>(
          find.byType(FlowinFluidNavBar),
        );
        expect(navBar.tabs[2].badgeCount, 0);
      },
    );
  });
}

