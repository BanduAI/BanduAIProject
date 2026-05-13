import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NetworkStatusIndicator extends StatelessWidget {
  final bool isConnected;
  final String connectionType;
  final int signalStrength;

  const NetworkStatusIndicator({
    super.key,
    required this.isConnected,
    required this.connectionType,
    required this.signalStrength,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: isConnected
            ? AppTheme.successLight.withValues(alpha: 0.1)
            : AppTheme.emergencyLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isConnected
              ? AppTheme.successLight.withValues(alpha: 0.3)
              : AppTheme.emergencyLight.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Network icon
          CustomIconWidget(
            iconName:
                isConnected ? 'signal_cellular_4_bar' : 'signal_cellular_off',
            color:
                isConnected ? AppTheme.successLight : AppTheme.emergencyLight,
            size: 4.w,
          ),
          SizedBox(width: 2.w),

          // Network status text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isConnected ? 'Network Connected' : 'No Network',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: isConnected
                        ? AppTheme.successLight
                        : AppTheme.emergencyLight,
                  ),
                ),
                if (isConnected) ...[
                  Text(
                    '$connectionType • ${_getSignalStrengthText()}',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ] else ...[
                  Text(
                    'Emergency services may be limited',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.emergencyLight.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Signal strength bars
          if (isConnected)
            Row(
              children: List.generate(4, (index) {
                return Container(
                  width: 0.8.w,
                  height: (index + 1) * 0.8.h,
                  margin: EdgeInsets.only(left: 0.5.w),
                  decoration: BoxDecoration(
                    color: index < signalStrength
                        ? AppTheme.successLight
                        : colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(0.5.w),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }

  String _getSignalStrengthText() {
    switch (signalStrength) {
      case 4:
        return 'Excellent';
      case 3:
        return 'Good';
      case 2:
        return 'Fair';
      case 1:
        return 'Poor';
      default:
        return 'No Signal';
    }
  }
}




