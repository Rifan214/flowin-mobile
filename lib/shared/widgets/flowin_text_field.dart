import 'package:flutter/material.dart';

import '../../core/design_system/flowin_colors.dart';
import '../../core/design_system/flowin_motion.dart';
import '../../core/design_system/flowin_spacing.dart';
import '../../core/design_system/flowin_typography.dart';

/// Polished text input with animated focus container & smooth password toggle.
class FlowinTextField extends StatefulWidget {
  const FlowinTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.prefixIcon,
    this.suffix,
    this.isPassword = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.maxLines = 1,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool isPassword;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final int maxLines;

  @override
  State<FlowinTextField> createState() => _FlowinTextFieldState();
}

class _FlowinTextFieldState extends State<FlowinTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _obscured = true;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (mounted) {
        setState(() => _hasFocus = _focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: FlowinTypography.caption.copyWith(
            color: _hasFocus ? FlowinColors.primary : FlowinColors.ink,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: FlowinMotion.resolve(context, FlowinDurations.fast),
          decoration: BoxDecoration(
            borderRadius: FlowinRadii.input,
            boxShadow: _hasFocus
                ? [
                    BoxShadow(
                      color: FlowinColors.primary.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: TextFormField(
            focusNode: _focusNode,
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscured : false,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            onChanged: widget.onChanged,
            readOnly: widget.readOnly,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            style: FlowinTypography.bodyLarge.copyWith(fontSize: 14.5),
            decoration: InputDecoration(
              hintText: widget.hint,
              errorMaxLines: 2,
              fillColor: _hasFocus ? FlowinColors.surface : FlowinColors.surfaceSubtle,
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      size: 20,
                      color: _hasFocus ? FlowinColors.primary : FlowinColors.inkMuted,
                    )
                  : null,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      onPressed: () => setState(() => _obscured = !_obscured),
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: Icon(
                          _obscured
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          key: ValueKey(_obscured),
                          size: 20,
                          color: FlowinColors.inkSecondary,
                        ),
                      ),
                    )
                  : widget.suffix,
            ),
          ),
        ),
      ],
    );
  }
}

