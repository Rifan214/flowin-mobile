import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../main_navigation_screen.dart';
import '../notification/notification_screen.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  int? _openQuestion;

  static const _questions = [
    (
      question: 'Where is my order?',
      answer:
          'Open the Orders tab and select your active order to see its latest '
          'delivery status.',
    ),
    (
      question: 'How do refunds work?',
      answer:
          'Approved refunds are returned to your original payment method within '
          '3-7 business days.',
    ),
    (
      question: 'Can I change my delivery slot?',
      answer:
          'Yes. You can update the delivery slot from your order details before '
          'the order is prepared.',
    ),
  ];

  void _showAction(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _goToTab(int index) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => MainNavigationScreen(initialIndex: index),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFD),
      appBar: AppBar(
        toolbarHeight: 58,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.black12,
        shape: const Border(bottom: BorderSide(color: Color(0xFFE6EAF0))),
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.menu, size: 23),
        ),
        centerTitle: true,
        title: const Text(
          'Flowin',
          style: TextStyle(
            color: Color(0xFF0047B7),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationScreen()),
              );
            },
            icon: const Icon(Icons.notifications_none_rounded, size: 23),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 44, 22, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Hi there, how can we help?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Find answers quickly or get in touch with our team.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF667085), fontSize: 12),
                ),
              ),
              const SizedBox(height: 28),
              _ContactCard(
                icon: Icons.chat_outlined,
                title: 'Live Chat',
                subtitle: 'Typically replies in under 2 mins',
                highlighted: true,
                onTap: () => _showAction('Opening live chat...'),
              ),
              const SizedBox(height: 16),
              _ContactCard(
                icon: Icons.phone_outlined,
                title: 'Call Support',
                subtitle: 'Available Mon-Fri, 9am-6pm',
                onTap: () => _showAction('Call support selected'),
              ),
              const SizedBox(height: 16),
              _ContactCard(
                icon: Icons.mail_outline_rounded,
                title: 'Email Support',
                subtitle:
                    "Drop us a line and we'll get back to you within 24\nhours with a comprehensive resolution.",
                onTap: () => _showAction('Email support selected'),
              ),
              const SizedBox(height: 54),
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              for (var index = 0; index < _questions.length; index++) ...[
                _FaqTile(
                  question: _questions[index].question,
                  answer: _questions[index].answer,
                  isOpen: _openQuestion == index,
                  onTap: () {
                    setState(() {
                      _openQuestion = _openQuestion == index ? null : index;
                    });
                  },
                ),
                if (index != _questions.length - 1) const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 72,
        selectedIndex: 3,
        onDestinationSelected: _goToTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final foreground = highlighted ? Colors.white : const Color(0xFF101828);

    return Material(
      color: highlighted ? const Color(0xFF0866C9) : Colors.white,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 118),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: highlighted
                  ? const Color(0xFF0866C9)
                  : const Color(0xFFD8DEE9),
            ),
            boxShadow: highlighted
                ? const [
                    BoxShadow(
                      color: Color(0x240866C9),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: highlighted
                      ? const Color(0xFF3B82D3)
                      : const Color(0xFFE6F0FD),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(
                  icon,
                  color: highlighted ? Colors.white : AppColors.primary,
                  size: 19,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  color: foreground,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: highlighted
                      ? const Color(0xFFE8F2FF)
                      : const Color(0xFF475467),
                  fontSize: 11,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({
    required this.question,
    required this.answer,
    required this.isOpen,
    required this.onTap,
  });

  final String question;
  final String answer;
  final bool isOpen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 15, 12, 15),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD8DEE9)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      question,
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isOpen ? .5 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: Color(0xFF475467),
                    ),
                  ),
                ],
              ),
              if (isOpen) ...[
                const SizedBox(height: 10),
                Text(
                  answer,
                  style: const TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
