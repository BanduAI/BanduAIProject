import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChatMessageWidget extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final bool isTyping;

  const ChatMessageWidget({
    super.key,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.isTyping = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            _buildAvatar(colorScheme),
            SizedBox(width: 2.w),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: 75.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: isUser
                    ? AppTheme.primaryLight
                    : AppTheme.secondaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.w),
                  topRight: Radius.circular(4.w),
                  bottomLeft:
                      isUser ? Radius.circular(4.w) : Radius.circular(1.w),
                  bottomRight:
                      isUser ? Radius.circular(1.w) : Radius.circular(4.w),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isTyping)
                    _buildTypingIndicator()
                  else
                    Text(
                      message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            isUser ? Colors.white : AppTheme.textPrimaryLight,
                        fontSize: 14.sp,
                        height: 1.4,
                      ),
                    ),
                  SizedBox(height: 1.h),
                  Text(
                    _formatTime(timestamp),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isUser
                          ? Colors.white.withValues(alpha: 0.8)
                          : AppTheme.textSecondaryLight,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 2.w),
            _buildUserAvatar(colorScheme),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(ColorScheme colorScheme) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        color: AppTheme.secondaryLight,
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: CustomIconWidget(
        iconName: 'smart_toy',
        color: Colors.white,
        size: 4.w,
      ),
    );
  }

  Widget _buildUserAvatar(ColorScheme colorScheme) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        color: AppTheme.primaryLight,
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: CustomIconWidget(
        iconName: 'person',
        color: Colors.white,
        size: 4.w,
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < 3; i++) ...[
          TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 600),
            tween: Tween(begin: 0.4, end: 1.0),
            builder: (context, value, child) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: 2.w,
                height: 2.w,
                margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                decoration: BoxDecoration(
                  color: AppTheme.textSecondaryLight.withValues(alpha: value),
                  borderRadius: BorderRadius.circular(1.w),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just Now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes before';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours before';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}




