import 'package:flutter/material.dart';

import '../data/dummy_cart.dart';
import '../data/dummy_notifications.dart';
import '../data/dummy_orders.dart';
import '../data/dummy_products.dart';
import '../data/dummy_subscription.dart';
import '../models/cart_item.dart';
import '../models/notification_model.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/subscription_plan.dart';

/// Consistent currency & numeric formatting across Flowin.
class FlowinFormat {
  FlowinFormat._();

  static String currency(num amount) {
    final rounded = amount.round();
    final isNegative = rounded < 0;
    final digits = rounded.abs().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      final reverseIndex = digits.length - i;
      if (i > 0 && reverseIndex % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }
    return '${isNegative ? '-' : ''}Rp $buffer';
  }
}

class SavedPaymentMethod {
  final String id;
  final String label;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final bool isWallet;

  const SavedPaymentMethod({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    this.isWallet = false,
  });

  SavedPaymentMethod copyWith({
    String? id,
    String? label,
    String? subtitle,
    IconData? icon,
    Color? accentColor,
    bool? isWallet,
  }) {
    return SavedPaymentMethod(
      id: id ?? this.id,
      label: label ?? this.label,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      accentColor: accentColor ?? this.accentColor,
      isWallet: isWallet ?? this.isWallet,
    );
  }
}

enum ProductSortOption { recommended, priceLowToHigh, priceHighToLow, volume }

/// Reactive frontend store initializing from Flowin's seed dummy datasets.
class FlowinAppState extends ChangeNotifier {
  FlowinAppState() {
    _initializeFromSeedData();
  }

  void _initializeFromSeedData() {
    _catalog = List<Product>.from(dummyProducts);
    // Align seed cart item prices with IDR catalog units when imported from raw seed
    _cartItems = dummyCartItems
        .map(
          (item) => item.price < 1000
              ? item.copyWith(price: (item.price * 2000).roundToDouble())
              : item,
        )
        .toList();
    _orders = List<Order>.from(dummyOrders);
    _notifications = List<NotificationModel>.from(dummyNotifications);
    _subscriptionPlans = dummySubscriptions
        .map(
          (plan) => plan.price < 1000
              ? plan.copyWith(price: plan.price * 5000)
              : plan,
        )
        .toList();
  }

  // Catalog & Filtering
  late List<Product> _catalog;
  String _searchQuery = '';
  final Set<String> _selectedBrands = {};
  int? _selectedLiters;
  double _maxPrice = 100000;
  ProductSortOption _sortOption = ProductSortOption.recommended;
  final Set<String> _favorites = {'Galon Aqua'};

  List<Product> get catalog => List.unmodifiable(_catalog);
  String get searchQuery => _searchQuery;
  Set<String> get selectedBrands => Set.unmodifiable(_selectedBrands);
  int? get selectedLiters => _selectedLiters;
  double get maxPrice => _maxPrice;
  ProductSortOption get sortOption => _sortOption;
  Set<String> get favorites => Set.unmodifiable(_favorites);

  bool get hasActiveFilters =>
      _searchQuery.trim().isNotEmpty ||
      _selectedBrands.isNotEmpty ||
      _selectedLiters != null ||
      _maxPrice < 100000 ||
      _sortOption != ProductSortOption.recommended;

  List<Product> get filteredProducts {
    final query = _searchQuery.trim().toLowerCase();
    final filtered = _catalog.where((product) {
      if (query.isNotEmpty) {
        final matches = product.name.toLowerCase().contains(query) ||
            product.type.toLowerCase().contains(query) ||
            product.tag.toLowerCase().contains(query);
        if (!matches) return false;
      }
      if (_selectedBrands.isNotEmpty) {
        final brandMatched = _selectedBrands.any(
          (brand) => product.name.toLowerCase().contains(brand.toLowerCase()),
        );
        if (!brandMatched) return false;
      }
      if (_selectedLiters != null && product.liters != _selectedLiters) {
        return false;
      }
      if (product.price > _maxPrice) {
        return false;
      }
      return true;
    }).toList();

    switch (_sortOption) {
      case ProductSortOption.priceLowToHigh:
        filtered.sort((a, b) => a.price.compareTo(b.price));
      case ProductSortOption.priceHighToLow:
        filtered.sort((a, b) => b.price.compareTo(a.price));
      case ProductSortOption.volume:
        filtered.sort((a, b) => b.liters.compareTo(a.liters));
      case ProductSortOption.recommended:
        break;
    }
    return filtered;
  }

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    notifyListeners();
  }

  void applyFilters({
    Set<String>? brands,
    int? liters,
    double? maxPrice,
    ProductSortOption? sortOption,
    bool clearLiters = false,
  }) {
    if (brands != null) {
      _selectedBrands
        ..clear()
        ..addAll(brands);
    }
    if (clearLiters) {
      _selectedLiters = null;
    } else if (liters != null) {
      _selectedLiters = liters;
    }
    if (maxPrice != null) {
      _maxPrice = maxPrice;
    }
    if (sortOption != null) {
      _sortOption = sortOption;
    }
    notifyListeners();
  }

  void toggleQuickFilterBrand(String brand) {
    if (_selectedBrands.contains(brand)) {
      _selectedBrands.remove(brand);
    } else {
      _selectedBrands.add(brand);
    }
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedBrands.clear();
    _selectedLiters = null;
    _maxPrice = 100000;
    _sortOption = ProductSortOption.recommended;
    notifyListeners();
  }

  bool isFavorite(String productName) => _favorites.contains(productName);

  bool toggleFavorite(String productName) {
    final added = !_favorites.contains(productName);
    if (added) {
      _favorites.add(productName);
    } else {
      _favorites.remove(productName);
    }
    notifyListeners();
    return added;
  }

  // Cart & Checkout
  late List<CartItem> _cartItems;
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  int get cartItemCount =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _cartItems.fold(0.0, (sum, item) => sum + item.lineTotal);

  double get deliveryFee => _cartItems.isEmpty ? 0.0 : 5000.0;

  double get tax => (subtotal * 0.05).roundToDouble();

  double get total => subtotal + deliveryFee + tax;

  void addProductToCart(Product product, {int quantity = 1}) {
    final idx = _cartItems.indexWhere((c) => c.name == product.name);
    if (idx >= 0) {
      final current = _cartItems[idx];
      _cartItems[idx] = current.copyWith(quantity: current.quantity + quantity);
    } else {
      _cartItems.insert(
        0,
        CartItem(
          name: product.name,
          image: product.image,
          description: '${product.liters}L • ${product.type}',
          price: product.price.toDouble(),
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void addCustomItemToCart(CartItem item) {
    final idx = _cartItems.indexWhere((c) => c.name == item.name);
    if (idx >= 0) {
      final current = _cartItems[idx];
      _cartItems[idx] =
          current.copyWith(quantity: current.quantity + item.quantity);
    } else {
      _cartItems.insert(0, item);
    }
    notifyListeners();
  }

  void incrementCartQuantity(int index) {
    if (index < 0 || index >= _cartItems.length) return;
    final item = _cartItems[index];
    _cartItems[index] = item.copyWith(quantity: item.quantity + 1);
    notifyListeners();
  }

  void decrementCartQuantity(int index) {
    if (index < 0 || index >= _cartItems.length) return;
    final item = _cartItems[index];
    if (item.quantity <= 1) {
      _cartItems.removeAt(index);
    } else {
      _cartItems[index] = item.copyWith(quantity: item.quantity - 1);
    }
    notifyListeners();
  }

  CartItem? removeCartItemAt(int index) {
    if (index < 0 || index >= _cartItems.length) return null;
    final removed = _cartItems.removeAt(index);
    notifyListeners();
    return removed;
  }

  void restoreCartItem(int index, CartItem item) {
    final safeIndex = index.clamp(0, _cartItems.length);
    _cartItems.insert(safeIndex, item);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void reorderToCart(Order order) {
    final matchingProduct = _catalog.cast<Product?>().firstWhere(
          (p) => p!.name.toLowerCase() == order.item.toLowerCase(),
          orElse: () => null,
        );
    final unitPrice = matchingProduct != null
        ? matchingProduct.price.toDouble()
        : (order.totalPrice / order.quantity.clamp(1, 99)).roundToDouble();
    addCustomItemToCart(
      CartItem(
        name: order.item,
        image: matchingProduct?.image ?? order.image,
        description: matchingProduct != null
            ? '${matchingProduct.liters}L • ${matchingProduct.type}'
            : '19L Gallon Refill • ${order.storeName}',
        price: unitPrice,
        quantity: order.quantity,
      ),
    );
  }

  // Orders & Active Delivery
  late List<Order> _orders;
  String _orderFilter = 'All';
  int _lastOrderTotal = 0;
  String _lastOrderNumber = 'FLW-89241';

  List<Order> get orders => List.unmodifiable(_orders);
  String get orderFilter => _orderFilter;
  int get lastOrderTotal => _lastOrderTotal;
  String get lastOrderNumber => _lastOrderNumber;

  List<Order> get filteredOrders {
    if (_orderFilter == 'All') return orders;
    return _orders.where((o) => o.status == _orderFilter).toList();
  }

  void setOrderFilter(String status) {
    if (_orderFilter == status) return;
    _orderFilter = status;
    notifyListeners();
  }

  Order placeOrderFromCart() {
    final orderTotal = total.round();
    final totalQty = cartItemCount.clamp(1, 999);
    final headlineItem = _cartItems.isNotEmpty
        ? (_cartItems.length > 1
            ? '${_cartItems.first.name} +${_cartItems.length - 1}'
            : _cartItems.first.name)
        : 'Galon Aqua';
    final image = _cartItems.isNotEmpty
        ? _cartItems.first.image
        : 'assets/images/gallon_aqua.jpg';
    final newOrder = Order(
      storeName: 'Flowin Central Depot',
      item: headlineItem,
      image: image,
      quantity: totalQty,
      totalPrice: orderTotal,
      status: 'In Progress',
    );
    _lastOrderTotal = orderTotal;
    _lastOrderNumber = 'FLW-${89242 + _orders.length}';
    _orders.insert(0, newOrder);
    _notifications.insert(
      0,
      NotificationModel(
        title: 'Order Confirmed',
        message: 'Order $_lastOrderNumber is being prepared for fast courier dispatch.',
        time: 'Just now',
        icon: Icons.local_shipping_rounded,
        isToday: true,
        isRead: false,
      ),
    );
    _cartItems.clear();
    notifyListeners();
    return newOrder;
  }

  void completeLatestActiveOrder() {
    final index = _orders.indexWhere((o) => o.status == 'In Progress');
    if (index >= 0) {
      _orders[index] = _orders[index].copyWith(status: 'Completed');
      notifyListeners();
    }
  }

  void cancelLatestActiveOrder() {
    final index = _orders.indexWhere((o) => o.status == 'In Progress');
    if (index >= 0) {
      _orders[index] = _orders[index].copyWith(status: 'Completed');
      _notifications.insert(
        0,
        NotificationModel(
          title: 'Order Cancelled',
          message: 'Refund for $_lastOrderNumber has been scheduled to your payment method.',
          time: 'Just now',
          icon: Icons.receipt_long_rounded,
          isToday: true,
          isRead: false,
        ),
      );
      notifyListeners();
    }
  }

  // User, Address & Preferences (Unified Persona: Alex Morgan)
  String _userName = 'Alex Morgan';
  String _userEmail = 'alex.morgan@flowin.id';
  String _userPhone = '+62 812 8400 2299';
  String _deliveryTitle = 'Home • Evergreen Residence';
  String _deliveryAddress = '742 Evergreen Terrace, Apt 4B, South Jakarta';
  bool _notificationsEnabled = true;
  bool _autoRefillReminder = true;

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  String get deliveryTitle => _deliveryTitle;
  String get deliveryAddress => _deliveryAddress;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get autoRefillReminder => _autoRefillReminder;

  void updateProfile({
    required String name,
    required String email,
    required String phone,
  }) {
    _userName = name.trim().isEmpty ? _userName : name.trim();
    _userEmail = email.trim().isEmpty ? _userEmail : email.trim();
    _userPhone = phone.trim().isEmpty ? _userPhone : phone.trim();
    notifyListeners();
  }

  void updateDeliveryAddress({required String title, required String address}) {
    _deliveryTitle = title.trim().isEmpty ? _deliveryTitle : title.trim();
    _deliveryAddress = address.trim().isEmpty ? _deliveryAddress : address.trim();
    notifyListeners();
  }

  void setNotificationsEnabled(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void setAutoRefillReminder(bool value) {
    _autoRefillReminder = value;
    notifyListeners();
  }

  // Payments & Wallet
  int _walletBalance = 245000;
  String _selectedPaymentId = 'wallet';
  final List<SavedPaymentMethod> _paymentMethods = [
    const SavedPaymentMethod(
      id: 'wallet',
      label: 'Flowin Pay Wallet',
      subtitle: 'Instant balance checkout',
      icon: Icons.account_balance_wallet_rounded,
      accentColor: Color(0xFF1565D8),
      isWallet: true,
    ),
    const SavedPaymentMethod(
      id: 'qris',
      label: 'QRIS / Instant Bank',
      subtitle: 'Zero verification fee',
      icon: Icons.qr_code_2_rounded,
      accentColor: Color(0xFF00B4D8),
    ),
    const SavedPaymentMethod(
      id: 'visa_4242',
      label: 'Visa Platinum •••• 4242',
      subtitle: 'Expires 09/28',
      icon: Icons.credit_card_rounded,
      accentColor: Color(0xFF0A3270),
    ),
    const SavedPaymentMethod(
      id: 'cod',
      label: 'Cash on Delivery',
      subtitle: 'Pay driver upon gallon arrival',
      icon: Icons.payments_outlined,
      accentColor: Color(0xFF0E9F6E),
    ),
  ];

  int get walletBalance => _walletBalance;
  String get selectedPaymentId => _selectedPaymentId;
  List<SavedPaymentMethod> get paymentMethods =>
      List.unmodifiable(_paymentMethods);

  SavedPaymentMethod get selectedPaymentMethod =>
      _paymentMethods.firstWhere(
        (m) => m.id == _selectedPaymentId,
        orElse: () => _paymentMethods.first,
      );

  void selectPaymentMethod(String id) {
    _selectedPaymentId = id;
    notifyListeners();
  }

  void topUpWallet(int amount) {
    if (amount <= 0) return;
    _walletBalance += amount;
    notifyListeners();
  }

  void addPaymentMethod(String label, String subtitle) {
    final id = 'custom_${_paymentMethods.length + 1}';
    _paymentMethods.add(
      SavedPaymentMethod(
        id: id,
        label: label,
        subtitle: subtitle,
        icon: Icons.credit_card_rounded,
        accentColor: const Color(0xFF1565D8),
      ),
    );
    _selectedPaymentId = id;
    notifyListeners();
  }

  // Notifications
  late List<NotificationModel> _notifications;
  List<NotificationModel> get notifications => List.unmodifiable(_notifications);

  int get unreadNotificationsCount =>
      _notifications.where((n) => !n.isRead).length;

  void markNotificationRead(int index) {
    if (index < 0 || index >= _notifications.length) return;
    if (_notifications[index].isRead) return;
    _notifications[index] = _notifications[index].copyWith(isRead: true);
    notifyListeners();
  }

  void markAllNotificationsRead() {
    _notifications =
        _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  // Subscriptions
  late List<SubscriptionPlan> _subscriptionPlans;
  SubscriptionPlan? _activeSubscription;

  List<SubscriptionPlan> get subscriptionPlans =>
      List.unmodifiable(_subscriptionPlans);
  SubscriptionPlan? get activeSubscription => _activeSubscription;

  void activateSubscription(SubscriptionPlan plan) {
    _activeSubscription = plan;
    _notifications.insert(
      0,
      NotificationModel(
        title: 'Subscription Active',
        message: 'Your ${plan.title} is now active with priority morning delivery.',
        time: 'Just now',
        icon: Icons.autorenew_rounded,
        isToday: true,
        isRead: false,
      ),
    );
    notifyListeners();
  }
}

/// InheritedNotifier scope allowing clean reactive reads via `FlowinScope.of(context)`.
class FlowinScope extends InheritedNotifier<FlowinAppState> {
  const FlowinScope({
    super.key,
    required FlowinAppState state,
    required super.child,
  }) : super(notifier: state);

  static FlowinAppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<FlowinScope>();
    assert(scope != null, 'FlowinScope not found above context');
    return scope!.notifier!;
  }

  static FlowinAppState read(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<FlowinScope>();
    final scope = element?.widget as FlowinScope?;
    assert(scope != null, 'FlowinScope not found above context');
    return scope!.notifier!;
  }
}

