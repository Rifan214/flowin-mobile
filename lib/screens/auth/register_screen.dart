import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'login_screen.dart';
import 'register_success_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Flowin',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.primary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/login_water.jpg',
                width: double.infinity,
                height: 190,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Register',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Create your account to start managing your premium water deliveries today.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Username',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              decoration: InputDecoration(
                hintText:
                    'Choose a unique username',
                prefixIcon: const Icon(
                  Icons.person_outline,
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Password',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              obscureText: obscurePassword,
              decoration: InputDecoration(
                hintText:
                    'Create a strong password',
                prefixIcon: const Icon(
                  Icons.lock_outline,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons
                            .visibility_outlined
                        : Icons
                            .visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword =
                          !obscurePassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Phone',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              keyboardType:
                  TextInputType.phone,
              decoration: InputDecoration(
                hintText:
                    '+1 (555) 000-0000',
                prefixIcon: const Icon(
                  Icons.phone_outlined,
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Address',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    'Enter your full delivery address',
                prefixIcon: const Padding(
                  padding:
                      EdgeInsets.only(
                    bottom: 70,
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text:
                        'By registering, you agree to our ',
                  ),
                  TextSpan(
                    text:
                        'Terms of Service',
                    style: TextStyle(
                      color:
                          AppColors.primary,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' and ',
                  ),
                  TextSpan(
                    text:
                        'Privacy Policy',
                    style: TextStyle(
                      color:
                          AppColors.primary,
                    ),
                  ),
                  TextSpan(
                    text: '.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const RegisterSuccessScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      color:
                          Colors.black87,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'Already have an account? ',
                      ),
                      TextSpan(
                        text:
                            'Sign In',
                        style:
                            TextStyle(
                          color:
                              AppColors.primary,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}