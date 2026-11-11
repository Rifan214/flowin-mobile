import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flowin/core/services/profile_photo_picker.dart';
import 'package:flowin/screens/auth/login_screen.dart';
import 'package:flowin/screens/cart/cart_screen.dart';
import 'package:flowin/screens/checkout/checkout_screen.dart';
import 'package:flowin/screens/profile/payment_methods_screen.dart';
import 'package:flowin/screens/profile/personal_information_screen.dart';
import 'package:flowin/screens/profile/profile_screen.dart';
import 'package:flowin/screens/subscription/subscription_checkout_screen.dart';
import 'package:flowin/shared/widgets/flowin_toast.dart';
import 'package:flowin/shared/widgets/flowin_user_avatar.dart';
import 'package:flowin/state/flowin_app_state.dart';
import 'package:flowin/widgets/address_card.dart';

/// Genuine 1x1 RGB PNG generated with valid zlib deflate & CRC32 checksums.
final Uint8List _validPngBytes = Uint8List.fromList([
  137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 0, 1, 0,
  0, 0, 1, 8, 2, 0, 0, 0, 144, 119, 83, 222, 0, 0, 0, 12, 73, 68, 65, 84, 120,
  156, 99, 96, 168, 255, 15, 0, 2, 1, 1, 127, 181, 230, 183, 205, 0, 0, 0, 0,
  73, 69, 78, 68, 174, 66, 96, 130,
]);

class _FakePhotoPicker implements ProfilePhotoPicker {
  _FakePhotoPicker(this.handler);

  Future<PhotoPickResult> Function() handler;

  @override
  Future<PhotoPickResult> pickFromGallery() => handler();
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  tearDown(() {
    FlowinToast.dismiss();
  });

  Widget wrap(FlowinAppState state, Widget child) {
    return FlowinScope(
      state: state,
      child: MaterialApp(home: child),
    );
  }

  void setPhoneViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> pumpPastSheetExit(WidgetTester tester) async {
    for (int i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  group('Bug #1 - Delivery Address Update Hardening', () {
    testWidgets(
        'Cart edit delivery address updates state after editing text with zero exceptions',
        (tester) async {
      setPhoneViewport(tester);
      final state = FlowinAppState();
      await tester.pumpWidget(wrap(state, const CartScreen()));
      await tester.pump(const Duration(milliseconds: 400));

      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Office • Flowin HQ');
      await tester.enterText(fields.at(1), 'Jl. Jend. Sudirman Kav 52, Jakarta');
      await tester.pump();

      await tester.tap(find.text('Save Address'));
      await pumpPastSheetExit(tester);

      expect(state.deliveryTitle, 'Office • Flowin HQ');
      expect(state.deliveryAddress, 'Jl. Jend. Sudirman Kav 52, Jakarta');
      expect(find.text('Address Updated'), findsOneWidget);
      expect(find.text('Jl. Jend. Sudirman Kav 52, Jakarta'), findsWidgets);
    });

    testWidgets(
        'Cart edit delivery address with unchanged values still shows update toast safely',
        (tester) async {
      setPhoneViewport(tester);
      final state = FlowinAppState();
      final originalTitle = state.deliveryTitle;
      final originalAddress = state.deliveryAddress;

      await tester.pumpWidget(wrap(state, const CartScreen()));
      await tester.pump(const Duration(milliseconds: 400));

      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save Address'));
      await pumpPastSheetExit(tester);

      expect(state.deliveryTitle, originalTitle);
      expect(state.deliveryAddress, originalAddress);
      expect(find.text('Address Updated'), findsOneWidget);
    });

    testWidgets(
        'Cart edit delivery address rejects empty fields and keeps sheet open',
        (tester) async {
      setPhoneViewport(tester);
      final state = FlowinAppState();
      await tester.pumpWidget(wrap(state, const CartScreen()));
      await tester.pump(const Duration(milliseconds: 400));

      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), '');
      await tester.enterText(fields.at(1), '');
      await tester.tap(find.text('Save Address'));
      await tester.pumpAndSettle();

      expect(find.text('Address label cannot be empty'), findsOneWidget);
      expect(find.text('Delivery address cannot be empty'), findsOneWidget);
      expect(find.text('Edit Delivery Address'), findsOneWidget);
    });

    testWidgets(
        'Checkout & SubscriptionCheckout edit address sync state safely without controller disposal errors',
        (tester) async {
      setPhoneViewport(tester);
      final state = FlowinAppState();
      await tester.pumpWidget(wrap(state, const CheckoutScreen()));
      await tester.pump(const Duration(milliseconds: 400));

      await tester.tap(
        find.descendant(
          of: find.byType(AddressCard),
          matching: find.byType(TextButton),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).at(1),
        'Jl. Kemang Raya No. 88, South Jakarta',
      );
      await tester.pump();

      await tester.tap(find.text('Save Address'));
      await pumpPastSheetExit(tester);
      FlowinToast.dismiss();
      await tester.pump();

      expect(state.deliveryAddress, 'Jl. Kemang Raya No. 88, South Jakarta');

      final plan = state.subscriptionPlans.first;
      await tester.pumpWidget(
        wrap(state, SubscriptionCheckoutScreen(plan: plan)),
      );
      await tester.pump(const Duration(milliseconds: 400));

      await tester.tap(
        find.descendant(
          of: find.byType(AddressCard),
          matching: find.byType(TextButton),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'Studio • Senopati',
      );
      await tester.pump();

      await tester.tap(find.text('Save Address'));
      await pumpPastSheetExit(tester);

      expect(state.deliveryTitle, 'Studio • Senopati');
      expect(find.text('Studio • Senopati'), findsWidgets);
    });
  });

  group('Bug #2 - Add Payment Method Validation & Safe Modal Lifecycle', () {
    testWidgets(
        'PaymentMethods validates incomplete fields, saves new method, and updates UI & selection',
        (tester) async {
      setPhoneViewport(tester);
      final state = FlowinAppState();
      final initialCount = state.paymentMethods.length;

      await tester.pumpWidget(wrap(state, const PaymentMethodsScreen()));
      await tester.pump(const Duration(milliseconds: 400));

      await tester.tap(find.text('Add New'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 450));

      // Incomplete submit shows field errors and stays open
      await tester.tap(find.text('Save Payment Method'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Method name cannot be empty'), findsOneWidget);
      expect(find.text('Account note cannot be empty'), findsOneWidget);
      expect(state.paymentMethods.length, initialCount);

      // Fill valid simulation details
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'GoPay Wallet');
      await tester.enterText(fields.at(1), '+62 812 9999 0000');
      await tester.pump();

      await tester.tap(find.text('Save Payment Method'));
      await pumpPastSheetExit(tester);

      expect(state.paymentMethods.length, initialCount + 1);
      expect(state.selectedPaymentMethod.label, 'GoPay Wallet');
      expect(find.text('GoPay Wallet'), findsOneWidget);
      expect(find.text('Payment Method Saved'), findsOneWidget);

      // Selecting another method switches selection cleanly
      await tester.tap(find.text('QRIS / Instant Bank'));
      await tester.pump(const Duration(milliseconds: 200));
      expect(state.selectedPaymentId, 'qris');
    });

    testWidgets(
        'Checkout Add New payment method adds, selects, persists, and renders cleanly',
        (tester) async {
      setPhoneViewport(tester);
      final state = FlowinAppState();

      await tester.pumpWidget(wrap(state, const CheckoutScreen()));
      await tester.pump(const Duration(milliseconds: 400));

      await tester.tap(find.text('Add New'));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'OVO Instant');
      await tester.enterText(fields.at(1), 'Demo wallet •••• 7788');
      await tester.pump();

      await tester.tap(find.text('Save & Select'));
      await pumpPastSheetExit(tester);

      expect(state.selectedPaymentMethod.label, 'OVO Instant');
      expect(find.text('OVO Instant'), findsOneWidget);
      expect(find.text('Payment Method Saved'), findsOneWidget);

      // Navigate / inspect PaymentMethodsScreen reflects the added method
      FlowinToast.dismiss();
      await tester.pumpWidget(wrap(state, const PaymentMethodsScreen()));
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('OVO Instant'), findsOneWidget);
    });
  });

  group('Bug #3 - Profile Photo Upload Validation & UI Synchronization', () {
    test('validateProfilePhotoBytes rejects empty, oversize, unsupported, and corrupt bytes',
        () {
      expect(validateProfilePhotoBytes(Uint8List(0)), isNotNull);
      expect(
        validateProfilePhotoBytes(_validPngBytes, fileName: 'avatar.png'),
        isNull,
      );
      expect(
        validateProfilePhotoBytes(_validPngBytes, fileName: 'doc.pdf'),
        contains('Unsupported file format'),
      );
      expect(
        validateProfilePhotoBytes(
          Uint8List.fromList([1, 2, 3, 4, 5]),
          fileName: 'fake.png',
        ),
        contains('corrupted'),
      );
      final oversized = Uint8List(maxProfilePhotoBytes + 1);
      oversized.setRange(0, _validPngBytes.length, _validPngBytes);
      expect(
        validateProfilePhotoBytes(oversized, fileName: 'big.png'),
        contains('5 MB'),
      );
    });

    testWidgets(
        'PersonalInformation uploads, previews, syncs to ProfileHeaderCard, handles cancel & errors, and removes safely',
        (tester) async {
      setPhoneViewport(tester);
      final picker = _FakePhotoPicker(
        () async => PhotoPickSuccess(_validPngBytes, fileName: 'profile.png'),
      );
      final state = FlowinAppState(photoPicker: picker);

      await tester.pumpWidget(wrap(state, const PersonalInformationScreen()));
      await tester.pump(const Duration(milliseconds: 400));

      // Default crest shows before any photo is selected
      expect(state.hasProfilePhoto, isFalse);
      expect(find.text('Edit Photo'), findsOneWidget);
      expect(find.byIcon(Icons.person_rounded), findsOneWidget);

      // Upload valid photo via Edit Photo -> Update Profile Photo sheet -> Choose from Gallery
      await tester.tap(find.text('Edit Photo'));
      await tester.pumpAndSettle();
      expect(find.text('Update Profile Photo'), findsOneWidget);
      await tester.tap(find.text('Choose from Gallery'));
      await tester.pumpAndSettle();

      expect(state.hasProfilePhoto, isTrue);
      expect(find.text('Edit Photo'), findsOneWidget);
      expect(find.text('Remove'), findsOneWidget);
      expect(find.text('Profile Photo Updated'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      // User cancels next selection -> preserves uploaded photo cleanly with no error
      FlowinToast.dismiss();
      picker.handler = () async => const PhotoPickCancelled();
      await tester.tap(find.byType(FlowinUserAvatar));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose from Gallery'));
      await tester.pumpAndSettle();
      expect(state.profilePhotoBytes, equals(_validPngBytes));
      expect(find.text('Photo Upload Failed'), findsNothing);

      // Picker error -> preserves previous photo and displays error feedback
      picker.handler = () async =>
          const PhotoPickFailure('Unsupported file format (.svg).');
      await tester.tap(find.text('Edit Photo'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Choose from Gallery'));
      await tester.pumpAndSettle();
      expect(state.profilePhotoBytes, equals(_validPngBytes));
      expect(find.text('Photo Upload Failed'), findsOneWidget);

      // Sync check across ProfileScreen / ProfileHeaderCard
      FlowinToast.dismiss();
      await tester.pumpWidget(wrap(state, const ProfileScreen()));
      await tester.pump(const Duration(milliseconds: 500));
      expect(
        find.descendant(
          of: find.byType(FlowinUserAvatar),
          matching: find.byType(Image),
        ),
        findsOneWidget,
      );

      // Removing photo reverts both screens back to default crest
      await tester.pumpWidget(wrap(state, const PersonalInformationScreen()));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      expect(state.hasProfilePhoto, isFalse);
      expect(find.byIcon(Icons.person_rounded), findsOneWidget);
    });
  });

  group('Bug #4 - Forgot Password Email Validation & Simulation Feedback', () {
    testWidgets(
        'Forgot Password validates empty & malformed emails, then simulates recovery cleanly back to Login',
        (tester) async {
      setPhoneViewport(tester);
      final state = FlowinAppState();
      await tester.pumpWidget(wrap(state, const LoginScreen()));
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      final sheetField = find.byType(TextFormField).last;

      // Empty email rejected inline
      await tester.enterText(sheetField, '   ');
      await tester.tap(find.text('Send Recovery Link'));
      await tester.pumpAndSettle();
      expect(find.text('Please enter your email address'), findsOneWidget);
      expect(find.text('Reset Password'), findsOneWidget);

      // Malformed email rejected inline
      await tester.enterText(sheetField, 'invalid-email@domain');
      await tester.tap(find.text('Send Recovery Link'));
      await tester.pumpAndSettle();
      expect(
        find.text('Enter a valid email address (e.g. name@flowin.id)'),
        findsOneWidget,
      );
      expect(find.text('Reset Password'), findsOneWidget);

      // Valid email transitions cleanly to simulation confirmation, then Back to Login closes without controller errors
      await tester.enterText(sheetField, 'rifan.user@flowin.id');
      await tester.pump();
      await tester.tap(find.text('Send Recovery Link'));
      await tester.pumpAndSettle();

      expect(find.text('Recovery Simulation Completed'), findsOneWidget);
      expect(
        find.textContaining('Recovery link simulation completed for rifan.user@flowin.id'),
        findsOneWidget,
      );

      await tester.tap(find.text('Back to Login'));
      await pumpPastSheetExit(tester);

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.text('Reset Password'), findsNothing);
      expect(find.text('Recovery Simulation Completed'), findsOneWidget);
      expect(find.text('Returned cleanly to sign in.'), findsOneWidget);
    });
  });
}
