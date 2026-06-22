import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';

void main() {
  runApp(const FlowinApp());
}

class FlowinApp extends StatelessWidget {
  const FlowinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flowin',
      theme: AppTheme.lightTheme,
      home: const OnboardingScreen(),
    );
  }
}