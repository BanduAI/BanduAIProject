import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../core/services/localization_service.dart';

class CommunityActivityWidget extends StatelessWidget {
  final String selectedLanguage;

  const CommunityActivityWidget({
    super.key,
    this.selectedLanguage = 'en',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final activities = [
      {
        'title': selectedLanguage == 'hi'
            ? 'योग क्लास आज शाम 5 बजे पार्क में'
            : 'Yoga class today at 5 PM in the park',
        'time': '2h ago',
        'type': 'event',
        'icon': 'event',
        'color': Colors.green,
      },
      {
        'title': selectedLanguage == 'hi'
            ? 'नई बेकरी शॉप खुली - 50% छूट'
            : 'New bakery shop opened - 50% discount',
        'time': '4h ago',
        'type': 'business',
        'icon': 'store',
        'color': Colors.orange,
      },
      {
        'title': selectedLanguage == 'hi'
            ? 'राहुल कंप्यूटर रिपेयर सेवा दे रहे हैं'
            : 'Rahul offering computer repair services',
        'time': '6h ago',
        'type': 'skill',
        'icon': 'handyman',
        'color': Colors.blue,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocalizationService.getLocalizedString(
                  'recent_activity', selectedLanguage),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                // Navigate to full activity feed
              },
              child: Text(
                selectedLanguage == 'hi' ? 'सभी देखें' : 'View All',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.primaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          separatorBuilder: (context, index) => SizedBox(height: 2.h),
          itemBuilder: (context, index) {
            final activity = activities[index];
            return _buildActivityCard(
              context: context,
              title: activity['title'] as String,
              time: activity['time'] as String,
              iconName: activity['icon'] as String,
              color: activity['color'] as Color,
            );
          },
        ),
      ],
    );
  }

  Widget _buildActivityCard({
    required BuildContext context,
    required String title,
    required String time,
    required String iconName,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        // Handle activity tap
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 20,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    time,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: colorScheme.onSurface.withValues(alpha: 0.4),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
