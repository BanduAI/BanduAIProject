import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../core/services/gemini_client.dart';
import '../../core/services/gemini_service.dart';
import '../../core/services/localization_service.dart';
import './widgets/chat_header_widget.dart';
import './widgets/chat_input_widget.dart';
import './widgets/chat_message_widget.dart';
import './widgets/quick_suggestions_widget.dart';
import './widgets/voice_input_widget.dart';

class AiAssistantChat extends StatefulWidget {
  const AiAssistantChat({super.key});

  @override
  State<AiAssistantChat> createState() => _AiAssistantChatState();
}

class _AiAssistantChatState extends State<AiAssistantChat>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isOnline = true;
  bool _isVoiceMode = false;
  bool _isTyping = false;
  bool _showSuggestions = true;
  String _selectedLanguage = 'en';

  late GeminiClient _geminiClient;

  @override
  void initState() {
    super.initState();
    _initializeGemini();
    _initializeChat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeGemini() {
    try {
      final geminiService = GeminiService();
      _geminiClient = GeminiClient(geminiService.dio, geminiService.authApiKey);
    } catch (e) {
      debugPrint('Failed to initialize Gemini: $e');
      setState(() {
        _isOnline = false;
      });
    }
  }

  void _initializeChat() {
    final welcomeMessage = _selectedLanguage == 'en'
        ? 'Hello! I am Bandhu Assistant. I am here to help you with community support. You can ask me about local services, emergency help, or any community information.'
        : 'नमस्ते! मैं बंधु असिस्टेंट हूं। मैं आपकी समुदायिक सहायता के लिए यहां हूं। आप मुझसे स्थानीय सेवाओं, आपातकालीन सहायता, या किसी भी सामुदायिक जानकारी के बारे में पूछ सकते हैं।';

    setState(() {
      _messages.add({
        'message': welcomeMessage,
        'isUser': false,
        'timestamp': DateTime.now(),
        'isTyping': false,
      });
    });
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      _showSuggestions = false;
      _messages.add({
        'message': message,
        'isUser': true,
        'timestamp': DateTime.now(),
        'isTyping': false,
      });
      _isTyping = true;
    });

    _scrollToBottom();
    _generateAIResponse(message);
  }

  void _generateAIResponse(String userMessage) async {
    // Add typing indicator
    setState(() {
      _messages.add({
        'message': '',
        'isUser': false,
        'timestamp': DateTime.now(),
        'isTyping': true,
      });
    });

    _scrollToBottom();

    try {
      if (_isOnline) {
        // Use real Gemini API
        final messages = [Message(role: 'user', content: userMessage)];
        final completion = await _geminiClient.createChat(
          messages: messages,
          selectedLanguage: _selectedLanguage,
          temperature: 0.7,
        );

        if (mounted) {
          setState(() {
            _messages.removeLast(); // Remove typing indicator
            _isTyping = false;
            _messages.add({
              'message': completion.text,
              'isUser': false,
              'timestamp': DateTime.now(),
              'isTyping': false,
            });
          });
        }
      } else {
        // Fallback to contextual responses
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          setState(() {
            _messages.removeLast();
            _isTyping = false;
            _messages.add({
              'message': _getContextualResponse(userMessage),
              'isUser': false,
              'timestamp': DateTime.now(),
              'isTyping': false,
            });
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.removeLast();
          _isTyping = false;
          _messages.add({
            'message': _selectedLanguage == 'en'
                ? 'I\'m happy to help you! Please repeat your question.'
                : 'मुझे खुशी होगी आपकी मदद करने में! कृपया अपना प्रश्न दोहराएं।',
            'isUser': false,
            'timestamp': DateTime.now(),
            'isTyping': false,
          });
        });
      }
    }

    _scrollToBottom();
  }

  String _getContextualResponse(String userMessage) {
    final message = userMessage.toLowerCase();

    if (_selectedLanguage == 'en') {
      if (message.contains('emergency') ||
          message.contains('आपातकाल') ||
          message.contains('help') ||
          message.contains('सहायता')) {
        return 'I understand you need emergency help. Please press the SOS button immediately or say "Bandhu, Help!" Your nearby neighbors and emergency services will be notified instantly. Would you like me to show you emergency contacts?';
      }
      if (message.contains('सेवा') ||
          message.contains('service') ||
          message.contains('दुकान')) {
        return 'I can suggest the best options for you.Several trusted services are available in your area:\n\n🏥 Dr. Sharma Clinic - 200 meters\n🛒 Ram Grocery Store - 150 meters\n🔧 Kumar Electrical - 300 meters\n\nAre you looking for a specific service?';
      }
      return 'I\'m here to help you. You can ask me about:\n\n• Emergency assistance\n• Local services and shops\n• Learning and teaching skills\n• Weather information\n• Community activities\n• Family contacts\n\nPlease tell me how I can help you?';
    } else {
      if (message.contains('emergency') ||
          message.contains('help') ||
          message.contains('sos')) {
        return 'मैं समझ गया कि आपको आपातकालीन सहायता चाहिए। तुरंत SOS बटन दबाएं या "बंधु, हेल्प!" कहें। आपके नजदीकी पड़ोसी और आपातकालीन सेवाएं तुरंत सूचित हो जाएंगी। क्या आप चाहते हैं कि मैं आपको आपातकालीन संपर्क दिखाऊं?';
      }
      if (message.contains('service') ||
          message.contains('shop') ||
          message.contains('store')) {
        return 'आपके क्षेत्र में कई विश्वसनीय सेवाएं उपलब्ध हैं:\n\n🏥 डॉ. शर्मा क्लिनिक - 200 मीटर\n🛒 राम किराना स्टोर - 150 मीटर\n🔧 कुमार इलेक्ट्रिकल - 300 मीटर\n\nक्या आप किसी विशेष सेवा की तलाश कर रहे हैं? मैं आपको सबसे अच्छे विकल्प सुझा सकता हूं।';
      }
      return 'मैं आपकी मदद करने के लिए यहां हूं। आप मुझसे निम्नलिखित के बारे में पूछ सकते हैं:\n\n• आपातकालीन सहायता\n• स्थानीय सेवाएं और दुकानें\n• कौशल सीखना और सिखाना\n• मौसम की जानकारी\n• समुदायिक गतिविधियां\n• परिवार से संपर्क\n\nकृपया बताएं कि मैं आपकी कैसे सहायता कर सकता हूं?';
    }
  }

  void _handleVoiceInput(String voiceText) {
    _sendMessage(voiceText);
  }

  void _handleImageSelected(XFile image) {
    final imageName = _selectedLanguage == 'en' ? 'Photo sent' : 'फोटो भेजी गई';

    setState(() {
      _messages.add({
        'message': '$imageName: ${image.name}',
        'isUser': true,
        'timestamp': DateTime.now(),
        'isTyping': false,
        'hasImage': true,
        'imagePath': image.path,
      });
    });

    _scrollToBottom();

    // Generate response for image
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        final response = _selectedLanguage == 'en'
            ? 'I have seen your photo. It\'s a nice picture! Would you like to ask something about it or need any help?'
            : 'मैंने आपकी फोटो देखी है। यह एक अच्छी तस्वीर है! क्या आप इसके बारे में कुछ पूछना चाहते हैं या कोई सहायता चाहिए?';

        setState(() {
          _messages.add({
            'message': response,
            'isUser': false,
            'timestamp': DateTime.now(),
            'isTyping': false,
          });
        });
        _scrollToBottom();
      }
    });
  }

  void _handleFileSelected(PlatformFile file) {
    final fileName = _selectedLanguage == 'en' ? 'File sent' : 'फाइल भेजी गई';

    setState(() {
      _messages.add({
        'message': '$fileName: ${file.name}',
        'isUser': true,
        'timestamp': DateTime.now(),
        'isTyping': false,
        'hasFile': true,
        'fileName': file.name,
      });
    });

    _scrollToBottom();

    // Generate response for file
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        final response = _selectedLanguage == 'en'
            ? 'I have received your file. I am examining it and will provide you with useful information soon.'
            : 'मैंने आपकी फाइल प्राप्त की है। मैं इसकी जांच कर रहा हूं और जल्द ही आपको उपयोगी जानकारी दूंगा।';

        setState(() {
          _messages.add({
            'message': response,
            'isUser': false,
            'timestamp': DateTime.now(),
            'isTyping': false,
          });
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSuggestionTap(String suggestion) {
    _sendMessage(suggestion);
  }

  void _minimizeChat() {
    Navigator.pop(context);
  }

  void _onLanguageChanged(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    // Reinitialize chat with new language
    _messages.clear();
    _initializeChat();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Column(
        children: [
          // Chat Header
          ChatHeaderWidget(
            isOnline: _isOnline,
            isVoiceMode: _isVoiceMode,
            onVoiceModeToggle: (isVoice) {
              setState(() {
                _isVoiceMode = isVoice;
              });
            },
            onMinimize: _minimizeChat,
          ),

          // Chat Messages
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return ChatMessageWidget(
                        message: message['message'] as String,
                        isUser: message['isUser'] as bool,
                        timestamp: message['timestamp'] as DateTime,
                        isTyping: message['isTyping'] as bool? ?? false,
                      );
                    },
                  ),
          ),

          // Quick Suggestions (shown when no messages or at start)
          if (_showSuggestions && _messages.length <= 1)
            QuickSuggestionsWidget(
              onSuggestionTap: _handleSuggestionTap,
            ),

          // Input Area
          if (_isVoiceMode)
            VoiceInputWidget(
              onVoiceInput: _handleVoiceInput,
              onRecordingStart: () {
                HapticFeedback.mediumImpact();
              },
              onRecordingStop: () {
                HapticFeedback.lightImpact();
              },
            )
          else
            ChatInputWidget(
              onSendMessage: _sendMessage,
              onImageSelected: _handleImageSelected,
              onFileSelected: _handleFileSelected,
              isEnabled: !_isTyping,
            ),
        ],
      ),

      // Floating Action Button for Emergency
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        child: FloatingActionButton(
          onPressed: () {
            HapticFeedback.heavyImpact();
            Navigator.pushNamed(context, '/emergency-sos');
          },
          backgroundColor: AppTheme.emergencyLight,
          tooltip:
              _selectedLanguage == 'en' ? 'Emergency SOS' : 'आपातकालीन SOS',
          child: CustomIconWidget(
            iconName: 'emergency',
            color: Colors.white,
            size: 6.w,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryLight,
                    AppTheme.secondaryLight,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15.w),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryLight.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: CustomIconWidget(
                iconName: 'smart_toy',
                color: Colors.white,
                size: 12.w,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              LocalizationService.getLocalizedString(
                  'bandhu_ai', _selectedLanguage),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimaryLight,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              LocalizationService.getLocalizedString(
                  'your_community_assistant', _selectedLanguage),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                color: AppTheme.textSecondaryLight,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}




