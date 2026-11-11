import 'package:flutter/material.dart';

import '../core/design_system/flowin_colors.dart';
import '../core/design_system/flowin_typography.dart';
import '../core/utils/flowin_validators.dart';
import '../shared/widgets/flowin_button.dart';
import '../shared/widgets/flowin_text_field.dart';
import '../shared/widgets/flowin_toast.dart';
import '../state/flowin_app_state.dart';

/// Lifecycle-safe stateful modal sheet for editing the active delivery address.
///
/// Owns its [TextEditingController] instances inside [State] so they remain
/// valid throughout the entire bottom-sheet exit transition and keyboard close
/// animation, disposing only after the route unmounts.
class DeliveryAddressEditorSheet extends StatefulWidget {
  const DeliveryAddressEditorSheet({
    super.key,
    required this.initialTitle,
    required this.initialAddress,
    required this.onSave,
  });

  final String initialTitle;
  final String initialAddress;
  final void Function(String title, String address) onSave;

  /// Opens the delivery address sheet, updates [FlowinAppState], and shows a
  /// confirmation toast once the sheet has closed cleanly.
  static Future<void> show(BuildContext context) async {
    final appState = FlowinScope.read(context);
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => DeliveryAddressEditorSheet(
        initialTitle: appState.deliveryTitle,
        initialAddress: appState.deliveryAddress,
        onSave: (title, address) {
          appState.updateDeliveryAddress(title: title, address: address);
        },
      ),
    );
    if (saved == true && context.mounted) {
      FlowinToast.show(
        context,
        title: 'Address Updated',
        message: appState.deliveryAddress,
        type: FlowinToastType.success,
      );
    }
  }

  @override
  State<DeliveryAddressEditorSheet> createState() =>
      _DeliveryAddressEditorSheetState();
}

class _DeliveryAddressEditorSheetState
    extends State<DeliveryAddressEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _addressController = TextEditingController(text: widget.initialAddress);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final title = _titleController.text.trim();
    final address = _addressController.text.trim();
    widget.onSave(title, address);
    Navigator.of(context).pop(true);
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
                  'Edit Delivery Address',
                  style: FlowinTypography.headlineMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'Update your drop-off label and full street address for courier dispatch.',
                  style: FlowinTypography.bodyMedium,
                ),
                const SizedBox(height: 16),
                FlowinTextField(
                  label: 'Address Label',
                  hint: 'e.g. Home • Evergreen Residence',
                  controller: _titleController,
                  prefixIcon: Icons.label_outline_rounded,
                  validator: (value) => FlowinValidators.requiredText(
                    value,
                    fieldName: 'Address label',
                    minLength: 2,
                  ),
                ),
                const SizedBox(height: 12),
                FlowinTextField(
                  label: 'Full Street Address',
                  hint: 'Street, building, floor, or gate notes',
                  controller: _addressController,
                  prefixIcon: Icons.location_on_outlined,
                  maxLines: 2,
                  validator: (value) => FlowinValidators.requiredText(
                    value,
                    fieldName: 'Delivery address',
                    minLength: 6,
                  ),
                ),
                const SizedBox(height: 20),
                FlowinButton(
                  label: 'Save Address',
                  icon: Icons.check_circle_outline_rounded,
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

