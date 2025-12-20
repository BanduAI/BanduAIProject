import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../core/services/localization_service.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final String selectedLanguage;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.selectedLanguage = 'en',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 8.h,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                index: 0,
                icon: Icons.home,
                label: LocalizationService.getLocalizedString(
                    'home', selectedLanguage),
                isSelected: currentIndex == 0,
                colorScheme: colorScheme,
                theme: theme,
              ),
              _buildNavItem(
                context: context,
                index: 1,
                icon: Icons.people,
                label: LocalizationService.getLocalizedString(
                    'community', selectedLanguage),
                isSelected: currentIndex == 1,
                colorScheme: colorScheme,
                theme: theme,
              ),
              _buildNavItem(
                context: context,
                index: 2,
                icon: Icons.person,
                label: LocalizationService.getLocalizedString(
                    'profile', selectedLanguage),
                isSelected: currentIndex == 2,
                colorScheme: colorScheme,
                theme: theme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
    required ColorScheme colorScheme,
    required ThemeData theme,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 24,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
