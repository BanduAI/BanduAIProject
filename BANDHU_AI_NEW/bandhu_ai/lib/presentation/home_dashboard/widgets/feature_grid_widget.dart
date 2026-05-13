import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../core/services/localization_service.dart';

class FeatureGridWidget extends StatelessWidget {
  final String selectedLanguage;

  const FeatureGridWidget({
    super.key,
    this.selectedLanguage = 'en',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final features = [
      {
        'title': LocalizationService.getLocalizedString(
            'emergency_help', selectedLanguage),
        'icon': 'emergency',
        'route': '/emergency-sos',
        'color': AppTheme.emergencyLight,
      },
      {
        'title': LocalizationService.getLocalizedString(
            'find_services', selectedLanguage),
        'icon': 'search',
        'route': '/trusted-services-finder',
        'color': AppTheme.secondaryLight,
      },
      {
        'title': LocalizationService.getLocalizedString(
            'skill_swap', selectedLanguage),
        'icon': 'swap_horiz',
        'route': '/skill-swap',
        'color': Colors.purple,
      },
      {
        'title': LocalizationService.getLocalizedString(
            'community_memory', selectedLanguage),
        'icon': 'memory',
        'route': '/community-memory',
        'color': Colors.teal,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // 👈 centered title
      children: [
        Text(
          'Quick Actions',
          textAlign: TextAlign.center, // 👈 center the text itself
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 1.2,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return _buildFeatureCard(
              context: context,
              title: feature['title'] as String,
              iconName: feature['icon'] as String,
              color: feature['color'] as Color,
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pushNamed(context, feature['route'] as String);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required String title,
    required String iconName,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.4),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 8.w,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}




