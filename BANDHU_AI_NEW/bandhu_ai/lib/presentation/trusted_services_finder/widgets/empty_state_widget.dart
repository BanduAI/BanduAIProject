import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final String? illustrationUrl;

  const EmptyStateWidget({
    super.key,
    this.title = 'No Services Found',
    this.subtitle =
        'We couldn\'t find any service providers matching your criteria. Try adjusting your filters or suggest a new provider.',
    this.buttonText = 'Suggest a Service Provider',
    this.onButtonPressed,
    this.illustrationUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIllustration(context),
            SizedBox(height: 4.h),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onButtonPressed?.call();
                },
                icon: CustomIconWidget(
                  iconName: 'add_circle_outline',
                  color: colorScheme.onPrimary,
                  size: 20,
                ),
                label: Text(buttonText),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            TextButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                _showSuggestProviderDialog(context);
              },
              icon: CustomIconWidget(
                iconName: 'help_outline',
                color: colorScheme.primary,
                size: 18,
              ),
              label: Text('Need help finding services?'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (illustrationUrl != null) {
      return Container(
        width: 60.w,
        height: 30.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: CustomImageWidget(
          imageUrl: illustrationUrl!,
          width: 60.w,
          height: 30.h,
          fit: BoxFit.contain,
          semanticLabel: 'Illustration showing empty state with search concept',
        ),
      );
    }

    return Container(
      width: 40.w,
      height: 20.h,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'search_off',
          color: colorScheme.primary.withValues(alpha: 0.6),
          size: 60,
        ),
      ),
    );
  }

  void _showSuggestProviderDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final TextEditingController nameController = TextEditingController();
    final TextEditingController serviceController = TextEditingController();
    final TextEditingController contactController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Suggest a Service Provider',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Provider Name',
                hintText: 'Enter provider name',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: serviceController,
              decoration: const InputDecoration(
                labelText: 'Service Type',
                hintText: 'e.g., Plumber, Electrician',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: contactController,
              decoration: const InputDecoration(
                labelText: 'Contact Information',
                hintText: 'Phone number or address',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              // Handle suggestion submission
              Navigator.pop(context);
              _showSuccessMessage(context);
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Thank you! Your suggestion has been submitted for review.'),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}




