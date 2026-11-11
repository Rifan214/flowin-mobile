import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flowin/main.dart';
import 'package:flowin/state/flowin_app_state.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('FlowinApp renders onboarding screen and state initializes cleanly',
      (WidgetTester tester) async {
    final appState = FlowinAppState();
    expect(appState.catalog, isNotEmpty);
    expect(appState.cartItems, isNotEmpty);

    await tester.pumpWidget(FlowinApp(state: appState));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Get Started'), findsOneWidget);
  });
}
