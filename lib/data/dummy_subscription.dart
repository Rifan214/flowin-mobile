import '../models/subscription_plan.dart';

const List<SubscriptionPlan> dummySubscriptions = [
  SubscriptionPlan(
    title: 'Weekly',
    price: 15,
    description:
        'Perfect for active households staying consistently hydrated.',
    features: [
      '4 deliveries per month',
      'Priority delivery window',
      'Free delivery',
    ],
  ),

  SubscriptionPlan(
    title: 'Bi-Weekly',
    price: 18,
    description:
        'A balanced approach for steady refreshment.',
    badge: 'Most Popular',
    isPopular: true,
    features: [
      '2 deliveries per month',
      'Standard delivery',
    ],
  ),

  SubscriptionPlan(
    title: 'Monthly',
    price: 20,
    description:
        'Ideal for bulk stocking or low-volume needs.',
    badge: 'Save 20% on bulk',
    features: [
      '1 delivery per month',
      'Flexible scheduling',
    ],
  ),
];