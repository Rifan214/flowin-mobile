import 'package:flutter/material.dart';

import '../core/design_system/flowin_colors.dart';
import '../core/design_system/flowin_spacing.dart';
import '../core/design_system/flowin_typography.dart';
import '../core/utils/flowin_validators.dart';
import '../shared/widgets/flowin_button.dart';
import '../shared/widgets/flowin_text_field.dart';
import '../shared/widgets/flowin_toast.dart';
import '../state/flowin_app_state.dart';

/// Lifecycle-safe stateful modal sheet for adding a demo payment method.
///
/// Validates required form fields before adding to [FlowinAppState], reads
/// controller values before closing the route, and disposes controllers inside
/// [State.dispose] after the exit transition settles.
class AddPaymentMethodSheet extends StatefulWidget {
  const AddPaymentMethodSheet({
    super.key,
    required this.onSave,
    this.submitLabel = 'Save Method',
  });

  final void Function(String label, String subtitle) onSave;
  final String submitLabel;

  /// Opens the payment-method sheet, updates [FlowinAppState], and notifies the
  /// user once the sheet closes safely.
  static Future<void> show(
    BuildContext context, {
    String submitLabel = 'Save Method',
  }) async {
    final appState = FlowinScope.read(context);
    final addedLabel = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddPaymentMethodSheet(
        submitLabel: submitLabel,
        onSave: (label, subtitle) {
          appState.addPaymentMethod(label, subtitle);
        },
      ),
    );
    if (addedLabel != null && context.mounted) {
      FlowinToast.show(
        context,
        title: 'Payment Method Saved',
        message: '$addedLabel selected for checkout.',
        type: FlowinToastType.success,
      );
    }
  }

  @override
  State<AddPaymentMethodSheet> createState() => _AddPaymentMethodSheetState();
}

class _AddPaymentMethodSheetState extends State<AddPaymentMethodSheet> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _subtitleController = TextEditingController();

  @override
  void dispose() {
    _labelController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final label = _labelController.text.trim();
    final subtitle = _subtitleController.text.trim();
    widget.onSave(label, subtitle);
    Navigator.of(context).pop(label);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 24),
          child: Form(
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
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Add Payment Method',
                  style: FlowinTypography.headlineMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'Save a simulated e-wallet or bank label for fast frontend checkout.',
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
                        Icons.shield_outlined,
                        size: 18,
                        color: FlowinColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Demo checkout only — no real card numbers or billing details required.',
                          style: FlowinTypography.caption.copyWith(
                            color: FlowinColors.inkSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                FlowinTextField(
                  label: 'Method Name',
                  hint: 'e.g. GoPay Wallet or Demo Bank',
                  controller: _labelController,
                  prefixIcon: Icons.account_balance_wallet_outlined,
                  validator: (value) => FlowinValidators.requiredText(
                    value,
                    fieldName: 'Method name',
                    minLength: 2,
                  ),
                ),
                const SizedBox(height: 12),
                FlowinTextField(
                  label: 'Account / Reference Note',
                  hint: 'e.g. Linked +62 812... (simulation)',
                  controller: _subtitleController,
                  prefixIcon: Icons.credit_card_outlined,
                  validator: (value) => FlowinValidators.requiredText(
                    value,
                    fieldName: 'Account note',
                    minLength: 3,
                  ),
                ),
                const SizedBox(height: 20),
                FlowinButton(
                  label: widget.submitLabel,
                  icon: Icons.add_card_rounded,
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

