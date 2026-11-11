import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/design_system/flowin_theme.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'state/flowin_app_state.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const FlowinApp());
}

class FlowinApp extends StatefulWidget {
  const FlowinApp({super.key, this.state});

  final FlowinAppState? state;

  @override
  State<FlowinApp> createState() => _FlowinAppState();
}

class _FlowinAppState extends State<FlowinApp> {
  late final FlowinAppState _ownedState;

  FlowinAppState get _effectiveState => widget.state ?? _ownedState;

  @override
  void initState() {
    super.initState();
    _ownedState = FlowinAppState();
  }

  @override
  void dispose() {
    if (widget.state == null) {
      _ownedState.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlowinScope(
      state: _effectiveState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flowin',
        theme: FlowinTheme.light,
        builder: (context, child) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: const OnboardingScreen(),
      ),
    );
  }
}
