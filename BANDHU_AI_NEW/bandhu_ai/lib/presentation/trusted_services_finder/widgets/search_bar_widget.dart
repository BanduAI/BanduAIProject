import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchBarWidget extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onVoiceSearch;
  final VoidCallback? onFilterTap;
  final TextEditingController? controller;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Search for services...',
    this.onChanged,
    this.onVoiceSearch,
    this.onFilterTap,
    this.controller,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                onChanged: widget.onChanged,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 20,
                    ),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_controller.text.isNotEmpty)
                        IconButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            _controller.clear();
                            widget.onChanged?.call('');
                          },
                          icon: CustomIconWidget(
                            iconName: 'clear',
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                            size: 20,
                          ),
                          padding: EdgeInsets.all(2.w),
                          constraints: BoxConstraints(
                            minWidth: 8.w,
                            minHeight: 8.w,
                          ),
                        ),
                      IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          _handleVoiceSearch();
                        },
                        icon: CustomIconWidget(
                          iconName: _isListening ? 'mic' : 'mic_none',
                          color: _isListening
                              ? colorScheme.error
                              : colorScheme.onSurface.withValues(alpha: 0.6),
                          size: 20,
                        ),
                        padding: EdgeInsets.all(2.w),
                        constraints: BoxConstraints(
                          minWidth: 8.w,
                          minHeight: 8.w,
                        ),
                      ),
                    ],
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 2.h,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                widget.onFilterTap?.call();
              },
              icon: CustomIconWidget(
                iconName: 'tune',
                color: colorScheme.onPrimary,
                size: 20,
              ),
              padding: EdgeInsets.all(3.w),
              constraints: BoxConstraints(
                minWidth: 12.w,
                minHeight: 12.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleVoiceSearch() {
    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      // Start voice recognition
      widget.onVoiceSearch?.call();

      // Simulate voice recognition timeout
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isListening = false;
          });
        }
      });
    } else {
      // Stop voice recognition
      widget.onVoiceSearch?.call();
    }
  }
}




