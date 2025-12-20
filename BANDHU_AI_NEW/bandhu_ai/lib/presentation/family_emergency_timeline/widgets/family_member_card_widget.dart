import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FamilyMemberCardWidget extends StatelessWidget {
  final String name;
  final String relation;
  final String avatar;
  final String semanticLabel;
  final bool isOnline;
  final DateTime? lastSeen;
  final bool isNotificationDelivered;
  final VoidCallback onVideoCall;

  const FamilyMemberCardWidget({
    super.key,
    required this.name,
    required this.relation,
    required this.avatar,
    required this.semanticLabel,
    required this.isOnline,
    this.lastSeen,
    required this.isNotificationDelivered,
    required this.onVideoCall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOnline
              ? const Color(0xFF27AE60).withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: CustomImageWidget(
                      imageUrl: avatar,
                      width: 12.w,
                      height: 12.w,
                      fit: BoxFit.cover,
                      semanticLabel: semanticLabel,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 3.w,
                      height: 3.w,
                      decoration: BoxDecoration(
                        color: isOnline ? const Color(0xFF27AE60) : Colors.grey,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      relation,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: isNotificationDelivered
                              ? 'check_circle'
                              : 'schedule',
                          color: isNotificationDelivered
                              ? const Color(0xFF27AE60)
                              : Colors.orange,
                          size: 4.w,
                        ),
                        SizedBox(width: 1.w),
                        Expanded(
                          child: Text(
                            isNotificationDelivered ? 'Notified' : 'Sending...',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: isNotificationDelivered
                                  ? const Color(0xFF27AE60)
                                  : Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: isOnline
                      ? const Color(0xFF27AE60).withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isOnline ? 'Online' : _getLastSeenText(),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color:
                        isOnline ? const Color(0xFF27AE60) : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                onVideoCall();
              },
              icon: CustomIconWidget(
                iconName: 'video_call',
                color: Colors.white,
                size: 5.w,
              ),
              label: Text(
                'Call ${name.split(' ').first}',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getLastSeenText() {
    if (lastSeen == null) return 'Offline';

    final now = DateTime.now();
    final difference = now.difference(lastSeen!);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
