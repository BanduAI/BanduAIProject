import 'package:flutter/material.dart';
import '../presentation/ai_assistant_chat/ai_assistant_chat.dart';
import '../presentation/emergency_sos/emergency_sos.dart';
import '../presentation/family_emergency_timeline/family_emergency_timeline.dart';
import '../presentation/neighbor_response_tracking/neighbor_response_tracking.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/trusted_services_finder/trusted_services_finder.dart';
import '../presentation/community_memory/community_memory_screen.dart';
import '../presentation/skill_swap/skill_swap_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String aiAssistantChat = '/ai-assistant-chat';
  static const String emergencySos = '/emergency-sos';
  static const String familyEmergencyTimeline = '/family-emergency-timeline';
  static const String neighborResponseTracking = '/neighbor-response-tracking';
  static const String homeDashboard = '/home-dashboard';
  static const String trustedServicesFinder = '/trusted-services-finder';
  static const String communityMemory = '/community-memory';
  static const String skillSwap = '/skill-swap';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const HomeDashboard(),
    aiAssistantChat: (context) => const AiAssistantChat(),
    emergencySos: (context) => const EmergencySos(),
    familyEmergencyTimeline: (context) => const FamilyEmergencyTimeline(),
    neighborResponseTracking: (context) => const NeighborResponseTracking(),
    homeDashboard: (context) => const HomeDashboard(),
    trustedServicesFinder: (context) => const TrustedServicesFinder(),
    communityMemory: (context) => const CommunityMemoryScreen(),
    skillSwap: (context) => const SkillSwapScreen(),
    // TODO: Add your other routes here
  };
}




