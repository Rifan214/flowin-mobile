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
}