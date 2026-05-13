import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/emergency_header.dart';
import './widgets/emergency_map_view.dart';
import './widgets/family_notification_banner.dart';
import './widgets/helper_profile_card.dart';

class NeighborResponseTracking extends StatefulWidget {
  const NeighborResponseTracking({super.key});

  @override
  State<NeighborResponseTracking> createState() =>
      _NeighborResponseTrackingState();
}

class _NeighborResponseTrackingState extends State<NeighborResponseTracking>
    with TickerProviderStateMixin {
  late DateTime _emergencyStartTime;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  final bool _isBottomSheetExpanded = false;

  // Mock user location (Mumbai, India)
  final LatLng _userLocation = const LatLng(19.0760, 72.8777);

  // Mock data for responding neighbors
  final List<Map<String, dynamic>> _respondingNeighbors = [
    {
      "id": 1,
      "name": "Dr. Rajesh Kumar",
      "avatar": "https://images.unsplash.com/photo-1691323391092-2d4d1b6023f7",
      "semanticLabel":
          "Middle-aged Indian doctor with glasses and white coat, smiling professionally",
      "specialization": "Medical Professional",
      "distance": 0.3,
      "eta": 2,
      "trustScore": 4.8,
      "location": {
        "latitude": 19.0770,
        "longitude": 72.8785,
      },
      "phone": "+91 98765 43210",
    },
    {
      "id": 2,
      "name": "Priya Sharma",
      "avatar": "https://images.unsplash.com/photo-1733737272264-6af8f1aa41fc",
      "semanticLabel":
          "Young Indian woman with long black hair wearing traditional kurta, smiling warmly",
      "specialization": "Local Guide & First Aid",
      "distance": 0.5,
      "eta": 4,
      "trustScore": 4.6,
      "location": {
        "latitude": 19.0750,
        "longitude": 72.8790,
      },
      "phone": "+91 87654 32109",
    },
    {
      "id": 3,
      "name": "Amit Patel",
      "avatar": "https://images.unsplash.com/photo-1724128192920-a6f9083d6aac",
      "semanticLabel":
          "Young Indian man with short black hair wearing casual blue shirt, confident expression",
      "specialization": "Community Volunteer",
      "distance": 0.7,
      "eta": 5,
      "trustScore": 4.5,
      "location": {
        "latitude": 19.0745,
        "longitude": 72.8765,
      },
      "phone": "+91 76543 21098",
    },
    {
      "id": 4,
      "name": "Mrs. Sunita Devi",
      "avatar": "https://images.unsplash.com/photo-1617593461584-4d51cc5cff4c",
      "semanticLabel":
          "Elderly Indian woman with gray hair wearing colorful saree, kind and wise expression",
      "specialization": "Elder Care Specialist",
      "distance": 0.9,
      "eta": 7,
      "trustScore": 4.9,
      "location": {
        "latitude": 19.0780,
        "longitude": 72.8760,
      },
      "phone": "+91 65432 10987",
    },
  ];

  // Mock family notification data
  final List<Map<String, dynamic>> _notifiedFamily = [
    {
      "id": 1,
      "name": "Rahul (Son)",
      "status": "notified",
      "relationship": "son",
    },
    {
      "id": 2,
      "name": "Meera (Daughter)",
      "status": "acknowledged",
      "relationship": "daughter",
    },
    {
      "id": 3,
      "name": "Vikram (Brother)",
      "status": "notified",
      "relationship": "brother",
    },
  ];

  @override
  void initState() {
    super.initState();
    _emergencyStartTime = DateTime.now().subtract(const Duration(minutes: 3));

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    _slideController.forward();

    // Simulate periodic ETA updates
    _startETAUpdates();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _startETAUpdates() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          for (var neighbor in _respondingNeighbors) {
            final currentETA = neighbor["eta"] as int;
            if (currentETA > 0) {
              neighbor["eta"] = (currentETA - 1).clamp(0, 60);
              final currentDistance = neighbor["distance"] as double;
              neighbor["distance"] = (currentDistance - 0.1).clamp(0.0, 10.0);
            }
          }
        });
        _startETAUpdates();
      }
    });
  }

  void _handleCancelEmergency() {
    HapticFeedback.heavyImpact();
    Navigator.pushReplacementNamed(context, '/home-dashboard');
  }

  void _handleCallHelper(Map<String, dynamic> helper) {
    HapticFeedback.mediumImpact();
    final phone = helper["phone"] as String?;
    if (phone != null) {
      // In a real app, this would initiate a phone call
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Calling ${helper["name"]} at $phone"),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _handleHelperCardTap(Map<String, dynamic> helper) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildHelperDetailsSheet(helper),
    );
  }

  Widget _buildHelperDetailsSheet(Map<String, dynamic> helper) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: CustomImageWidget(
                            imageUrl: (helper["avatar"] as String?) ?? "",
                            width: 20.w,
                            height: 20.w,
                            fit: BoxFit.cover,
                            semanticLabel:
                                (helper["semanticLabel"] as String?) ??
                                    "Helper profile photo",
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (helper["name"] as String?) ?? "Unknown Helper",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            SizedBox(height: 1.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.secondary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                (helper["specialization"] as String?) ??
                                    "Community Helper",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.secondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          "Distance",
                          "${(helper["distance"] as num?)?.toStringAsFixed(1) ?? "0.0"} km",
                          CustomIconWidget(
                            iconName: 'location_on',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: _buildInfoCard(
                          "ETA",
                          "${(helper["eta"] as int?) ?? 0} min",
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  _buildInfoCard(
                    "Trust Score",
                    "${(helper["trustScore"] as num?)?.toStringAsFixed(1) ?? "N/A"}/5.0",
                    CustomIconWidget(
                      iconName: 'verified',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Previous Community Contributions",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 2.h),
                  Expanded(
                    child: ListView(
                      children: [
                        _buildContributionItem(
                            "Helped elderly neighbor with medical emergency",
                            "2 days ago"),
                        _buildContributionItem(
                            "Assisted family during power outage",
                            "1 week ago"),
                        _buildContributionItem(
                            "Provided first aid during community event",
                            "2 weeks ago"),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _handleCallHelper(helper);
                      },
                      icon: CustomIconWidget(
                        iconName: 'call',
                        color: Colors.white,
                        size: 20,
                      ),
                      label: Text(
                        "Call ${(helper["name"] as String?)?.split(' ').first ?? "Helper"}",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.primary,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Widget icon) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          icon,
          SizedBox(height: 1.h),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildContributionItem(String description, String timeAgo) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  timeAgo,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleViewTimeline() {
    Navigator.pushNamed(context, '/family-emergency-timeline');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: Column(
        children: [
          EmergencyHeader(
            emergencyStartTime: _emergencyStartTime,
            onCancelPressed: _handleCancelEmergency,
            respondingCount: _respondingNeighbors.length,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 2.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: EmergencyMapView(
                      userLocation: _userLocation,
                      respondingNeighbors: _respondingNeighbors,
                      onMapCreated: () {
                        HapticFeedback.lightImpact();
                      },
                    ),
                  ),
                  SizedBox(height: 3.h),
                  FamilyNotificationBanner(
                    notifiedFamily: _notifiedFamily,
                    onViewTimeline: _handleViewTimeline,
                  ),
                  SizedBox(height: 2.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'people',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          "Approaching Neighbours",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      children: _respondingNeighbors.map((helper) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 3.h),
                          child: HelperProfileCard(
                            helper: helper,
                            onCallPressed: () => _handleCallHelper(helper),
                            onCardTap: () => _handleHelperCardTap(helper),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/ai-assistant-chat');
                            },
                            icon: CustomIconWidget(
                              iconName: 'chat',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 20,
                            ),
                            label: Text(
                              "Chat with AI Assistant",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _handleViewTimeline,
                            icon: CustomIconWidget(
                              iconName: 'timeline',
                              color: Colors.white,
                              size: 20,
                            ),
                            label: Text(
                              "View Timeline",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppTheme.lightTheme.colorScheme.primary,
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}




