import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/animations/flowin_page_routes.dart';
import '../../core/animations/staggered_reveal.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../core/utils/flowin_validators.dart';
import '../../shared/widgets/flowin_button.dart';
import '../../shared/widgets/flowin_text_field.dart';
import '../../shared/widgets/flowin_toast.dart';
import '../../shared/widgets/organic_wave_clipper.dart';
import '../main_navigation_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController =
      TextEditingController(text: 'alex.morgan@flowin.id');
  final _passwordController = TextEditingController(text: '••••••••');
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      FlowinToast.show(
        context,
        title: 'Check your credentials',
        message: 'Please enter a valid email and password to continue.',
        type: FlowinToastType.warning,
      );
      return;
    }
    setState(() => _submitting = true);
    Navigator.pushReplacement(
      context,
      FlowinPageRoute.fadeScale(const MainNavigationScreen()),
    );
  }

  Future<void> _openForgotPasswordSheet() async {
    final completed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _ForgotPasswordSheet(
        initialEmail: _emailController.text.trim(),
      ),
    );
    if (completed == true && mounted) {
      FlowinToast.show(
        context,
        title: 'Recovery Simulation Completed',
        message: 'Returned cleanly to sign in.',
        type: FlowinToastType.info,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: FlowinColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Organic coastal wave hero header
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipPath(
                  clipper: const OrganicWaveClipper(waveDepth: 34),
                  child: SizedBox(
                    height: 248,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/login_water.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            decoration: const BoxDecoration(
                              gradient: FlowinColors.deepSplashGradient,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                FlowinColors.deepOcean.withValues(alpha: 0.72),
                                FlowinColors.primary.withValues(alpha: 0.85),
                              ],
                            ),
                          ),
                        ),
                        SafeArea(
                          bottom: false,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 24, 24, 42),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.water_drop_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'Welcome Back',
                                  style: FlowinTypography.displayHero.copyWith(
                                    color: Colors.white,
                                    fontSize: 28,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Stay refreshed with doorstep gallon delivery.',
                                  style: FlowinTypography.bodyMedium.copyWith(
                                    color: Colors.white.withValues(alpha: 0.86),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Elevated Sign-In Card
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 28),
              child: StaggeredReveal(
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: FlowinColors.surface,
                    borderRadius: FlowinRadii.card,
                    boxShadow: FlowinShadows.cardElevated,
                    border: Border.all(color: FlowinColors.border),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FlowinTextField(
                          label: 'Email or Phone',
                          hint: 'Enter your email address',
                          controller: _emailController,
                          prefixIcon: Icons.alternate_email_rounded,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Email cannot be empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        FlowinTextField(
                          label: 'Password',
                          hint: 'Enter your password',
                          controller: _passwordController,
                          prefixIcon: Icons.lock_outline_rounded,
                          isPassword: true,
                          validator: (v) {
                            if (v == null || v.trim().length < 4) {
                              return 'Enter at least 4 characters';
                            }
                            return null;
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _openForgotPasswordSheet,
                            child: Text(
                              'Forgot Password?',
                              style: FlowinTypography.caption.copyWith(
                                color: FlowinColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        FlowinButton(
                          label: 'Sign In',
                          isLoading: _submitting,
                          trailingIcon: Icons.arrow_forward_rounded,
                          onPressed: _signIn,
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'or continue with',
                                style: FlowinTypography.caption.copyWith(
                                  color: FlowinColors.inkMuted,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: FlowinButton(
                                label: 'Google',
                                variant: FlowinButtonVariant.outlined,
                                height: 48,
                                icon: Icons.g_mobiledata_rounded,
                                onPressed: () {
                                  FlowinToast.show(
                                    context,
                                    title: 'Signed in via Google',
                                    message: 'Welcome back, Alex Morgan!',
                                    type: FlowinToastType.success,
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    FlowinPageRoute.fadeScale(
                                      const MainNavigationScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FlowinButton(
                                label: 'Apple',
                                variant: FlowinButtonVariant.outlined,
                                height: 48,
                                icon: Icons.apple_rounded,
                                onPressed: () {
                                  FlowinToast.show(
                                    context,
                                    title: 'Signed in via Apple',
                                    message: 'Welcome back, Alex Morgan!',
                                    type: FlowinToastType.success,
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    FlowinPageRoute.fadeScale(
                                      const MainNavigationScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'New to Flowin?',
                    style: FlowinTypography.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        FlowinPageRoute.sharedAxis(const RegisterScreen()),
                      );
                    },
                    child: Text(
                      'Create Account',
                      style: FlowinTypography.titleMedium.copyWith(
                        color: FlowinColors.primary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      ),
    );
  }
}

class _ForgotPasswordSheet extends StatefulWidget {
  const _ForgotPasswordSheet({required this.initialEmail});

  final String initialEmail;

  @override
  State<_ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<_ForgotPasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  String? _simulatedEmail;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() {
      _simulatedEmail = _emailController.text.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final completedEmail = _simulatedEmail;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
          child: completedEmail != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: FlowinColors.border,
                          borderRadius: FlowinRadii.fullPill,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: FlowinColors.cyanMist,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.mark_email_read_rounded,
                          color: FlowinColors.primary,
                          size: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Recovery Simulation Completed',
                      textAlign: TextAlign.center,
                      style: FlowinTypography.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Recovery link simulation completed for $completedEmail. If this were a connected service, a reset email would be sent to your address.',
                      textAlign: TextAlign.center,
                      style: FlowinTypography.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    FlowinButton(
                      label: 'Back to Login',
                      icon: Icons.arrow_back_rounded,
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                )
              : Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: FlowinColors.border,
                            borderRadius: FlowinRadii.fullPill,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Reset Password',
                        style: FlowinTypography.headlineMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Enter your registered Flowin email address to simulate a password recovery request.',
                        style: FlowinTypography.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: FlowinColors.cyanTint,
                          borderRadius: FlowinRadii.innerCard,
                          border: Border.all(color: FlowinColors.cyanMist),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              size: 18,
                              color: FlowinColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Frontend demo — no real recovery email is sent.',
                                style: FlowinTypography.caption.copyWith(
                                  color: FlowinColors.inkSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      FlowinTextField(
                        label: 'Email Address',
                        hint: 'name@flowin.id',
                        controller: _emailController,
                        prefixIcon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        validator: FlowinValidators.email,
                      ),
                      const SizedBox(height: 18),
                      FlowinButton(
                        label: 'Send Recovery Link',
                        icon: Icons.mark_email_read_outlined,
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
