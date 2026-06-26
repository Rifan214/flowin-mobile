import 'package:flutter/material.dart';

import '../core/constants/app_text_styles.dart';
import 'subscription_payment_screen.dart';

class SubscriptionPlan {
  final String name;
  final double price;
  final String frequency;
  final String description;
  final List<String> features;
  final bool isPopular;
  final String? badge;

  SubscriptionPlan({
    required this.name,
    required this.price,
    required this.frequency,
    required this.description,
    required this.features,
    this.isPopular = false,
    this.badge,
  });
}

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  late List<SubscriptionPlan> plans;
  late String selectedPlan;

  @override
  void initState() {
    super.initState();
    plans = [
      SubscriptionPlan(
        name: 'Weekly',
        price: 15,
        frequency: 'delivery',
        description:
            'Perfect for active households staying constantly hydrated.',
        features: [
          '4 deliveries per week',
          'Priority delivery window',
          'Free delivery',
        ],
        isPopular: false,
      ),
      SubscriptionPlan(
        name: 'Bi-Weekly',
        price: 18,
        frequency: 'delivery',
        description: 'A balanced approach for steady refreshment.',
        features: ['2 deliveries per week', 'Standard delivery'],
        isPopular: true,
        badge: 'Most Popular',
      ),
      SubscriptionPlan(
        name: 'Monthly',
        price: 20,
        frequency: 'delivery',
        description: 'Ideal for bulk stocking or low-volume needs.',
        features: ['1 delivery per 0 with', 'Flexible scheduled'],
        isPopular: false,
        badge: 'Save 25%',
      ),
    ];
    selectedPlan = 'Bi-Weekly';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Subscription Plans',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Choose Your Flow',
                style: AppTextStyles.appBarTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Select a hydration plan that fits your lifestyle. Cancel anytime.',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Column(
                children: List.generate(
                  plans.length,
                  (index) => _buildPlanCard(plans[index], index),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0D6EFD),
                  ),
                  onPressed: () {
                    final selectedPlanObj = plans.firstWhere(
                      (plan) => plan.name == selectedPlan,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SubscriptionPaymentScreen(plan: selectedPlanObj),
                      ),
                    );
                  },
                  child: const Text(
                    'Subscribe Now',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan, int index) {
    final isSelected = selectedPlan == plan.name;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? const Color(0xFF0D6EFD) : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
        color: isSelected
            ? const Color(0xFF0D6EFD).withOpacity(0.05)
            : Colors.white,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${plan.price.toStringAsFixed(0)} ${plan.frequency}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF0D6EFD),
                          ),
                        ),
                      ],
                    ),
                    Radio<String>(
                      value: plan.name,
                      groupValue: selectedPlan,
                      onChanged: (value) {
                        setState(() {
                          selectedPlan = value!;
                        });
                      },
                      activeColor: const Color(0xFF0D6EFD),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  plan.description,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    plan.features.length,
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 20,
                            color: Color(0xFF0D6EFD),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              plan.features[i],
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (plan.badge != null)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D6EFD),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  plan.badge!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
