import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class IosSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final String hintText;
  final TextEditingController? controller;
  final Duration debounceDuration;

  const IosSearchBar({
    super.key,
    required this.onChanged,
    this.onSubmitted,
    this.hintText = 'Search',
    this.controller,
    this.debounceDuration = const Duration(milliseconds: 300),
  });

  @override
  State<IosSearchBar> createState() => _IosSearchBarState();
}

class _IosSearchBarState extends State<IosSearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  Timer? _debounceTimer;
  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (mounted) {
        setState(() {
          _isFocused = _focusNode.hasFocus;
        });
      }
    });

    _controller.addListener(_onTextChanged);
    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _focusNode.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;
    if (mounted && _hasText != text.isNotEmpty) {
      setState(() {
        _hasText = text.isNotEmpty;
      });
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDuration, () {
      widget.onChanged(text.trim());
    });
  }

  void _clearSearch() {
    _controller.clear();
    _debounceTimer?.cancel();
    widget.onChanged('');
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = double.infinity;
        if (constraints.maxWidth >= 900) {
          maxWidth = 700; // Desktop/Web
        } else if (constraints.maxWidth >= 600) {
          maxWidth = 600; // Tablet
        }

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _focusNode.requestFocus();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F7), // Solid iOS Grey
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: _isFocused
                          ? const Color(0xFFD8D8D8) // Focused border 1px
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Search Icon Left Aligned (18px left padding, 22px size, #B6B6B6 color)
                      const Padding(
                        padding: EdgeInsets.only(left: 18.0, right: 12.0),
                        child: Icon(
                          CupertinoIcons.search,
                          size: 22,
                          color: Color(0xFFB6B6B6),
                        ),
                      ),

                      // Text Input Field
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          cursorColor: AppColors.primary, // Cursor color (#C8104D / primary)
                          textInputAction: TextInputAction.search,
                          onSubmitted: (val) {
                            if (widget.onSubmitted != null) {
                              widget.onSubmitted!(val.trim());
                            }
                          },
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF1E1E1E),
                          ),
                          decoration: InputDecoration(
                            hintText: widget.hintText,
                            hintStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFB9B9B9),
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            isDense: true,
                          ),
                        ),
                      ),

                      // Clear (x) Icon (Shown when text exists)
                      if (_hasText)
                        Padding(
                          padding: const EdgeInsets.only(right: 14.0),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: _clearSearch,
                            child: const Icon(
                              CupertinoIcons.clear_circled_solid,
                              size: 20,
                              color: Color(0xFFB6B6B6),
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
