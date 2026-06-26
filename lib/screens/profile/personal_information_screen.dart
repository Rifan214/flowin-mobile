import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({
    super.key,
  });

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState
    extends State<PersonalInformationScreen> {
  final usernameController =
      TextEditingController(
    text: 'alex_rivers88',
  );

  final passwordController =
      TextEditingController(
    text: 'password123',
  );

  final addressController =
      TextEditingController(
    text:
        '124 Eco Park Avenue\nGreen District\nSeattle, WA 98101',
  );

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xffF6F8FC),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),

          child: Column(
            children: [
                            Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(
                          context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                    ),
                  ),

                  const Expanded(
                    child: Text(
                      'Personal Information',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 48,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              Stack(
                clipBehavior:
                    Clip.none,
                alignment:
                    Alignment.bottomRight,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration:
                        BoxDecoration(
                      shape:
                          BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                      image:
                          const DecorationImage(
                        image: AssetImage(
                          'assets/images/profile.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: -4,
                    right: -4,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration:
                          const BoxDecoration(
                        color:
                            AppColors.primary,
                        shape:
                            BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color:
                            Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              const Text(
                'Alex Rivers',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Premium Member Since 2023',
                style: TextStyle(
                  color:
                      Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 34),
                            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'alex_rivers88',
                  prefixIcon: const Icon(
                    Icons.person_outline,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  enabledBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                    borderSide:
                        const BorderSide(
                      color:
                          AppColors.primary,
                      width: 1.6,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 26),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: passwordController,
                obscureText:
                    obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
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
                          ? Icons.visibility_outlined
                          : Icons
                              .visibility_off_outlined,
                    ),
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  contentPadding:
                      const EdgeInsets.symmetric(
                    vertical: 20,
                  ),

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),

                  enabledBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),

                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                    borderSide:
                        const BorderSide(
                      color:
                          AppColors.primary,
                      width: 1.6,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 26),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Delivery Address',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller:
                    addressController,
                maxLines: 4,
                decoration: InputDecoration(
                  alignLabelWithHint:
                      true,

                  prefixIcon:
                      const Padding(
                    padding:
                        EdgeInsets.only(
                      bottom: 82,
                    ),
                    child: Icon(
                      Icons
                          .location_on_outlined,
                    ),
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),

                  enabledBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                    borderSide: BorderSide(
                      color:
                          Colors.grey.shade300,
                    ),
                  ),

                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                    borderSide:
                        const BorderSide(
                      color:
                          AppColors.primary,
                      width: 1.6,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 34),
                            SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        AppColors.primary,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(
                            context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Profile updated successfully.',
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const SizedBox(height: 34),

              Divider(
                color: Colors.grey.shade300,
              ),

              const SizedBox(height: 28),

              Align(
                alignment:
                    Alignment.centerLeft,
                child: Text(
                  'Account Preferences',
                  style: TextStyle(
                    fontSize: 15,
                    color:
                        Colors.grey.shade800,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 16),
                            Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                  border: Border.all(
                    color:
                        Colors.grey.shade300,
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.credit_card,
                      ),
                      title: const Text(
                        'Payment Methods',
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                      ),
                      onTap: () {},
                    ),

                    Divider(
                      height: 1,
                      color:
                          Colors.grey.shade300,
                    ),

                    ListTile(
                      leading: const Icon(
                        Icons
                            .verified_user_outlined,
                      ),
                      title: const Text(
                        'Privacy & Security',
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
                          ],
          ),
        ),
      ),
    );
  }
}