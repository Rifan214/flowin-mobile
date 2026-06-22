import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F6FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Container(
                width: 70,
                height: 70,
                decoration:
                    BoxDecoration(
                  color:
                      AppColors.primary,
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                ),
                child: const Icon(
                  Icons.water_drop_outlined,
                  color: Colors.white,
                  size: 36,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Flowin',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      AppColors.primary,
                ),
              ),

              const SizedBox(height: 40),

              Container(
                padding:
                    const EdgeInsets.all(24),
                decoration:
                    BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                  border: Border.all(
                    color: const Color(
                      0xFFD9E0EC,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    const Text(
                      'Enter your credentials to manage your water flow.',
                      style: TextStyle(
                        color:
                            Colors.black54,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    const Text(
                      'Username',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    TextField(
                      decoration:
                          InputDecoration(
                        hintText:
                            'john.doe',
                        prefixIcon:
                            const Icon(
                          Icons.person_outline,
                        ),
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Row(
                      children: [
                        const Text(
                          'Password',
                          style:
                              TextStyle(
                            fontWeight:
                                FontWeight
                                    .w600,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed:
                              () {},
                          child:
                              const Text(
                            'Forgot?',
                          ),
                        ),
                      ],
                    ),

                    TextField(
                      obscureText:
                          obscurePassword,
                      decoration:
                          InputDecoration(
                        prefixIcon:
                            const Icon(
                          Icons.lock_outline,
                        ),
                        suffixIcon:
                            IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword =
                                  !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons
                                    .visibility_outlined
                                : Icons
                                    .visibility_off_outlined,
                          ),
                        ),
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    SizedBox(
                      width:
                          double.infinity,
                      height: 56,
                      child:
                          FilledButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const MainNavigationScreen(),
                            ),
                          );
                        },
                        child:
                            const Text(
                          'Login',
                          style:
                              TextStyle(
                            fontSize:
                                18,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    Row(
                      children: [
                        const Expanded(
                          child:
                              Divider(),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal:
                                12,
                          ),
                          child: Text(
                            'or continue with',
                            style:
                                TextStyle(
                              color: Colors
                                  .grey
                                  .shade600,
                            ),
                          ),
                        ),
                        const Expanded(
                          child:
                              Divider(),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    OutlinedButton.icon(
                      onPressed:
                          () {},
                      style:
                          OutlinedButton.styleFrom(
                        minimumSize:
                            const Size(
                          double.infinity,
                          56,
                        ),
                      ),
                      icon: const Icon(
                        Icons.cloud_outlined,
                      ),
                      label: const Text(
                        'Enterprise Single Sign-On',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    color:
                        Colors.black87,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(
                      text:
                          "Don't have an account? ",
                    ),
                    TextSpan(
                      text:
                          "Register",
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

              const SizedBox(height: 40),

              ClipRRect(
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
                child: Image.asset(
                  'assets/images/login_water.png',
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                '© 2024 Flowin Systems. All rights reserved.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              const Text(
                '© 2024 Flowin Systems. All rights reserved.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}