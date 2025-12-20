import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationSharingToggle extends StatefulWidget {
  final bool isEnabled;
  final Function(bool) onToggle;
  final String currentAddress;
  final String gpsAccuracy;

  const LocationSharingToggle({
    super.key,
    required this.isEnabled,
    required this.onToggle,
    required this.currentAddress,
    required this.gpsAccuracy,
  });

  @override
  State<LocationSharingToggle> createState() => _LocationSharingToggleState();
}

class _LocationSharingToggleState extends State<LocationSharingToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: widget.isEnabled
                  ? AppTheme.successLight.withValues(alpha: 0.1)
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isEnabled
                    ? AppTheme.successLight
                    : colorScheme.outline.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                // Toggle header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: widget.isEnabled
                            ? AppTheme.successLight.withValues(alpha: 0.2)
                            : colorScheme.outline.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName:
                            widget.isEnabled ? 'location_on' : 'location_off',
                        color: widget.isEnabled
                            ? AppTheme.successLight
                            : colorScheme.outline,
                        size: 6.w,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Share Location',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            widget.isEnabled
                                ? 'Location sharing enabled'
                                : 'Location sharing disabled',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: widget.isEnabled
                                  ? AppTheme.successLight
                                  : colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTapDown: (_) => _animationController.forward(),
                      onTapUp: (_) => _animationController.reverse(),
                      onTapCancel: () => _animationController.reverse(),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        widget.onToggle(!widget.isEnabled);
                      },
                      child: Container(
                        width: 12.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: widget.isEnabled
                              ? AppTheme.successLight
                              : colorScheme.outline.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          alignment: widget.isEnabled
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: 5.w,
                            height: 5.w,
                            margin: EdgeInsets.all(0.5.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Location details (when enabled)
                if (widget.isEnabled) ...[
                  SizedBox(height: 3.h),
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.successLight.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'place',
                              color: AppTheme.successLight,
                              size: 4.w,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Current Location',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          widget.currentAddress,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.successLight
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'gps_fixed',
                                    color: AppTheme.successLight,
                                    size: 3.w,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    widget.gpsAccuracy,
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.successLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
