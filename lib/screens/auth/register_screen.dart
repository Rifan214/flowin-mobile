import 'package:flutter/material.dart';

import '../../core/animations/flowin_page_routes.dart';
import '../../core/animations/staggered_reveal.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../shared/widgets/flowin_button.dart';
import '../../shared/widgets/flowin_text_field.dart';
import '../../shared/widgets/flowin_toast.dart';
import '../../widgets/flowin_header.dart';
import 'register_success_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _acceptedTerms = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      FlowinToast.show(
        context,
        title: 'Complete required fields',
        message: 'Check highlighted fields before creating your account.',
        type: FlowinToastType.warning,
      );
      return;
    }
    if (!_acceptedTerms) {
      FlowinToast.show(
        context,
        title: 'Terms Required',
        message: 'Please accept Flowin Terms & Privacy Policy to proceed.',
        type: FlowinToastType.warning,
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      FlowinPageRoute.fadeScale(const RegisterSuccessScreen()),
    );
  }

  void _showTermsSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Flowin Service Terms', style: FlowinTypography.headlineMedium),
            const SizedBox(height: 10),
            Text(
              'Flowin provides closed-loop sanitized gallon refills and scheduled home hydration delivery. Your contact details are strictly used to dispatch couriers and coordinate doorstep drops.',
              style: FlowinTypography.bodyMedium,
            ),
            const SizedBox(height: 20),
            FlowinButton(
              label: 'Got It',
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlowinColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const FlowinHeader(
              title: 'Create Account',
              rightIcon: Icon(Icons.help_outline_rounded),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StaggeredReveal(
                      index: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Join Flowin Hydration',
                            style: FlowinTypography.headlineLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Set up your account for express gallon refills and live courier tracking.',
                            style: FlowinTypography.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    StaggeredReveal(
                      index: 1,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: FlowinColors.surface,
                          borderRadius: FlowinRadii.card,
                          boxShadow: FlowinShadows.cardSoft,
                          border: Border.all(color: FlowinColors.border),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              FlowinTextField(
                                label: 'Full Name',
                                hint: 'Alex Morgan',
                                controller: _nameController,
                                prefixIcon: Icons.person_outline_rounded,
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Please enter your full name'
                                    : null,
                              ),
                              const SizedBox(height: 14),
                              FlowinTextField(
                                label: 'Email Address',
                                hint: 'alex@example.com',
                                controller: _emailController,
                                prefixIcon: Icons.mail_outline_rounded,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) =>
                                    v == null || !v.contains('@')
                                        ? 'Enter a valid email address'
                                        : null,
                              ),
                              const SizedBox(height: 14),
                              FlowinTextField(
                                label: 'Phone Number',
                                hint: '+62 812 8400 2299',
                                controller: _phoneController,
                                prefixIcon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                validator: (v) =>
                                    v == null || v.trim().length < 6
                                        ? 'Enter a valid phone number'
                                        : null,
                              ),
                              const SizedBox(height: 14),
                              FlowinTextField(
                                label: 'Password',
                                hint: 'Minimum 6 characters',
                                controller: _passwordController,
                                prefixIcon: Icons.lock_outline_rounded,
                                isPassword: true,
                                validator: (v) =>
                                    v == null || v.trim().length < 6
                                        ? 'Use at least 6 characters'
                                        : null,
                              ),
                              const SizedBox(height: 14),
                              FlowinTextField(
                                label: 'Confirm Password',
                                hint: 'Re-enter your password',
                                controller: _confirmController,
                                prefixIcon: Icons.verified_user_outlined,
                                isPassword: true,
                                validator: (v) => v != _passwordController.text
                                    ? 'Passwords do not match'
                                    : null,
                              ),
                              const SizedBox(height: 14),

                              Row(
                                children: [
                                  Checkbox(
                                    value: _acceptedTerms,
                                    onChanged: (v) => setState(
                                      () => _acceptedTerms = v ?? false,
                                    ),
                                  ),
                                  Expanded(
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Text(
                                          'I agree to the ',
                                          style: FlowinTypography.caption,
                                        ),
                                        GestureDetector(
                                          onTap: _showTermsSheet,
                                          child: Text(
                                            'Terms & Privacy Policy',
                                            style: FlowinTypography.caption
                                                .copyWith(
                                              color: FlowinColors.primary,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),

                              FlowinButton(
                                label: 'Create Account',
                                trailingIcon: Icons.arrow_forward_rounded,
                                onPressed: _submit,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: FlowinTypography.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Sign In',
                            style: FlowinTypography.titleMedium.copyWith(
                              color: FlowinColors.primary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
