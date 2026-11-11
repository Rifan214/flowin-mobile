import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flowin/data/dummy_products.dart';
import 'package:flowin/main.dart';
import 'package:flowin/screens/auth/login_screen.dart';
import 'package:flowin/screens/auth/register_screen.dart';
import 'package:flowin/screens/main_navigation_screen.dart';
import 'package:flowin/screens/orders/cancel_order_screen.dart';
import 'package:flowin/screens/profile/payment_methods_screen.dart';
import 'package:flowin/screens/profile/personal_information_screen.dart';
import 'package:flowin/screens/review/rating_review_screen.dart';
import 'package:flowin/screens/subscription/subscription_screen.dart';
import 'package:flowin/screens/tracking/live_delivery_tracking_screen.dart';
import 'package:flowin/shared/widgets/flowin_toast.dart';
import 'package:flowin/state/flowin_app_state.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  tearDown(() {
    FlowinToast.dismiss();
  });

  Widget wrapApp(FlowinAppState state, Widget home) {
    return FlowinScope(
      state: state,
      child: MaterialApp(
        key: ValueKey(home.runtimeType),
        home: home,
      ),
    );
  }

  Future<void> setPhoneViewport(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> pumpTransition(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  }

  group('FlowinAppState business logic', () {
    test('cart calculations, filtering, ordering, wallet, and subscriptions', () {
      final state = FlowinAppState();
      final initialCount = state.cartItemCount;

      state.addProductToCart(dummyProducts.first, quantity: 2);
      expect(state.cartItemCount, initialCount + 2);
      expect(state.deliveryFee, 5000);
      expect(state.tax, (state.subtotal * 0.05).roundToDouble());
      expect(state.total, state.subtotal + state.deliveryFee + state.tax);

      // Filters
      state.setSearchQuery('Pristine');
      expect(state.filteredProducts.length, 1);
      expect(state.filteredProducts.first.name, contains('Pristine'));
      state.resetFilters();
      expect(state.filteredProducts.length, dummyProducts.length);

      // Order placement
      final orderCountBefore = state.orders.length;
      final placed = state.placeOrderFromCart();
      expect(placed.status, 'In Progress');
      expect(state.orders.length, orderCountBefore + 1);
      expect(state.cartItems, isEmpty);
      expect(state.deliveryFee, 0);

      // Wallet, notifications, subscription
      final prevBalance = state.walletBalance;
      state.topUpWallet(50000);
      expect(state.walletBalance, prevBalance + 50000);

      state.markAllNotificationsRead();
      expect(state.unreadNotificationsCount, 0);

      state.activateSubscription(state.subscriptionPlans.first);
      expect(state.activeSubscription, state.subscriptionPlans.first);
    });
  });

  group('Flowin user journeys', () {
    testWidgets('Onboarding -> Login -> Register -> RegisterSuccess flow',
        (tester) async {
      await setPhoneViewport(tester);
      final state = FlowinAppState();
      await tester.pumpWidget(FlowinApp(state: state));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Get Started'));
      await pumpTransition(tester);
      expect(find.byType(LoginScreen), findsOneWidget);

      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await pumpTransition(tester);
      expect(find.byType(RegisterScreen), findsOneWidget);

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Alex Morgan');
      await tester.enterText(fields.at(1), 'alex@flowin.id');
      await tester.enterText(fields.at(2), '08123456789');
      await tester.enterText(fields.at(3), 'password123');
      await tester.enterText(fields.at(4), 'password123');

      await tester.ensureVisible(find.text('Create Account').last);
      await tester.tap(find.text('Create Account').last);
      await pumpTransition(tester);
      expect(find.text('Account Created!'), findsOneWidget);

      await tester.tap(find.text('Sign In to Flowin'));
      await pumpTransition(tester);
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('Home search, ProductDetail add-to-cart, Cart -> Checkout -> Payment',
        (tester) async {
      await setPhoneViewport(tester);
      final state = FlowinAppState();
      await tester.pumpWidget(wrapApp(state, const MainNavigationScreen()));
      await pumpTransition(tester);

      // Search filters catalog dynamically
      await tester.enterText(find.byType(TextField), 'Aqua');
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('1 items'), findsOneWidget);

      await tester.tap(find.text('Galon Aqua'));
      await pumpTransition(tester);
      expect(find.text('Product Details'), findsOneWidget);

      // Increment quantity cleanly and add to cart
      await tester.tap(find.byIcon(Icons.add_rounded).last);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.text('Add to Cart'));
      await pumpTransition(tester);
      FlowinToast.dismiss();
      await tester.pump();

      // Should land cleanly on Cart tab
      expect(find.text('Proceed to Checkout'), findsOneWidget);

      await tester.ensureVisible(find.text('Proceed to Checkout'));
      await tester.tap(find.text('Proceed to Checkout'));
      await pumpTransition(tester);
      expect(find.text('Checkout'), findsOneWidget);

      await tester.tap(find.textContaining('Confirm & Pay'));
      await pumpTransition(tester);
      expect(find.text('Hydration on the Way!'), findsOneWidget);
    });

    testWidgets('Tracking -> RatingReview -> ReviewSuccess flow', (tester) async {
      await setPhoneViewport(tester);
      final state = FlowinAppState();
      await tester.pumpWidget(
        wrapApp(state, const LiveDeliveryTrackingScreen()),
      );
      await pumpTransition(tester);

      await tester.tap(find.text('Mark Gallon Received'));
      await tester.pump(const Duration(milliseconds: 400));
      FlowinToast.dismiss();
      await tester.pump();
      expect(find.text('Complete & Rate Delivery'), findsOneWidget);

      await tester.tap(find.text('Complete & Rate Delivery'));
      await pumpTransition(tester);
      expect(find.byType(RatingReviewScreen), findsOneWidget);

      await tester.tap(find.text('Submit Review'));
      await pumpTransition(tester);
      expect(find.text('Thank You!'), findsOneWidget);
    });

    testWidgets('CancelOrder, Profile edits, Payment top up & Subscription flow',
        (tester) async {
      await setPhoneViewport(tester);
      final state = FlowinAppState();

      // Cancel flow
      await tester.pumpWidget(wrapApp(state, const CancelOrderScreen()));
      await pumpTransition(tester);
      await tester.tap(find.text('Confirm Cancellation'));
      await pumpTransition(tester);
      expect(find.text('Delivery Cancelled'), findsOneWidget);

      // Personal Info edit
      await tester.pumpWidget(wrapApp(state, const PersonalInformationScreen()));
      await pumpTransition(tester);
      await tester.enterText(find.byType(TextFormField).first, 'Rifan Flowin');
      await tester.tap(find.text('Save Changes'));
      await tester.pump(const Duration(milliseconds: 300));
      FlowinToast.dismiss();
      await tester.pump();
      expect(state.userName, 'Rifan Flowin');

      // Payment Methods top up
      await tester.pumpWidget(wrapApp(state, const PaymentMethodsScreen()));
      await pumpTransition(tester);
      final beforeWallet = state.walletBalance;
      await tester.tap(find.text('Top Up'));
      await pumpTransition(tester);
      await tester.tap(find.textContaining('Confirm Top Up'));
      await pumpTransition(tester);
      FlowinToast.dismiss();
      await tester.pump();
      expect(state.walletBalance, beforeWallet + 100000);

      // Subscription full flow
      await tester.pumpWidget(wrapApp(state, const SubscriptionScreen()));
      await pumpTransition(tester);
      await tester.tap(find.textContaining('Continue with'));
      await pumpTransition(tester);
      expect(find.text('Plan Checkout'), findsOneWidget);

      await tester.tap(find.text('Review & Activate'));
      await pumpTransition(tester);
      expect(find.text('Confirm Plan'), findsOneWidget);

      await tester.tap(find.text('Activate Subscription'));
      await pumpTransition(tester);
      expect(find.text('Subscription Activated!'), findsOneWidget);
      expect(state.activeSubscription, isNotNull);
    });
  });
}

