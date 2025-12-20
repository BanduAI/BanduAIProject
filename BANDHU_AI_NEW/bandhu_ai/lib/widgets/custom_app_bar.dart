import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget implementing Compassionate Minimalism design
/// Provides trusted guardian feel with clean, uncluttered interface
/// Optimized for elderly users with large touch targets and high contrast
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool showNotificationBadge;
  final int notificationCount;
  final VoidCallback? onNotificationPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.showBackButton = false,
    this.onBackPressed,
    this.showNotificationBadge = false,
    this.notificationCount = 0,
    this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? colorScheme.onSurface,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: elevation,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        statusBarBrightness: theme.brightness,
      ),
      leading: _buildLeading(context),
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: _buildActions(context),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (showBackButton ||
        (automaticallyImplyLeading && Navigator.canPop(context))) {
      return IconButton(
        onPressed: onBackPressed ?? () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        iconSize: 24,
        padding: const EdgeInsets.all(12), // Large touch target
        tooltip: 'Back',
        splashRadius: 24,
      );
    }

    return null;
  }

  List<Widget>? _buildActions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    List<Widget> actionWidgets = [];

    // Add notification icon if enabled
    if (showNotificationBadge) {
      actionWidgets.add(
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Stack(
            children: [
              IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onNotificationPressed?.call();
                },
                icon: const Icon(Icons.notifications_outlined),
                iconSize: 24,
                padding: const EdgeInsets.all(12),
                tooltip: 'Notifications',
                splashRadius: 24,
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colorScheme.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      notificationCount > 99
                          ? '99+'
                          : notificationCount.toString(),
                      style: GoogleFonts.inter(
                        color: colorScheme.onError,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    // Add emergency quick access
    actionWidgets.add(
      Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: IconButton(
          onPressed: () {
            HapticFeedback.heavyImpact(); // Heavy impact for emergency
            Navigator.pushNamed(context, '/emergency-sos');
          },
          icon: const Icon(Icons.emergency),
          iconSize: 24,
          padding: const EdgeInsets.all(12),
          tooltip: 'Emergency SOS',
          splashRadius: 24,
          style: IconButton.styleFrom(
            foregroundColor: colorScheme.error,
          ),
        ),
      ),
    );

    // Add custom actions if provided
    if (actions != null) {
      actionWidgets.addAll(actions!);
    }

    return actionWidgets.isNotEmpty ? actionWidgets : null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
