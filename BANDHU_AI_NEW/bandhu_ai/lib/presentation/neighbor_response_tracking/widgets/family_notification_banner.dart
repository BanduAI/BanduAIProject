import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FamilyNotificationBanner extends StatelessWidget {
  final List<Map<String, dynamic>> notifiedFamily;
  final VoidCallback? onViewTimeline;

  const FamilyNotificationBanner({
    super.key,
    required this.notifiedFamily,
    this.onViewTimeline,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (notifiedFamily.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'family_restroom',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                "Family Notified",
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (onViewTimeline != null)
                TextButton(
                  onPressed: onViewTimeline,
                  child: Text(
                    "View Timeline",
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: notifiedFamily.take(3).map((family) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.2),
                      ),
                      child: CustomIconWidget(
                        iconName: (family["status"] as String?) == "notified"
                            ? 'notifications_active'
                            : 'check_circle',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 14,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      (family["name"] as String?) ?? "Family Member",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          if (notifiedFamily.length > 3) ...[
            SizedBox(height: 1.h),
            Text(
              "+${notifiedFamily.length - 3} more family members notified",
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
