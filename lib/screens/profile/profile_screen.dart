import 'package:flutter/material.dart';

import '../../core/animations/flowin_page_routes.dart';
import '../../core/animations/staggered_reveal.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../shared/widgets/flowin_button.dart';
import '../../shared/widgets/flowin_toast.dart';
import '../../state/flowin_app_state.dart';
import '../../widgets/flowin_header.dart';
import '../../widgets/profile_header_card.dart';
import '../../widgets/settings_section.dart';
import '../../widgets/settings_tile.dart';
import '../auth/login_screen.dart';
import '../subscription/subscription_screen.dart';
import 'payment_methods_screen.dart';
import 'personal_information_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Sign Out of Flowin?', style: FlowinTypography.titleLarge),
        content: Text(
          'You will return to the sign-in screen. Your saved delivery preferences stay intact.',
          style: FlowinTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Stay Signed In'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: FlowinColors.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                FlowinPageRoute.fadeScale(const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = FlowinScope.of(context);
    final activePlan = appState.activeSubscription;

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const FlowinHeader(title: 'Profile', showBackButton: false),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                4,
                20,
                FlowinSpacing.navBarClearance + 22,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StaggeredReveal(
                    index: 0,
                    child: ProfileHeaderCard(
                      onEditPressed: () {
                        Navigator.push(
                          context,
                          FlowinPageRoute.sharedAxis(
                            const PersonalInformationScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Quick Account Metrics
                  StaggeredReveal(
                    index: 1,
                    child: Row(
                      children: [
                        Expanded(
                          child: _ProfileStatTile(
                            label: 'Flowin Pay',
                            value: FlowinFormat.currency(appState.walletBalance),
                            icon: Icons.account_balance_wallet_rounded,
                            color: FlowinColors.primary,
                            onTap: () {
                              Navigator.push(
                                context,
                                FlowinPageRoute.sharedAxis(
                                  const PaymentMethodsScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ProfileStatTile(
                            label: 'Orders',
                            value: '${appState.orders.length} Total',
                            icon: Icons.local_shipping_rounded,
                            color: FlowinColors.aqua,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  StaggeredReveal(
                    index: 2,
                    child: SettingsSection(
                      title: 'Account & Hydration',
                      children: [
                        SettingsTile(
                          icon: Icons.person_outline_rounded,
                          title: 'Personal Information',
                          subtitle: appState.userPhone,
                          onTap: () {
                            Navigator.push(
                              context,
                              FlowinPageRoute.sharedAxis(
                                const PersonalInformationScreen(),
                              ),
                            );
                          },
                        ),
                        SettingsTile(
                          icon: Icons.autorenew_rounded,
                          title: 'Hydration Subscription',
                          subtitle: activePlan != null
                              ? '${activePlan.title} • Active'
                              : 'Auto-refill & save up to 20%',
                          trailingText: activePlan != null ? 'Active' : 'Explore',
                          onTap: () {
                            Navigator.push(
                              context,
                              FlowinPageRoute.sharedAxis(
                                const SubscriptionScreen(),
                              ),
                            );
                          },
                        ),
                        SettingsTile(
                          icon: Icons.credit_card_rounded,
                          title: 'Payment Methods',
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  StaggeredReveal(
                    index: 3,
                    child: SettingsSection(
                      title: 'Smart Preferences',
                      children: [
                        SettingsTile(
                          icon: Icons.notifications_active_outlined,
                          title: 'Delivery Push Alerts',
                          subtitle: 'Courier arrival & order milestones',
                          trailing: Switch.adaptive(
                            value: appState.notificationsEnabled,
                            activeTrackColor: FlowinColors.primary,
                            onChanged: (v) {
                              appState.setNotificationsEnabled(v);
                              FlowinToast.show(
                                context,
                                title: v
                                    ? 'Delivery Alerts Enabled'
                                    : 'Delivery Alerts Paused',
                                type: FlowinToastType.info,
                                duration: const Duration(milliseconds: 1600),
                              );
                            },
                          ),
                        ),
                        SettingsTile(
                          icon: Icons.water_drop_outlined,
                          title: 'Auto-Refill Reminders',
                          subtitle: 'Weekly low-gallon hydration check-in',
                          trailing: Switch.adaptive(
                            value: appState.autoRefillReminder,
                            activeTrackColor: FlowinColors.primary,
                            onChanged: (v) {
                              appState.setAutoRefillReminder(v);
                              FlowinToast.show(
                                context,
                                title: v
                                    ? 'Refill Reminders On'
                                    : 'Refill Reminders Off',
                                type: FlowinToastType.info,
                                duration: const Duration(milliseconds: 1600),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  FlowinButton(
                    label: 'Sign Out',
                    icon: Icons.logout_rounded,
                    variant: FlowinButtonVariant.danger,
                    onPressed: () => _confirmLogout(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStatTile extends StatelessWidget {
  const _ProfileStatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FlowinColors.surface,
      borderRadius: FlowinRadii.card,
      child: InkWell(
        borderRadius: FlowinRadii.card,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: FlowinRadii.card,
            boxShadow: FlowinShadows.cardSoft,
            border: Border.all(color: FlowinColors.border.withValues(alpha: 0.7)),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, size: 19, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: FlowinTypography.caption.copyWith(fontSize: 11),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        value,
                        maxLines: 1,
                        style: FlowinTypography.titleMedium.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
