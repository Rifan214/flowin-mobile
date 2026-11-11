import 'package:flutter/material.dart';

import '../../core/design_system/flowin_colors.dart';
import '../../shared/widgets/flowin_fluid_nav_bar.dart';
import '../../state/flowin_app_state.dart';
import 'cart/cart_screen.dart';
import 'home/home_screen.dart';
import 'orders/orders_screen.dart';
import 'profile/profile_screen.dart';

class _MainTabScope extends InheritedWidget {
  const _MainTabScope({
    required this.switchToTab,
    required super.child,
  });

  final ValueChanged<int> switchToTab;

  @override
  bool updateShouldNotify(covariant _MainTabScope oldWidget) => false;
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  /// Switches tabs cleanly in-place when inside [MainNavigationScreen],
  /// or pushes a fresh shell targeting [index] when called from pushed sub-routes.
  static void goToTab(BuildContext context, int index) {
    final scope = context.dependOnInheritedWidgetOfExactType<_MainTabScope>();
    if (scope != null) {
      scope.switchToTab(index);
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => MainNavigationScreen(initialIndex: index),
        ),
        (route) => false,
      );
    }
  }

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  static const List<Widget> _pages = [
    HomeScreen(),
    OrdersScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, _pages.length - 1);
  }

  void _selectTab(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final appState =
        context.dependOnInheritedWidgetOfExactType<FlowinScope>()?.notifier;
    final cartCount = appState?.cartItemCount ?? 0;

    return _MainTabScope(
      switchToTab: _selectTab,
      child: Scaffold(
        backgroundColor: FlowinColors.background,
        extendBody: true,
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: FlowinFluidNavBar(
          selectedIndex: _currentIndex,
          onSelected: _selectTab,
          tabs: [
            const FluidNavTab(
              label: 'Home',
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
            ),
            const FluidNavTab(
              label: 'Orders',
              icon: Icons.receipt_long_outlined,
              activeIcon: Icons.receipt_long_rounded,
            ),
            FluidNavTab(
              label: 'Cart',
              icon: Icons.shopping_bag_outlined,
              activeIcon: Icons.shopping_bag_rounded,
              badgeCount: cartCount,
            ),
            const FluidNavTab(
              label: 'Profile',
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
