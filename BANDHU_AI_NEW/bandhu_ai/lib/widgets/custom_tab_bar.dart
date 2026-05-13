import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom Tab Bar implementing Compassionate Minimalism design
/// Provides clean navigation between related content sections
/// Optimized for accessibility with clear visual hierarchy
class CustomTabBar extends StatelessWidget {
  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final bool isScrollable;
  final TabAlignment tabAlignment;
  final EdgeInsetsGeometry padding;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    this.onTap,
    this.isScrollable = false,
    this.tabAlignment = TabAlignment.center,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withAlpha(51),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: padding,
        child: TabBar(
          tabs: tabs.map((tab) => _buildTab(context, tab)).toList(),
          controller: null, // Let parent handle controller
          isScrollable: isScrollable,
          tabAlignment: tabAlignment,
          onTap: (index) {
            HapticFeedback.lightImpact();
            onTap?.call(index);
          },
          indicatorColor: indicatorColor ?? colorScheme.primary,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: labelColor ?? colorScheme.primary,
          unselectedLabelColor:
              unselectedLabelColor ?? colorScheme.onSurface.withAlpha(153),
          labelStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.1,
          ),
          splashFactory: InkRipple.splashFactory,
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.primary.withAlpha(26);
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.primary.withAlpha(13);
            }
            return null;
          }),
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, String text) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

/// Custom Tab Bar View for content sections
/// Provides smooth transitions between tab content
class CustomTabBarView extends StatelessWidget {
  final List<Widget> children;
  final TabController? controller;
  final ScrollPhysics? physics;

  const CustomTabBarView({
    super.key,
    required this.children,
    this.controller,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      physics: physics ?? const ClampingScrollPhysics(),
      children: children.map((child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: child,
        );
      }).toList(),
    );
  }
}

/// Complete Custom Tab System combining TabBar and TabBarView
/// Provides full tab navigation functionality with consistent theming
class CustomTabSystem extends StatefulWidget {
  final List<CustomTab> tabs;
  final int initialIndex;
  final ValueChanged<int>? onTabChanged;
  final bool isScrollable;
  final TabAlignment tabAlignment;
  final EdgeInsetsGeometry tabBarPadding;
  final ScrollPhysics? physics;

  const CustomTabSystem({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onTabChanged,
    this.isScrollable = false,
    this.tabAlignment = TabAlignment.center,
    this.tabBarPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.physics,
  });

  @override
  State<CustomTabSystem> createState() => _CustomTabSystemState();
}

class _CustomTabSystemState extends State<CustomTabSystem>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      initialIndex: widget.initialIndex,
      vsync: this,
    );
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      widget.onTabChanged?.call(_tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTabBar(
          tabs: widget.tabs.map((tab) => tab.title).toList(),
          currentIndex: _tabController.index,
          onTap: (index) => _tabController.animateTo(index),
          isScrollable: widget.isScrollable,
          tabAlignment: widget.tabAlignment,
          padding: widget.tabBarPadding,
        ),
        Expanded(
          child: CustomTabBarView(
            controller: _tabController,
            physics: widget.physics,
            children: widget.tabs.map((tab) => tab.content).toList(),
          ),
        ),
      ],
    );
  }
}

/// Data class for Custom Tab
class CustomTab {
  final String title;
  final Widget content;
  final IconData? icon;

  const CustomTab({
    required this.title,
    required this.content,
    this.icon,
  });
}




