class SubscriptionPlan {
  final String title;
  final int price;
  final String description;
  final List<String> features;
  final String badge;
  final bool isPopular;

  const SubscriptionPlan({
    required this.title,
    required this.price,
    required this.description,
    required this.features,
    this.badge = '',
    this.isPopular = false,
  });

  SubscriptionPlan copyWith({
    String? title,
    int? price,
    String? description,
    List<String>? features,
    String? badge,
    bool? isPopular,
  }) {
    return SubscriptionPlan(
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      features: features ?? this.features,
      badge: badge ?? this.badge,
      isPopular: isPopular ?? this.isPopular,
    );
  }
}
