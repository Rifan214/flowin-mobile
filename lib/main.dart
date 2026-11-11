import 'package:flutter/material.dart';

import 'core/design_system/flowin_theme.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'state/flowin_app_state.dart';

void main() {
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
        home: const OnboardingScreen(),
      ),
    );
  }
}
