import 'package:flutter/material.dart';

import '../../core/animations/flowin_page_routes.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../shared/widgets/flowin_button.dart';
import '../../shared/widgets/flowin_text_field.dart';
import '../../shared/widgets/flowin_toast.dart';
import '../../state/flowin_app_state.dart';
import '../../widgets/flowin_header.dart';
import '../../widgets/settings_section.dart';
import '../../widgets/settings_tile.dart';
import '../subscription/subscription_screen.dart';
import 'payment_methods_screen.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final appState = FlowinScope.read(context);
      _nameController = TextEditingController(text: appState.userName);
      _emailController = TextEditingController(text: appState.userEmail);
      _phoneController = TextEditingController(text: appState.userPhone);
      _addressController =
          TextEditingController(text: appState.deliveryAddress);
      _initialized = true;
    }
  }

  @override
  void dispose() {
    if (_initialized) {
      _nameController.dispose();
      _emailController.dispose();
      _phoneController.dispose();
      _addressController.dispose();
    }
    super.dispose();
  }

  void _save(FlowinAppState appState) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    appState.updateProfile(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
    );
    appState.updateDeliveryAddress(
      title: appState.deliveryTitle,
      address: _addressController.text,
    );
    FlowinToast.show(
      context,
      title: 'Profile Updated',
      message: 'Saved changes for ${appState.userName}.',
      type: FlowinToastType.success,
    );
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = FlowinScope.of(context);

    return Scaffold(
      backgroundColor: FlowinColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const FlowinHeader(
              title: 'Personal Info',
              rightIcon: SizedBox(width: 42),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Clean Profile Avatar Crest
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          gradient: FlowinColors.oceanGradient,
                          shape: BoxShape.circle,
                          boxShadow: FlowinShadows.primaryGlow,
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        appState.userName,
                        style: FlowinTypography.titleLarge,
                      ),
                      Text(
                        'Verified Flowin Subscriber',
                        style: FlowinTypography.caption,
                      ),
                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: FlowinColors.surface,
                          borderRadius: FlowinRadii.card,
                          boxShadow: FlowinShadows.cardSoft,
                          border: Border.all(color: FlowinColors.border),
                        ),
                        child: Column(
                          children: [
                            FlowinTextField(
                              label: 'Full Name',
                              controller: _nameController,
                              prefixIcon: Icons.person_outline_rounded,
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? 'Name is required'
                                  : null,
                            ),
                            const SizedBox(height: 14),
                            FlowinTextField(
                              label: 'Email Address',
                              controller: _emailController,
                              prefixIcon: Icons.mail_outline_rounded,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => v == null || !v.contains('@')
                                  ? 'Enter a valid email'
                                  : null,
                            ),
                            const SizedBox(height: 14),
                            FlowinTextField(
                              label: 'Phone Number',
                              controller: _phoneController,
                              prefixIcon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 14),
                            FlowinTextField(
                              label: 'Primary Delivery Address',
                              controller: _addressController,
                              prefixIcon: Icons.location_on_outlined,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      SettingsSection(
                        title: 'Quick Links',
                        children: [
                          SettingsTile(
                            icon: Icons.credit_card_rounded,
                            title: 'Manage Payment Methods',
                            subtitle: appState.selectedPaymentMethod.label,
                            onTap: () {
                              Navigator.push(
                                context,
                                FlowinPageRoute.sharedAxis(
                                  const PaymentMethodsScreen(),
                                ),
                              );
                            },
                          ),
                          SettingsTile(
                            icon: Icons.autorenew_rounded,
                            title: 'Hydration Subscription',
                            subtitle: appState.activeSubscription?.title ??
                                'No active plan',
                            onTap: () {
                              Navigator.push(
                                context,
                                FlowinPageRoute.sharedAxis(
                                  const SubscriptionScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
              child: FlowinButton(
                label: 'Save Changes',
                icon: Icons.check_rounded,
                onPressed: () => _save(appState),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
