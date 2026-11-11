import 'package:flutter/material.dart';

import '../core/animations/app_haptics.dart';
import '../core/design_system/flowin_colors.dart';
import '../core/design_system/flowin_motion.dart';
import '../core/design_system/flowin_spacing.dart';
import '../core/design_system/flowin_typography.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({
    super.key,
    this.query = '',
    this.onChanged,
    this.onFilterTap,
    this.hasActiveFilters = false,
  });

  final String query;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final bool hasActiveFilters;

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
    _focusNode.addListener(() {
      if (mounted) setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void didUpdateWidget(covariant SearchBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != _controller.text) {
      _controller.text = widget.query;
      _controller.selection = TextSelection.collapsed(offset: widget.query.length);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: FlowinMotion.resolve(context, FlowinDurations.fast),
      height: 54,
      decoration: BoxDecoration(
        color: FlowinColors.surface,
        borderRadius: FlowinRadii.input,
        border: Border.all(
          color: _focused ? FlowinColors.primary : FlowinColors.border,
          width: _focused ? 1.5 : 1.0,
        ),
        boxShadow: _focused ? FlowinShadows.cardElevated : FlowinShadows.cardSoft,
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(
            Icons.search_rounded,
            size: 21,
            color: _focused ? FlowinColors.primary : FlowinColors.inkSecondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              style: FlowinTypography.bodyLarge.copyWith(fontSize: 14.5),
              decoration: InputDecoration(
                hintText: 'Search Aqua, Le Minerale, 19L...',
                hintStyle: FlowinTypography.bodyMedium.copyWith(
                  color: FlowinColors.inkMuted,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 18),
              color: FlowinColors.inkSecondary,
              onPressed: () {
                _controller.clear();
                widget.onChanged?.call('');
              },
            ),
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Material(
              color: widget.hasActiveFilters
                  ? FlowinColors.primary
                  : FlowinColors.cyanMist,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  AppHaptics.light();
                  widget.onFilterTap?.call();
                },
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.tune_rounded,
                        size: 19,
                        color: widget.hasActiveFilters
                            ? Colors.white
                            : FlowinColors.primary,
                      ),
                      if (widget.hasActiveFilters)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: FlowinColors.amber,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
