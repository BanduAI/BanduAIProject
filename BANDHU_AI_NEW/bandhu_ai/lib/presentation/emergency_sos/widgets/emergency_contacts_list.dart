import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmergencyContactsList extends StatelessWidget {
  final List<Map<String, dynamic>> contacts;
  final Function(Map<String, dynamic>) onContactCall;

  const EmergencyContactsList({
    super.key,
    required this.contacts,
    required this.onContactCall,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.emergencyLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'contacts',
                  color: AppTheme.emergencyLight,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency Contacts',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Tap to call directly',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Contacts list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: contacts.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return _buildContactItem(context, contact);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, Map<String, dynamic> contact) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () {
        HapticFeedback.heavyImpact();
        onContactCall(contact);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Contact avatar
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: _getContactColor(contact['relationship'] as String)
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: contact['avatar'] != null
                    ? ClipOval(
                        child: CustomImageWidget(
                          imageUrl: contact['avatar'] as String,
                          width: 12.w,
                          height: 12.w,
                          fit: BoxFit.cover,
                          semanticLabel: contact['semanticLabel'] as String,
                        ),
                      )
                    : Text(
                        (contact['name'] as String)
                            .substring(0, 1)
                            .toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: _getContactColor(
                              contact['relationship'] as String),
                        ),
                      ),
              ),
            ),
            SizedBox(width: 3.w),

            // Contact details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact['name'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: _getContactColor(
                                  contact['relationship'] as String)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          contact['relationship'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: _getContactColor(
                                contact['relationship'] as String),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      if (contact['isVerified'] == true)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 1.5.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color:
                                AppTheme.verifiedLight.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: CustomIconWidget(
                            iconName: 'verified',
                            color: AppTheme.verifiedLight,
                            size: 3.w,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    contact['phone'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),

            // Call button
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.emergencyLight.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'call',
                color: AppTheme.emergencyLight,
                size: 6.w,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getContactColor(String relationship) {
    switch (relationship.toLowerCase()) {
      case 'family':
        return AppTheme.emergencyLight;
      case 'friend':
        return AppTheme.secondaryLight;
      case 'neighbor':
        return AppTheme.primaryLight;
      case 'doctor':
        return AppTheme.successLight;
      default:
        return AppTheme.primaryLight;
    }
  }
}




