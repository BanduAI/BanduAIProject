import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickSuggestionsWidget extends StatelessWidget {
  final Function(String) onSuggestionTap;

  const QuickSuggestionsWidget({
    super.key,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final suggestions = [
      {
        'text': 'Find nearby services',
        'icon': 'search',
        'query': 'What services are available near me?',
      },
      {
        'text': 'emergency',
        'icon': 'emergency',
        'query': 'I need emergency help immediately',
      },
      {
        'text': 'skill tips',
        'icon': 'psychology',
        'query': 'What skills can be useful to me?',
      },
      {
        'text': 'community activities',
        'icon': 'groups',
        'query': 'Whats happening in my area today?',
      },
      {
        'text': 'weather information',
        'icon': 'wb_sunny',
        'query': 'how is the weather today?',
      },
      {
        'text': 'health advice',
        'icon': 'health_and_safety',
        'query': 'I need health advice',
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'quick tips',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimaryLight,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: suggestions.map((suggestion) {
              return _buildSuggestionChip(
                context,
                suggestion['text'] as String,
                suggestion['icon'] as String,
                suggestion['query'] as String,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(
    BuildContext context,
    String text,
    String iconName,
    String query,
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onSuggestionTap(query);
      },
      borderRadius: BorderRadius.circular(6.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: AppTheme.secondaryLight.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6.w),
          border: Border.all(
            color: AppTheme.secondaryLight.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.secondaryLight,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Flexible(
              child: Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimaryLight,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
