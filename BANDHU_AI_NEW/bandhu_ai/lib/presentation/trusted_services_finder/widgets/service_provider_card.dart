import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ServiceProviderCard extends StatelessWidget {
  final Map<String, dynamic> provider;
  final VoidCallback? onTap;
  final VoidCallback? onCall;
  final VoidCallback? onMessage;
  final VoidCallback? onBookService;
  final VoidCallback? onAddToFavorites;

  const ServiceProviderCard({
    super.key,
    required this.provider,
    this.onTap,
    this.onCall,
    this.onMessage,
    this.onBookService,
    this.onAddToFavorites,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap?.call();
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProviderHeader(context),
                SizedBox(height: 2.h),
                _buildProviderDetails(context),
                SizedBox(height: 2.h),
                _buildSocialProof(context),
                SizedBox(height: 2.h),
                _buildActionButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProviderHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 15.w,
          height: 15.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImageWidget(
              imageUrl: provider['avatar'] as String? ?? '',
              width: 15.w,
              height: 15.w,
              fit: BoxFit.cover,
              semanticLabel: provider['avatarSemanticLabel'] as String? ??
                  'Service provider profile photo',
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      provider['name'] as String? ?? 'Unknown Provider',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (provider['isVerified'] == true) ...[
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.verifiedLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'verified',
                            color: AppTheme.verifiedLight,
                            size: 12,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'Verified',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppTheme.verifiedLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 0.5.h),
              Text(
                provider['serviceType'] as String? ?? 'Service Provider',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  _buildRatingStars(context),
                  SizedBox(width: 2.w),
                  Text(
                    '${provider['rating'] ?? 0.0}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '(${provider['reviewCount'] ?? 0})',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingStars(BuildContext context) {
    final rating = (provider['rating'] as num?)?.toDouble() ?? 0.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return CustomIconWidget(
          iconName: index < rating.floor() ? 'star' : 'star_border',
          color: AppTheme.primaryLight,
          size: 14,
        );
      }),
    );
  }

  Widget _buildProviderDetails(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: _buildDetailItem(
            context,
            'location_on',
            '${provider['distance'] ?? 0.0} km away',
          ),
        ),
        Expanded(
          child: _buildDetailItem(
            context,
            'schedule',
            provider['availability'] as String? ?? 'Available',
          ),
        ),
        Expanded(
          child: _buildDetailItem(
            context,
            'currency_rupee',
            provider['priceRange'] as String? ?? '₹₹',
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(BuildContext context, String iconName, String text) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: colorScheme.onSurface.withValues(alpha: 0.6),
          size: 16,
        ),
        SizedBox(width: 1.w),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialProof(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final testimonials = provider['testimonials'] as List<dynamic>? ?? [];

    if (testimonials.isEmpty) return const SizedBox.shrink();

    final testimonial = testimonials.first as Map<String, dynamic>;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CustomImageWidget(
                imageUrl: testimonial['reviewerAvatar'] as String? ?? '',
                width: 8.w,
                height: 8.w,
                fit: BoxFit.cover,
                semanticLabel:
                    testimonial['reviewerAvatarSemanticLabel'] as String? ??
                        'Reviewer profile photo',
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"${testimonial['comment'] as String? ?? ''}"',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '- ${testimonial['reviewerName'] as String? ?? 'Anonymous'}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              HapticFeedback.lightImpact();
              onCall?.call();
            },
            icon: CustomIconWidget(
              iconName: 'phone',
              color: colorScheme.primary,
              size: 16,
            ),
            label: Text('Call'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              HapticFeedback.lightImpact();
              onMessage?.call();
            },
            icon: CustomIconWidget(
              iconName: 'message',
              color: colorScheme.primary,
              size: 16,
            ),
            label: Text('Message'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              onBookService?.call();
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Book'),
          ),
        ),
      ],
    );
  }
}
