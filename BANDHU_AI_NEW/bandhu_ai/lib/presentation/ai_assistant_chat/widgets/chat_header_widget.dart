import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatHeaderWidget extends StatelessWidget {
  final bool isOnline;
  final bool isVoiceMode;
  final Function(bool) onVoiceModeToggle;
  final VoidCallback? onMinimize;

  const ChatHeaderWidget({
    super.key,
    required this.isOnline,
    required this.isVoiceMode,
    required this.onVoiceModeToggle,
    this.onMinimize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderLight.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Assistant Avatar
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryLight,
                    AppTheme.secondaryLight,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(6.w),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryLight.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: CustomIconWidget(
                iconName: 'smart_toy',
                color: Colors.white,
                size: 6.w,
              ),
            ),
            SizedBox(width: 3.w),
            // Title and Status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bandhu assistant',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryLight,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Container(
                        width: 2.w,
                        height: 2.w,
                        decoration: BoxDecoration(
                          color: isOnline
                              ? AppTheme.successLight
                              : AppTheme.textSecondaryLight,
                          borderRadius: BorderRadius.circular(1.w),
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        isOnline ? 'online' : 'offline',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11.sp,
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Voice Mode Toggle
            Container(
              decoration: BoxDecoration(
                color: isVoiceMode
                    ? AppTheme.primaryLight.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6.w),
                border: Border.all(
                  color: isVoiceMode
                      ? AppTheme.primaryLight
                      : AppTheme.borderLight,
                  width: 1,
                ),
              ),
              child: IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onVoiceModeToggle(!isVoiceMode);
                },
                icon: CustomIconWidget(
                  iconName: isVoiceMode ? 'mic' : 'keyboard',
                  color: isVoiceMode
                      ? AppTheme.primaryLight
                      : AppTheme.textSecondaryLight,
                  size: 5.w,
                ),
                tooltip: isVoiceMode ? 'Text Mode' : 'Voice Mode',
                padding: EdgeInsets.all(2.w),
                constraints: BoxConstraints(
                  minWidth: 10.w,
                  minHeight: 10.w,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            // Minimize Button
            if (onMinimize != null)
              IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onMinimize!();
                },
                icon: CustomIconWidget(
                  iconName: 'keyboard_arrow_down',
                  color: AppTheme.textSecondaryLight,
                  size: 6.w,
                ),
                tooltip: 'Minimize',
                padding: EdgeInsets.all(2.w),
                constraints: BoxConstraints(
                  minWidth: 10.w,
                  minHeight: 10.w,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
