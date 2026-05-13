import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/emergency_header_widget.dart';
import './widgets/emergency_notes_widget.dart';
import './widgets/family_member_card_widget.dart';
import './widgets/timeline_entry_widget.dart';

class FamilyEmergencyTimeline extends StatefulWidget {
  const FamilyEmergencyTimeline({super.key});

  @override
  State<FamilyEmergencyTimeline> createState() =>
      _FamilyEmergencyTimelineState();
}

class _FamilyEmergencyTimelineState extends State<FamilyEmergencyTimeline> {
  bool _isResolved = false;
  final ScrollController _scrollController = ScrollController();

  // Mock data for emergency timeline
  final List<Map<String, dynamic>> _timelineEvents = [
    {
      "id": 1,
      "title": "Emergency Triggered",
      "description":
          "Medical emergency alert activated by Priya Sharma. Location: Sector 15, Noida",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 25)),
      "isAcknowledged": true,
    },
    {
      "id": 2,
      "title": "Neighbors Responded",
      "description":
          "3 community helpers are on their way. Dr. Rajesh Kumar (2 min away) leading response.",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 22)),
      "helperName": "Dr. Rajesh Kumar",
      "helperAvatar":
          "https://images.unsplash.com/photo-1582750433449-648ed127bb54",
      "helperSemanticLabel":
          "Professional headshot of middle-aged Indian doctor with stethoscope wearing white coat",
      "isAcknowledged": true,
    },
    {
      "id": 3,
      "title": "Family Notified",
      "description":
          "Emergency notifications sent to all family members. Video call initiated with Rahul.",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 20)),
      "isAcknowledged": true,
    },
    {
      "id": 4,
      "title": "Helper Arrived",
      "description":
          "Dr. Rajesh Kumar has arrived at location. Providing immediate medical assistance.",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 15)),
      "helperName": "Dr. Rajesh Kumar",
      "helperAvatar":
          "https://images.unsplash.com/photo-1582750433449-648ed127bb54",
      "helperSemanticLabel":
          "Professional headshot of middle-aged Indian doctor with stethoscope wearing white coat",
      "isAcknowledged": true,
    },
    {
      "id": 5,
      "title": "Status Update",
      "description":
          "Patient is stable. Additional helper Meera Singh arrived with first aid supplies.",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 10)),
      "helperName": "Meera Singh",
      "helperAvatar":
          "https://images.unsplash.com/photo-1610623427901-297bde0df882",
      "helperSemanticLabel":
          "Smiling Indian woman with long black hair wearing traditional blue kurta",
      "isAcknowledged": false,
    },
  ];

  final List<Map<String, dynamic>> _familyMembers = [
    {
      "id": 1,
      "name": "Rahul Sharma",
      "relation": "Son",
      "avatar": "https://images.unsplash.com/photo-1696347609175-49b310bb8106",
      "semanticLabel":
          "Professional headshot of young Indian man with short black hair wearing dark blue shirt",
      "isOnline": true,
      "lastSeen": null,
      "isNotificationDelivered": true,
    },
    {
      "id": 2,
      "name": "Anjali Sharma",
      "relation": "Daughter-in-law",
      "avatar": "https://images.unsplash.com/photo-1723401138877-44861dd3abff",
      "semanticLabel":
          "Portrait of young Indian woman with long black hair wearing white traditional dress",
      "isOnline": false,
      "lastSeen": DateTime.now().subtract(const Duration(minutes: 5)),
      "isNotificationDelivered": true,
    },
    {
      "id": 3,
      "name": "Arjun Sharma",
      "relation": "Grandson",
      "avatar": "https://images.unsplash.com/photo-1518199259649-1ba3b8f79306",
      "semanticLabel":
          "Young Indian boy with short black hair wearing red t-shirt smiling at camera",
      "isOnline": true,
      "lastSeen": null,
      "isNotificationDelivered": true,
    },
  ];

  final List<Map<String, dynamic>> _emergencyNotes = [
    {
      "id": 1,
      "content":
          "Patient is conscious and responding well. Blood pressure stable.",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 12)),
      "type": "text",
    },
    {
      "id": 2,
      "content":
          "Voice note recorded - Everything is under control, helpers are here.",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 8)),
      "type": "voice",
    },
  ];

  @override
  void initState() {
    super.initState();
    // Prevent auto-lock during emergency
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Emergency Timeline',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _shareTimeline,
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
            tooltip: 'Share Timeline',
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTimeline,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emergency Header
              EmergencyHeaderWidget(
                incidentType: 'Medical Emergency',
                startTime: DateTime.now().subtract(const Duration(minutes: 25)),
                currentStatus: _isResolved ? 'Resolved' : 'Active',
              ),

              SizedBox(height: 4.h),

              // Timeline Section
              Text(
                'Emergency Timeline',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),

              SizedBox(height: 3.h),

              // Timeline Events
              ..._timelineEvents.asMap().entries.map((entry) {
                final index = entry.key;
                final event = entry.value;
                return TimelineEntryWidget(
                  title: event['title'] as String,
                  description: event['description'] as String,
                  timestamp: event['timestamp'] as DateTime,
                  helperName: event['helperName'] as String?,
                  helperAvatar: event['helperAvatar'] as String?,
                  helperSemanticLabel: event['helperSemanticLabel'] as String?,
                  isAcknowledged: event['isAcknowledged'] as bool,
                  isLast: index == _timelineEvents.length - 1,
                );
              }),

              SizedBox(height: 4.h),

              // Family Communication Section
              Text(
                'Family Communication',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),

              SizedBox(height: 3.h),

              // Family Members
              ..._familyMembers.map((member) => FamilyMemberCardWidget(
                    name: member['name'] as String,
                    relation: member['relation'] as String,
                    avatar: member['avatar'] as String,
                    semanticLabel: member['semanticLabel'] as String,
                    isOnline: member['isOnline'] as bool,
                    lastSeen: member['lastSeen'] as DateTime?,
                    isNotificationDelivered:
                        member['isNotificationDelivered'] as bool,
                    onVideoCall: () =>
                        _initiateVideoCall(member['name'] as String),
                  )),

              SizedBox(height: 4.h),

              // Emergency Notes Section
              EmergencyNotesWidget(
                notes: _emergencyNotes,
                onAddNote: _addEmergencyNote,
              ),

              SizedBox(height: 4.h),

              // Resolution Button
              if (!_isResolved)
                SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton.icon(
                    onPressed: _markAsResolved,
                    icon: CustomIconWidget(
                      iconName: 'check_circle',
                      color: Colors.white,
                      size: 5.w,
                    ),
                    label: Text(
                      'Mark as Resolved',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF27AE60),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshTimeline() async {
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        // Simulate new timeline update
        _timelineEvents.insert(0, {
          "id": _timelineEvents.length + 1,
          "title": "Timeline Updated",
          "description":
              "Latest status refreshed. All helpers remain on standby.",
          "timestamp": DateTime.now(),
          "isAcknowledged": false,
        });
      });
    }
  }

  void _initiateVideoCall(String memberName) {
    HapticFeedback.mediumImpact();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'video_call',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                'Calling $memberName',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Initiating video call with $memberName. This will use WebRTC for secure communication.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showVideoCallInterface(memberName);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Call Now',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showVideoCallInterface(String memberName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Video Call with $memberName',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 6.w,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'video_call',
                        color: Colors.white,
                        size: 15.w,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Connecting to $memberName...',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: Colors.grey[800],
                    child: CustomIconWidget(
                      iconName: 'mic_off',
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () => Navigator.pop(context),
                    backgroundColor: Colors.red,
                    child: CustomIconWidget(
                      iconName: 'call_end',
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: Colors.grey[800],
                    child: CustomIconWidget(
                      iconName: 'videocam_off',
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addEmergencyNote(String note) {
    setState(() {
      _emergencyNotes.insert(0, {
        "id": _emergencyNotes.length + 1,
        "content": note,
        "timestamp": DateTime.now(),
        "type": "text",
      });
    });
  }

  void _markAsResolved() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: const Color(0xFF27AE60),
              size: 6.w,
            ),
            SizedBox(width: 3.w),
            Text(
              'Mark as Resolved',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to mark this emergency as resolved? This will notify all participants.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isResolved = true;
                _timelineEvents.insert(0, {
                  "id": _timelineEvents.length + 1,
                  "title": "Emergency Resolved",
                  "description":
                      "Emergency has been successfully resolved. All participants notified.",
                  "timestamp": DateTime.now(),
                  "isAcknowledged": true,
                });
              });
              HapticFeedback.heavyImpact();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF27AE60),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              'Resolve',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _shareTimeline() {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Share Emergency Timeline',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'message',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text(
                'Send via Message',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'email',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text(
                'Send via Email',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'download',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text(
                'Download PDF',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}




