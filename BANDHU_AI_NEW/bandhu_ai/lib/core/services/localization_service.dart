import 'package:flutter/material.dart';

class LocalizationService {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Navigation
      'home': 'Home',
      'community': 'Community',
      'profile': 'Profile',

      // Headers
      'bandhu_ai': 'Bandhu AI',
      'community_hub': 'Community Hub',

      // Home Screen
      'good_morning': 'Good Morning',
      'good_afternoon': 'Good Afternoon',
      'good_evening': 'Good Evening',
      'weather_temp': 'Temperature',
      'weather_humidity': 'Humidity',
      'weather_wind': 'Wind',

      // Features
      'emergency_help': 'Emergency Help',
      'find_services': 'Find Services',
      'skill_swap': 'Skill Swap',
      'community_memory': 'Community Memory',
      'ai_assistant': 'AI Assistant',

      // Emergency
      'approaching_neighbours': 'Approaching Neighbours',
      'emergency_contacts': 'Emergency Contacts',
      'trust_safety': 'Trust & Safety',

      // Profile
      'language_settings': 'Language Settings',
      'help_support': 'Help & Support',
      'verified': 'Verified',

      // Actions
      'call': 'Call',
      'view_timeline': 'View Timeline',
      'find_neighbors': 'Find Neighbors',
      'emergency_timeline': 'Emergency Timeline',

      // Descriptions
      'connect_nearby': 'Connect with nearby residents',
      'view_family_updates': 'View family emergency updates',
      'manage_contacts': 'Manage family and emergency contacts',
      'verification_settings': 'Verification and safety settings',
      'change_language': 'Change app language preferences',
      'get_help': 'Get help and contact support',

      // Community Activities
      'recent_activity': 'Recent Activity',
      'community_events': 'Community Events',
      'skill_sharing': 'Skill Sharing',
      'local_news': 'Local News',

      // AI Assistant
      'ai_chat_with': 'Chat with AI Assistant',
      'your_community_assistant':
          'Your personal community assistant\nAsk me for any help',

      // Common
      'cancel': 'Cancel',
      'save': 'Save',
      'edit': 'Edit',
      'delete': 'Delete',
      'share': 'Share',
      'search': 'Search',
      'filter': 'Filter',
      'sort': 'Sort',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'retry': 'Retry',
      'ok': 'OK',
    },
    'hi': {
      // Navigation
      'home': 'होम',
      'community': 'समुदाय',
      'profile': 'प्रोफ़ाइल',

      // Headers
      'bandhu_ai': 'बंधु AI',
      'community_hub': 'समुदायिक केंद्र',

      // Home Screen
      'good_morning': 'सुप्रभात',
      'good_afternoon': 'नमस्कार',
      'good_evening': 'शुभ संध्या',
      'weather_temp': 'तापमान',
      'weather_humidity': 'नमी',
      'weather_wind': 'हवा',

      // Features
      'emergency_help': 'आपातकालीन सहायता',
      'find_services': 'सेवाएं खोजें',
      'skill_swap': 'कौशल आदान-प्रदान',
      'community_memory': 'समुदायिक स्मृति',
      'ai_assistant': 'AI सहायक',

      // Emergency
      'approaching_neighbours': 'पड़ोसी सहायक',
      'emergency_contacts': 'आपातकालीन संपर्क',
      'trust_safety': 'भरोसा और सुरक्षा',

      // Profile
      'language_settings': 'भाषा सेटिंग्स',
      'help_support': 'सहायता और समर्थन',
      'verified': 'सत्यापित',

      // Actions
      'call': 'कॉल करें',
      'view_timeline': 'समयरेखा देखें',
      'find_neighbors': 'पड़ोसी खोजें',
      'emergency_timeline': 'आपातकालीन समयरेखा',

      // Descriptions
      'connect_nearby': 'नजदीकी निवासियों से जुड़ें',
      'view_family_updates': 'पारिवारिक आपातकालीन अपडेट देखें',
      'manage_contacts': 'पारिवारिक और आपातकालीन संपर्क प्रबंधित करें',
      'verification_settings': 'सत्यापन और सुरक्षा सेटिंग्स',
      'change_language': 'ऐप भाषा प्राथमिकताएं बदलें',
      'get_help': 'सहायता प्राप्त करें और समर्थन से संपर्क करें',

      // Community Activities
      'recent_activity': 'हाल की गतिविधि',
      'community_events': 'सामुदायिक कार्यक्रम',
      'skill_sharing': 'कौशल साझाकरण',
      'local_news': 'स्थानीय समाचार',

      // AI Assistant
      'ai_chat_with': 'AI सहायक से चैट करें',
      'your_community_assistant':
          'आपका व्यक्तिगत समुदायिक सहायक\nकिसी भी सहायता के लिए मुझसे पूछें',

      // Common
      'cancel': 'रद्द करें',
      'save': 'सेव करें',
      'edit': 'संपादित करें',
      'delete': 'हटाएं',
      'share': 'साझा करें',
      'search': 'खोजें',
      'filter': 'फ़िल्टर',
      'sort': 'क्रमबद्ध करें',
      'loading': 'लोड हो रहा है...',
      'error': 'त्रुटि',
      'success': 'सफलता',
      'retry': 'पुनः प्रयास करें',
      'ok': 'ठीक है',
    },
  };

  static String getLocalizedString(String key, String languageCode) {
    return _localizedValues[languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  static Map<String, String> getLocalizedStrings(String languageCode) {
    return _localizedValues[languageCode] ?? _localizedValues['en']!;
  }

  static List<Map<String, String>> getSupportedLanguages() {
    return [
      {'code': 'en', 'name': 'English', 'nativeName': 'English'},
      {'code': 'hi', 'name': 'Hindi', 'nativeName': 'हिंदी'},
    ];
  }

  static bool isSupported(String languageCode) {
    return _localizedValues.containsKey(languageCode);
  }
}

// Extension for easy access to localized strings
extension LocalizedContext on BuildContext {
  String t(String key, [String? languageCode]) {
    final locale = languageCode ?? 'en'; // Default to English if not specified
    return LocalizationService.getLocalizedString(key, locale);
  }
}
