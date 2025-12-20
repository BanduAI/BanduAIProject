import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../core/services/localization_service.dart';

class WeatherTimeWidget extends StatelessWidget {
  final String selectedLanguage;

  const WeatherTimeWidget({
    super.key,
    this.selectedLanguage = 'en',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final currentTime = DateTime.now();
    final timeString = _formatTime(currentTime);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'access_time',
                      color: AppTheme.primaryLight,
                      size: 10,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      timeString,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  _formatDate(currentTime),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 9.sp,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 8.h,
            width: 1,
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'wb_sunny',
                        color: Colors.orange,
                        size: 10,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '28°C',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildWeatherInfo(
                        context: context,
                        label: LocalizationService.getLocalizedString(
                            'weather_humidity', selectedLanguage),
                        value: '65%',
                        icon: 'water_drop',
                      ),
                      _buildWeatherInfo(
                        context: context,
                        label: LocalizationService.getLocalizedString(
                            'weather_wind', selectedLanguage),
                        value: '15 km/h',
                        icon: 'air',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfo({
    required BuildContext context,
    required String label,
    required String value,
    required String icon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: colorScheme.primary,
          size: 16,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatDate(DateTime dateTime) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]}, ${dateTime.year}';
  }
}
