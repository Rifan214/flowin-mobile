import 'package:flutter/material.dart';

import '../../widgets/flowin_header.dart';
import '../../widgets/profile_header_card.dart';
import '../../widgets/settings_section.dart';
import '../../widgets/settings_tile.dart';
import '../subscription/subscription_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FlowinHeader(),

            const SizedBox(height: 24),

            const Text(
              'Account Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Manage your profile, preferences, and security settings.',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 24),

            const ProfileHeaderCard(),

            const SizedBox(height: 20),

            SettingsSection(
              title: 'ACCOUNT',
              children: [
                const SettingsTile(
                  icon: Icons.person_outline,
                  title: 'Personal Information',
                ),

                const Divider(height: 1),

                const SettingsTile(
                  icon: Icons.credit_card,
                  title: 'Payment Methods',
                ),

                const Divider(height: 1),

                SettingsTile(
                  icon: Icons.water_drop_outlined,
                  title: 'Subscription Plan',
                  subtitle: 'Premium Hydration (Active)',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const SubscriptionScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            SettingsSection(
              title: 'PREFERENCES',
              children: [
                const SettingsTile(
                  icon: Icons.notifications_none,
                  title: 'Push Notifications',
                  subtitle: 'Delivery updates & alerts',
                  trailing: Switch(
                    value: true,
                    onChanged: null,
                  ),
                ),

                const Divider(height: 1),

                const SettingsTile(
                  icon: Icons.mail_outline,
                  title: 'Email Newsletters',
                  subtitle: 'Weekly health tips',
                  trailing: Switch(
                    value: false,
                    onChanged: null,
                  ),
                ),

                const Divider(height: 1),

                const SettingsTile(
                  icon: Icons.language,
                  title: 'Language',
                  trailingText: 'English',
                ),
              ],
            ),

            const SettingsSection(
              title: 'SECURITY & LEGAL',
              children: [
                SettingsTile(
                  icon: Icons.lock_outline,
                  title: 'Privacy & Security',
                ),

                Divider(height: 1),

                SettingsTile(
                  icon: Icons.info_outline,
                  title: 'About Application',
                  trailingText: 'v2.4.1',
                ),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                label: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.red,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
} 