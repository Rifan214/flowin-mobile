import 'package:flutter/material.dart';

import '../../core/animations/app_haptics.dart';
import '../../core/animations/liquid_wave_painter.dart';
import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';
import '../../shared/widgets/animated_price_text.dart';
import '../../shared/widgets/flowin_button.dart';
import '../../shared/widgets/flowin_toast.dart';
import '../../state/flowin_app_state.dart';
import '../../widgets/add_payment_method_sheet.dart';
import '../../widgets/flowin_header.dart';
import '../../widgets/payment_method_card.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  void _openTopUpSheet(BuildContext context, FlowinAppState appState) {
    const amounts = [50000, 100000, 250000];
    int chosen = amounts[1];

    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Top Up Flowin Pay', style: FlowinTypography.headlineMedium),
              const SizedBox(height: 6),
              Text(
                'Choose an instant reload amount for faster one-tap checkouts.',
                style: FlowinTypography.bodyMedium,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                children: amounts.map((amt) {
                  final active = chosen == amt;
                  return ChoiceChip(
                    label: Text(FlowinFormat.currency(amt)),
                    selected: active,
                    selectedColor: FlowinColors.cyanMist,
                    onSelected: (_) => setModalState(() => chosen = amt),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              FlowinButton(
                label: 'Confirm Top Up • ${FlowinFormat.currency(chosen)}',
                onPressed: () {
                  AppHaptics.confirm();
                  appState.topUpWallet(chosen);
                  Navigator.pop(ctx);
                  if (!context.mounted) return;
                  FlowinToast.show(
                    context,
                    title: 'Wallet Reloaded',
                    message:
                        '+${FlowinFormat.currency(chosen)} added to Flowin Pay.',
                    type: FlowinToastType.success,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openAddMethodSheet(BuildContext context, FlowinAppState _) {
    AddPaymentMethodSheet.show(
      context,
      submitLabel: 'Save Payment Method',
    );
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
              title: 'Payment Methods',
              rightIcon: SizedBox(width: 42),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Flowin Pay Digital Wallet Card
                    Container(
                      decoration: BoxDecoration(
                        gradient: FlowinColors.oceanGradient,
                        borderRadius: FlowinRadii.card,
                        boxShadow: FlowinShadows.primaryGlow,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: LiquidWaveBackdrop(
                        fillLevel: 0.35,
                        waveAmplitude: 9,
                        frontColor: FlowinColors.aquaBright.withValues(alpha: 0.2),
                        backColor: FlowinColors.deepOcean.withValues(alpha: 0.25),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'FLOWIN PAY BALANCE',
                                      style: FlowinTypography.overline.copyWith(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    AnimatedPriceText(
                                      amount: appState.walletBalance,
                                      style: FlowinTypography.displayHero.copyWith(
                                        color: Colors.white,
                                        fontSize: 26,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Auto-applied when selected at checkout',
                                      style: FlowinTypography.caption.copyWith(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: FlowinColors.primary,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: FlowinRadii.innerCard,
                                  ),
                                ),
                                onPressed: () =>
                                    _openTopUpSheet(context, appState),
                                icon: const Icon(Icons.add_rounded, size: 18),
                                label: const Text('Top Up'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Saved Accounts',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: FlowinTypography.titleLarge,
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () =>
                              _openAddMethodSheet(context, appState),
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('Add New'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    for (final method in appState.paymentMethods)
                      PaymentMethodCard(
                        title: method.label,
                        subtitle: method.isWallet
                            ? 'Balance: ${FlowinFormat.currency(appState.walletBalance)}'
                            : method.subtitle,
                        icon: method.icon,
                        accentColor: method.accentColor,
                        selected: appState.selectedPaymentId == method.id,
                        onTap: () {
                          appState.selectPaymentMethod(method.id);
                          FlowinToast.show(
                            context,
                            title: 'Default Updated',
                            message: '${method.label} set as primary payment.',
                            type: FlowinToastType.info,
                            duration: const Duration(milliseconds: 1600),
                          );
                        },
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
