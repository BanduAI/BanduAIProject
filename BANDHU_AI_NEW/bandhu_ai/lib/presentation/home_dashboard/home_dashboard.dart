import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/services/localization_service.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/community_activity_widget.dart';
import './widgets/feature_grid_widget.dart';
import './widgets/floating_voice_button_widget.dart';
import './widgets/weather_time_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  String _selectedLanguage = 'EN';
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // Mock user data
  final Map<String, dynamic> _userData = {
    'name': 'Priya Sharma',
    'location': 'Sector 15, Noida, UP',
    'verified': true,
  };

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {});
    }
  }

  void _onLanguageChanged(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    HapticFeedback.lightImpact();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.t('bandhu_ai', _selectedLanguage.toLowerCase()),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _userData['name'] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        centerTitle: false,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.language,
              color: colorScheme.onSurface,
            ),
            onSelected: _onLanguageChanged,
            itemBuilder: (context) =>
                LocalizationService.getSupportedLanguages()
                    .map((lang) => PopupMenuItem<String>(
                          value: lang['code']!.toUpperCase(),
                          child: Row(
                            children: [
                              Text(lang['nativeName']!),
                              SizedBox(width: 2.w),
                              Text('(${lang['code']!.toUpperCase()})'),
                            ],
                          ),
                        ))
                    .toList(),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            IndexedStack(
              index: _currentIndex,
              children: [
                _buildHomeTab(context),
                _buildCommunityTab(context),
                _buildProfileTab(context),
              ],
            ),
            const FloatingVoiceButtonWidget(),
            _buildAIAssistantBubble(context),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedLanguage: _selectedLanguage.toLowerCase(),
      ),
    );
  }

  Widget _buildHomeTab(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _onRefresh,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Small header instead of orange block
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userData['name'],
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 10, color: Colors.orangeAccent),
                        SizedBox(width: 2),
                        Text(
                          _userData['location'],
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(Icons.settings_outlined, color: Colors.orangeAccent),
              ],
            ),
            SizedBox(height: 1.1.h),
            WeatherTimeWidget(
                selectedLanguage: _selectedLanguage.toLowerCase()),
            SizedBox(height: 2.h),

            // Outlined Feature Grid
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200, width: 1),
              ),
              child: FeatureGridWidget(
                  selectedLanguage: _selectedLanguage.toLowerCase()),
            ),

            SizedBox(height: 2.5.h),

            // Outlined Community Activity
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200, width: 1),
              ),
              child: CommunityActivityWidget(
                  selectedLanguage: _selectedLanguage.toLowerCase()),
            ),
            SizedBox(height: 10.h), // Space for floating buttons
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityTab(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.t('community_hub', _selectedLanguage.toLowerCase()),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          _buildQuickActionCards(context),
          SizedBox(height: 3.h),
          CommunityActivityWidget(
              selectedLanguage: _selectedLanguage.toLowerCase()),
        ],
      ),
    );
  }

  Widget _buildProfileTab(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(context),
          SizedBox(height: 3.h),
          _buildProfileOptions(context),
        ],
      ),
    );
  }

  Widget _buildQuickActionCards(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final actions = [
      {
        'title': context.t('find_neighbors', _selectedLanguage.toLowerCase()),
        'subtitle':
            context.t('connect_nearby', _selectedLanguage.toLowerCase()),
        'icon': 'people_outline',
        'color': Colors.blue,
        'route': '/neighbor-response-tracking',
      },
      {
        'title':
            context.t('emergency_timeline', _selectedLanguage.toLowerCase()),
        'subtitle':
            context.t('view_family_updates', _selectedLanguage.toLowerCase()),
        'icon': 'timeline',
        'color': Colors.orange,
        'route': '/family-emergency-timeline',
      },
    ];

    return Column(
      children: actions.map((action) {
        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, action['route'] as String);
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: (action['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomIconWidget(
                      iconName: action['icon'] as String,
                      color: action['color'] as Color,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          action['title'] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          action['subtitle'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: colorScheme.onSurface.withOpacity(0.4),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CustomImageWidget(
                imageUrl:
                    'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400',
                width: 20.w,
                height: 20.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _userData['name'] as String,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (_userData['verified'] as bool)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'verified',
                              color: Colors.green,
                              size: 12,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              context.t(
                                  'verified', _selectedLanguage.toLowerCase()),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'location_on',
                      color: colorScheme.onSurface.withOpacity(0.6),
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Expanded(
                      child: Text(
                        _userData['location'] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final options = [
      {
        'title':
            context.t('emergency_contacts', _selectedLanguage.toLowerCase()),
        'subtitle':
            context.t('manage_contacts', _selectedLanguage.toLowerCase()),
        'icon': 'contact_emergency',
        'route': '/family-emergency-timeline',
      },
      {
        'title': context.t('trust_safety', _selectedLanguage.toLowerCase()),
        'subtitle':
            context.t('verification_settings', _selectedLanguage.toLowerCase()),
        'icon': 'security',
        'route': '/trusted-services-finder',
      },
      {
        'title':
            context.t('language_settings', _selectedLanguage.toLowerCase()),
        'subtitle':
            context.t('change_language', _selectedLanguage.toLowerCase()),
        'icon': 'language',
        'route': '/home-dashboard',
      },
      {
        'title': context.t('help_support', _selectedLanguage.toLowerCase()),
        'subtitle': context.t('get_help', _selectedLanguage.toLowerCase()),
        'icon': 'help',
        'route': '/ai-assistant-chat',
      },
    ];

    return Column(
      children: options.map((option) {
        return Container(
          margin: EdgeInsets.only(bottom: 1.h),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: colorScheme.outline.withOpacity(0.1),
                width: 1,
              ),
            ),
            tileColor: colorScheme.surface,
            leading: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: option['icon'] as String,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            title: Text(
              option['title'] as String,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              option['subtitle'] as String,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            trailing: CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: colorScheme.onSurface.withOpacity(0.4),
              size: 16,
            ),
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, option['route'] as String);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAIAssistantBubble(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Positioned(
      left: 4.w,
      bottom: 20.h,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.pushNamed(context, '/ai-assistant-chat');
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: colorScheme.secondary,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.secondary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'smart_toy',
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  child: Builder(builder: (context) {
                    return Text(
                      context.t(_selectedLanguage.toLowerCase()),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




