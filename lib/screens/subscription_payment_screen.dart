import 'package:flutter/material.dart';

import '../core/constants/app_text_styles.dart';
import 'subscription_screen.dart';
import 'subscription_confirmation_screen.dart';

class SubscriptionPaymentScreen extends StatefulWidget {
  final SubscriptionPlan plan;

  const SubscriptionPaymentScreen({super.key, required this.plan});

  @override
  State<SubscriptionPaymentScreen> createState() =>
      _SubscriptionPaymentScreenState();
}

class _SubscriptionPaymentScreenState extends State<SubscriptionPaymentScreen> {
  late String selectedPaymentMethod;
  late bool agreeToTerms;

  @override
  void initState() {
    super.initState();
    selectedPaymentMethod = 'credit_card';
    agreeToTerms = false;
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
          'Payment Method',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D6EFD).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF0D6EFD).withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order Summary', style: AppTextStyles.appBarTitle),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.plan.name} Plan',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '\$${widget.plan.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0D6EFD),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '\$${widget.plan.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0D6EFD),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Payment Methods
              const Text(
                'Select Payment Method',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              _buildPaymentMethodCard(
                title: 'Credit/Debit Card',
                icon: Icons.credit_card,
                value: 'credit_card',
              ),
              const SizedBox(height: 12),

              _buildPaymentMethodCard(
                title: 'Google Pay',
                icon: Icons.g_mobiledata,
                value: 'google_pay',
              ),
              const SizedBox(height: 12),

              _buildPaymentMethodCard(
                title: 'Apple Pay',
                icon: Icons.apple,
                value: 'apple_pay',
              ),
              const SizedBox(height: 32),

              // Terms Agreement
              Row(
                children: [
                  Checkbox(
                    value: agreeToTerms,
                    onChanged: (value) {
                      setState(() {
                        agreeToTerms = value ?? false;
                      });
                    },
                    activeColor: const Color(0xFF0D6EFD),
                  ),
                  Expanded(
                    child: Text(
                      'I agree to the subscription\nterms and conditions',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Pay Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: agreeToTerms
                        ? const Color(0xFF0D6EFD)
                        : Colors.grey[300],
                  ),
                  onPressed: agreeToTerms
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SubscriptionConfirmationScreen(
                                planName: widget.plan.name,
                                price: widget.plan.price,
                              ),
                            ),
                          );
                        }
                      : null,
                  child: const Text(
                    'Complete Payment',
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

  Widget _buildPaymentMethodCard({
    required String title,
    required IconData icon,
    required String value,
  }) {
    final isSelected = selectedPaymentMethod == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFF0D6EFD) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? const Color(0xFF0D6EFD).withOpacity(0.05)
              : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF0D6EFD) : Colors.grey[400],
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.black : Colors.grey[600],
                ),
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: selectedPaymentMethod,
              onChanged: (val) {
                setState(() {
                  selectedPaymentMethod = val!;
                });
              },
              activeColor: const Color(0xFF0D6EFD),
            ),
          ],
        ),
      ),
    );
  }
}
